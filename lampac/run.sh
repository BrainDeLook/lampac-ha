#!/bin/bash
CONFIG_PATH=/data/options.json

ROOT_PASSWORD=$(jq --raw-output '.root_password' $CONFIG_PATH)
ENABLE_ADMIN=$(jq --raw-output '.enable_admin_panel' $CONFIG_PATH)
ENABLE_RUSSIAN_VOD=$(jq --raw-output '.enable_russian_vod' $CONFIG_PATH)
ENABLE_ANIME=$(jq --raw-output '.enable_anime' $CONFIG_PATH)
ENABLE_ADULT=$(jq --raw-output '.enable_adult' $CONFIG_PATH)
ENABLE_TORRSERVER=$(jq --raw-output '.enable_torrserver' $CONFIG_PATH)
ENABLE_JACRED=$(jq --raw-output '.enable_jacred' $CONFIG_PATH)
ENABLE_TORRENT_OTHER=$(jq --raw-output '.enable_torrent_other' $CONFIG_PATH)
ENABLE_FOREIGN=$(jq --raw-output '.enable_foreign' $CONFIG_PATH)
ENABLE_UKRAINE=$(jq --raw-output '.enable_ukraine' $CONFIG_PATH)

echo "Starting Lampac NextGen..."

echo "${ROOT_PASSWORD}" > /lampac/passwd
echo "Root password configured"

SKIP_MODULES='"Catalog","DLNA","Tracks","Transcoding","CacheMedia","ProxyLimiter","ForkPlayerXML","MsxNative","TelegramAuth","TelegramAuthBot"'

# Русские VOD (Kinoflix, Vibix, Collaps, Zetflix, Rezka, Filmix, Alloha, Kodik, HDVB и др.)
if [ "$ENABLE_RUSSIAN_VOD" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"Kinoflix\",\"Vibix\",\"Collaps\",\"Zetflix\",\"Kinobase\",\"Kinotochka\",\"PizdatoeHD\",\"Mirage\",\"Phantom\",\"CDNvideohub\",\"Videoseed\",\"RutubeMovie\",\"Spectre\",\"FlixCDN\",\"VeoVeo\",\"VkMovie\",\"Kinogo\",\"LeProduction\",\"VideoDB\",\"HDVB\",\"ZetflixDB\",\"FanCDN\",\"Kodik\",\"Alloha\",\"GetsTV\",\"SakhTV\",\"KinoPub\",\"IptvOnline\",\"Rezka\",\"iRemux\",\"VoKino\",\"Filmix\""
fi

# Аниме
if [ "$ENABLE_ANIME" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"AnimeLib\",\"Mikai\",\"AniLibria\",\"AnimeGo\",\"Dreamerscast\",\"AnimeON\",\"AniMedia\",\"Animebesst\",\"AniLiberty\",\"Animevost\",\"MoonAnime\""
fi

# 18+
if [ "$ENABLE_ADULT" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"HQporner\",\"Chaturbate\",\"Runetki\",\"PornHub\",\"Tizam\",\"Xnxx\",\"Porntrex\",\"Eporner\",\"BongaCams\",\"Xvideos\",\"Xhamster\",\"Spankbang\",\"Ebalovo\",\"SISI\""
fi

# TorrServer
if [ "$ENABLE_TORRSERVER" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"TorrServer\""
fi

# JacRed
if [ "$ENABLE_JACRED" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"JacRed\""
fi

# Остальные торренты
if [ "$ENABLE_TORRENT_OTHER" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"PidTor\""
fi

# Зарубежные
if [ "$ENABLE_FOREIGN" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"PlayEmbed\",\"SmashyStream\",\"TwoEmbed\",\"RgShows\",\"VidSrc\",\"AutoEmbed\",\"MovPI\",\"VidLink\",\"HydraFlix\""
fi

# Украинские
if [ "$ENABLE_UKRAINE" = "false" ]; then
    SKIP_MODULES="$SKIP_MODULES,\"HdvbUA\",\"UaKino\",\"Eneyida\",\"KinoUkr\",\"Tortuga\",\"Ashdi\",\"UAFilm\""
fi

# AdminPanel
if [ "$ENABLE_ADMIN" = "true" ]; then
    MANIFEST="/lampac/module/AdminPanel/manifest.json"
    if [ -f "$MANIFEST" ]; then
        jq '.enable = true' "$MANIFEST" > /tmp/manifest.json && mv /tmp/manifest.json "$MANIFEST"
        echo "AdminPanel module enabled"
    fi
else
    SKIP_MODULES="$SKIP_MODULES,\"AdminPanel\""
fi

if [ ! -f /lampac/init.conf ]; then
    cat > /lampac/init.conf << CONF
{
  "listen": {
    "port": 19118
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
