#!/bin/bash
set -euo pipefail

CONFIG_PATH="/data/options.json"
LAMPAC_CONFIG="/data/init.conf"

ROOT_PASSWORD=$(jq -r '.root_password // "changeme"' "$CONFIG_PATH")
ENABLE_ADMIN=$(jq -r '.enable_admin_panel != false' "$CONFIG_PATH")
ENABLE_TORRSERVER=$(jq -r '.enable_torrserver // false' "$CONFIG_PATH")

echo "Starting Lampac NextGen..."
printf '%s\n' "$ROOT_PASSWORD" > /lampac/passwd
chmod 600 /lampac/passwd
echo "Root password configured"

# Lampac writes user state relative to the working directory and replaces some
# files atomically. Run in /data so those renames land on the persistent volume.
# Keep application binaries in the image and expose resources used by relative paths.
for directory in database cache logs; do
    mkdir -p "/data/$directory"
    if [[ -d "/lampac/$directory" && ! -L "/lampac/$directory" ]]; then
        cp -an "/lampac/$directory/." "/data/$directory/"
        mv -T "/lampac/$directory" "/lampac/.image-$directory"
    fi
    ln -sfnT "/data/$directory" "/lampac/$directory"
done

mkdir -p /lampac/mods
for resource in .playwright appsettings.Production.json base.conf data isdocker mods module passwd plugins wwwroot; do
    ln -sfnT "/lampac/$resource" "/data/$resource"
done

# Modules required for a small but functional Lampac/Lampa installation stay on.
# Resource-heavy and specialist system modules are intentionally not exposed in
# the Home Assistant selector and are always disabled.
SYSTEM_SKIP_MODULES=(
    Catalog
    DLNA
    Tracks
    Transcoding
    CacheMedia
    ProxyLimiter
    ForkPlayerXML
    MsxNative
    TelegramAuth
    TelegramAuthBot
)

mapfile -t EXTRA_SKIP_MODULES < <(jq -r '.extra_skip_modules[]? | if . == "Tg-notify.bot" then "SeriesNotify" else . end' "$CONFIG_PATH")
SKIP_MODULES=("${SYSTEM_SKIP_MODULES[@]}" "${EXTRA_SKIP_MODULES[@]}")

# These modules were absent or inactive before 1.91.1. An explicit allow list
# keeps them off even when Supervisor supplies a saved, older skip list.
mapfile -t OPT_IN_SKIP_MODULES < <(
    jq -r '(["NinePeso", "QRAuth", "OidcAuth"] - (.extra_enable_modules // []))[]' "$CONFIG_PATH"
)
SKIP_MODULES+=("${OPT_IN_SKIP_MODULES[@]}")

contains_module() {
    local wanted="$1"
    local module

    for module in "${SKIP_MODULES[@]}"; do
        if [[ "$module" == "$wanted" ]]; then
            return 0
        fi
    done

    return 1
}

set_manifest_state() {
    local module="$1"
    local enabled="$2"
    local manifest
    local temporary
    local found=false

    while IFS= read -r -d '' manifest; do
        found=true
        temporary=$(mktemp "${manifest}.XXXXXX")
        jq --argjson enabled "$enabled" '.enable = $enabled' "$manifest" > "$temporary"
        mv "$temporary" "$manifest"
    done < <(find /lampac/module -type f -path "*/${module}/manifest.json" -print0)

    if [[ "$found" == true ]]; then
        echo "$module manifest enabled=$enabled"
    else
        echo "Warning: $module manifest not found"
    fi
}

# These upstream modules ship with manifest.enable=false. Keep their manifest
# state in sync with the HA disabled-module selector so removing a module from
# the list actually enables it.
MANIFEST_MANAGED_MODULES=(DatabaseEditor Music Telemetry WatchTogether LogUserRequest-Lite XvideosRED SeriesNotify QRAuth OidcAuth)
for module in "${MANIFEST_MANAGED_MODULES[@]}"; do
    if contains_module "$module"; then
        set_manifest_state "$module" false
    else
        set_manifest_state "$module" true
    fi
done

if [[ "$ENABLE_TORRSERVER" == "false" ]]; then
    SKIP_MODULES+=(TorrServer)
fi

if [[ "$ENABLE_ADMIN" == "true" ]]; then
    set_manifest_state AdminPanel true
    OPENSTAT_ENABLE=true
else
    SKIP_MODULES+=(AdminPanel)
    set_manifest_state AdminPanel false
    OPENSTAT_ENABLE=false
fi

# Remove duplicates while keeping the first occurrence. This also produces a
# safe JSON array without hand-building quoted configuration values.
SKIP_MODULES_JSON=$(
    printf '%s\n' "${SKIP_MODULES[@]}" |
        jq -Rsc 'split("\n") | map(select(length > 0)) | reduce .[] as $item ([]; if index($item) then . else . + [$item] end)'
)

# Keep init.conf in /data so AdminPanel edits survive add-on updates. Only the
# settings owned by the HA configuration panel are refreshed on each start.
if [[ ! -f "$LAMPAC_CONFIG" ]]; then
    jq -n \
        --argjson openstat "$OPENSTAT_ENABLE" \
        --argjson skip_modules "$SKIP_MODULES_JSON" \
        '{
            listen: {port: 19118},
            openstat: {enable: $openstat},
            TorrServer: {url: ""},
            online: {
                name: "Lampac NextGen",
                spiderName: "Lampac NextGen",
                btn_priority_forced: true
            },
            sisi: {
                NextHUB: true,
                history: {enable: false}
            },
            BaseModule: {SkipModules: $skip_modules}
        }' > "$LAMPAC_CONFIG"
    echo "Created persistent init.conf"
else
    temporary=$(mktemp /data/.init.conf.XXXXXX)
    jq \
        --argjson openstat "$OPENSTAT_ENABLE" \
        --argjson skip_modules "$SKIP_MODULES_JSON" \
        '
            .openstat.enable = $openstat
            | .BaseModule.SkipModules = $skip_modules
            | if has("TelegramBot") then .SeriesNotify = (.SeriesNotify // .TelegramBot) | del(.TelegramBot) else . end
        ' \
        "$LAMPAC_CONFIG" > "$temporary"
    mv "$temporary" "$LAMPAC_CONFIG"
    echo "Updated HA-managed settings in persistent init.conf"
fi

mkdir -p /run/nginx
nginx
echo "Nginx started"

echo "Starting Lampac on internal port 19118..."
cd /data
exec /usr/share/dotnet/dotnet /lampac/Core.dll
