#!/bin/bash
CONFIG_PATH=/data/options.json

ROOT_PASSWORD=$(jq --raw-output '.root_password' $CONFIG_PATH)
ENABLE_ADMIN=$(jq --raw-output '.enable_admin_panel' $CONFIG_PATH)
ENABLE_TORRSERVER=$(jq --raw-output '.enable_torrserver' $CONFIG_PATH)

echo "Starting Lampac NextGen..."

echo "${ROOT_PASSWORD}" > /lampac/passwd
echo "Root password configured"

# Системные модули — всегда отключены (не зависят от настроек пользователя)
SKIP_MODULES='"Catalog","DLNA","Tracks","Transcoding","CacheMedia","ProxyLimiter","ForkPlayerXML","MsxNative","TelegramAuth","TelegramAuthBot","WebLog","GStreamer","Tg-notify.bot","LogUserRequest-Lite"'

# TorrServer
if [ "$ENABLE_TORRSERVER" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"TorrServer\""
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
    SKIP_MODULES="$SKIP_MODULES,\"AdminPanel\""
    OPENSTAT_ENABLE="false"
fi

# Дополнительные модули из списка extra_skip_modules
EXTRA=$(jq -r '.extra_skip_modules[]? | "\"" + . + "\""' $CONFIG_PATH | paste -sd ',' -)
if [ -n "$EXTRA" ]; then
    SKIP_MODULES="$SKIP_MODULES,$EXTRA"
    echo "Extra skip modules: $EXTRA"
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
  "online": {
    "name": "Lampac NextGen",
    "spiderName": "Lampac NextGen",
    "btn_priority_forced": true
  },
  "sisi": {
    "NextHUB": true,
    "history": {
      "enable": false
    }
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
