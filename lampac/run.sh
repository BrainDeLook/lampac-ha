#!/bin/bash
CONFIG_PATH=/data/options.json

ROOT_PASSWORD=$(jq --raw-output '.root_password' $CONFIG_PATH)
ENABLE_ADMIN=$(jq --raw-output '.enable_admin_panel' $CONFIG_PATH)
ENABLE_TORRSERVER=$(jq --raw-output '.enable_torrserver' $CONFIG_PATH)

echo "Starting Lampac NextGen..."

echo "${ROOT_PASSWORD}" > /lampac/passwd
echo "Root password configured"

# Модули из мультиселекта (пользователь убирает те, что хочет включить)
SKIP_MODULES=$(jq -r '.skip_modules[]? | "\"" + . + "\""' $CONFIG_PATH | paste -sd ',' -)

# TorrServer
if [ "$ENABLE_TORRSERVER" = "false" ]; then
    if [ -n "$SKIP_MODULES" ]; then
        SKIP_MODULES="$SKIP_MODULES,\"TorrServer\""
    else
        SKIP_MODULES="\"TorrServer\""
    fi
fi

# AdminPanel и Stats
if [ "$ENABLE_ADMIN" = "true" ]; then
    MANIFEST="/lampac/module/AdminPanel/manifest.json"
    if [ -f "$MANIFEST" ]; then
        jq '.enable = true' "$MANIFEST" > /tmp/manifest.json && mv /tmp/manifest.json "$MANIFEST"
        echo "AdminPanel module enabled"
    fi
    OPENSTAT_ENABLE="true"
else
    if [ -n "$SKIP_MODULES" ]; then
        SKIP_MODULES="$SKIP_MODULES,\"AdminPanel\""
    else
        SKIP_MODULES="\"AdminPanel\""
    fi
    OPENSTAT_ENABLE="false"
fi

if [ ! -f /lampac/init.conf ]; then
    cat > /lampac/init.conf << CONF
{
  "listen": {
    "port": 19118
  },
  "openstat": {
    "enable": ${OPENSTAT_ENABLE}
  },
  "TorrServer": {
    "url": ""
  },
  "BaseModule": {
    "SkipModules": [${SKIP_MODULES}]
  }
}
CONF
    echo "Created init.conf"
fi

mkdir -p /run/nginx
nginx
echo "Nginx started"

echo "Starting Lampac on internal port 19118..."
cd /lampac
exec /usr/share/dotnet/dotnet Core.dll
