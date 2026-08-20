#!/bin/bash
set -euo pipefail

CONFIG_PATH="/data/options.json"
LAMPAC_CONFIG="/data/init.conf"
RUNTIME_CONFIG="/lampac/init.conf"

ROOT_PASSWORD=$(jq -r '.root_password // "changeme"' "$CONFIG_PATH")
ENABLE_ADMIN=$(jq -r '.enable_admin_panel // true' "$CONFIG_PATH")
ENABLE_TORRSERVER=$(jq -r '.enable_torrserver // false' "$CONFIG_PATH")

echo "Starting Lampac NextGen..."
printf '%s\n' "$ROOT_PASSWORD" > /lampac/passwd
chmod 600 /lampac/passwd
echo "Root password configured"

persist_directory() {
    local name="$1"
    local runtime_path="/lampac/$name"
    local data_path="/data/$name"

    mkdir -p "$data_path"
    if [[ -d "$runtime_path" && ! -L "$runtime_path" ]]; then
        cp -a "$runtime_path/." "$data_path/"
        rm -rf "$runtime_path"
    fi
    ln -sfn "$data_path" "$runtime_path"
}

persist_file() {
    local name="$1"
    local runtime_path="/lampac/$name"
    local data_path="/data/$name"

    if [[ -f "$runtime_path" && ! -e "$data_path" ]]; then
        cp -a "$runtime_path" "$data_path"
    fi
    rm -f "$runtime_path"
    ln -sfn "$data_path" "$runtime_path"
}

# Lampac stores user state beside Core.dll. Redirect it to the add-on data
# volume so databases, generated content, and account state survive upgrades.
for directory in database cache logs; do
    persist_directory "$directory"
done
for file in users.json current.conf; do
    persist_file "$file"
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

mapfile -t EXTRA_SKIP_MODULES < <(jq -r '.extra_skip_modules[]?' "$CONFIG_PATH")
SKIP_MODULES=("${SYSTEM_SKIP_MODULES[@]}" "${EXTRA_SKIP_MODULES[@]}")

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
        temporary=$(mktemp)
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
MANIFEST_MANAGED_MODULES=(DatabaseEditor Music Telemetry)
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
    temporary=$(mktemp)
    jq \
        --argjson openstat "$OPENSTAT_ENABLE" \
        --argjson skip_modules "$SKIP_MODULES_JSON" \
        '.openstat.enable = $openstat | .BaseModule.SkipModules = $skip_modules' \
        "$LAMPAC_CONFIG" > "$temporary"
    mv "$temporary" "$LAMPAC_CONFIG"
    echo "Updated HA-managed settings in persistent init.conf"
fi

ln -sfn "$LAMPAC_CONFIG" "$RUNTIME_CONFIG"

mkdir -p /run/nginx
nginx
echo "Nginx started"

echo "Starting Lampac on internal port 19118..."
cd /lampac
exec /usr/share/dotnet/dotnet Core.dll
