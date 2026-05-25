#!/bin/bash
CONFIG_PATH=/data/options.json

ROOT_PASSWORD=$(jq --raw-output '.root_password' $CONFIG_PATH)
ENABLE_ADMIN=$(jq --raw-output '.enable_admin_panel' $CONFIG_PATH)
ENABLE_TORRSERVER=$(jq --raw-output '.enable_torrserver' $CONFIG_PATH)
CUSTOM_SKIP=$(jq --raw-output '.custom_skip_modules' $CONFIG_PATH)

echo "Starting Lampac NextGen..."

echo "${ROOT_PASSWORD}" > /lampac/passwd
echo "Root password configured"

# Базовые отключённые модули
SKIP_MODULES='"Catalog","DLNA","Tracks","Transcoding","CacheMedia","ProxyLimiter","ForkPlayerXML","MsxNative","TelegramAuth","TelegramAuthBot","Kinoflix","Vibix","Collaps","Zetflix","Kinobase","Kinotochka","PizdatoeHD","Mirage","Phantom","CDNvideohub","Videoseed","RutubeMovie","Spectre","FlixCDN","VeoVeo","VkMovie","Kinogo","LeProduction","VideoDB","HDVB","ZetflixDB","FanCDN","Kodik","AnimeLib","Mikai","AniLibria","AnimeGo","Dreamerscast","AnimeON","AniMedia","Animebesst","AniLiberty","Animevost","MoonAnime","HQporner","Chaturbate","Runetki","PornHub","Tizam","Xnxx","Porntrex","Eporner","BongaCams","Xvideos","Xhamster","Spankbang","Ebalovo","SISI","PidTor","PlayEmbed","SmashyStream","TwoEmbed","RgShows","VidSrc","AutoEmbed","MovPI","VidLink","HydraFlix","Geosaitebi","BamBoo","AsiaGe","HdvbUA","UaKino","Eneyida","KinoUkr","Tortuga","Ashdi","UAFilm","Alloha","GetsTV","SakhTV","KinoPub","IptvOnline","Rezka","iRemux","VoKino","Filmix","JacRed","Videasy"'

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

# Дополнительные модули из custom_skip_modules
if [ -n "$CUSTOM_SKIP" ] && [ "$CUSTOM_SKIP" != "null" ] && [ "$CUSTOM_SKIP" != "" ]; then
    SKIP_MODULES="$SKIP_MODULES,$CUSTOM_SKIP"
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
