# Lampac NextGen — Home Assistant Add-on

[🇷🇺 Русская версия](https://github.com/BrainDeLook/lampac-ha/blob/main/README_RU.md)

[![GitHub Release](https://img.shields.io/github/release/BrainDeLook/lampac-ha.svg?style=for-the-badge)](https://github.com/BrainDeLook/lampac-ha/releases)
[![License](https://img.shields.io/github/license/BrainDeLook/lampac-ha.svg?style=for-the-badge)](../LICENSE)

![Lampac NextGen Logo](logo.png)

Home Assistant Add-on for [Lampac NextGen](https://github.com/lampac-nextgen/lampac) — a self-hosted backend that aggregates streaming links from 60+ VOD providers for use with the [Lampa](https://lampa.mx) player.

## Features

- 🎬 60+ VOD providers available
- 🛠️ **AdminPanel** built-in — manage config and modules via web UI
- 📊 Statistics dashboard included
- 🔄 Auto-updates via GitHub Actions
- 💾 Persistent data across restarts

## Installation

### One-click install

[![Add Repository to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FBrainDeLook%2Flampac-ha)

1. Click the button above to add this repository to Home Assistant
2. Go to **Settings → Add-ons → Add-on Store**
3. Find **Lampac NextGen** and click **Install**
4. Configure the add-on
5. Click **Start**

### Manual install

1. Go to **Settings → Add-ons → Add-on Store**
2. Click the three dots (⋮) → **Repositories**
3. Add: `https://github.com/BrainDeLook/lampac-ha`
4. Find **Lampac NextGen** and install

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `root_password` | AdminPanel root password | `changeme` |
| `enable_admin_panel` | Enable AdminPanel + Statistics | `true` |
| `enable_torrserver` | Enable TorrServer integration | `false` |
| `extra_skip_modules` | Multi-select list of disabled optional modules | all optional modules |

## How to Enable Modules

By default **all optional modules are disabled**. To enable one:

1. Open **Settings → Add-ons → Lampac NextGen → Configuration**.
2. In `extra_skip_modules` (**Disabled modules**), remove the module you want to enable.
3. Save and restart the add-on.

The add-on synchronizes both `BaseModule.SkipModules` and upstream module manifests. This is required for `Music`, `Telemetry`, and `DatabaseEditor`, whose upstream manifests are disabled by default.

---

## Module Reference

> ⚠️ **Warning:** Modules marked with 🔒 are **system modules** — do not add them to `SkipModules` or the add-on may stop working.

---

### 🔒 Required core modules (always enabled)

| Module | Purpose |
|--------|---------|
| `Online` | Core routing engine for all VOD sources |
| `SyncEvents` | Event synchronization between modules |
| `Storage` | Data storage service |
| `TimeCode` | Playback position saving |
| `CorsMedia` | CORS proxy for media streams |
| `CubProxy` | Proxy service |
| `Corseu` | EU CORS proxy |
| `TmdbProxy` | TMDB API proxy (posters, metadata) |
| `Kit` | Core toolkit |
| `LampaWeb` | Lampa web UI |

### ⛔ System modules (always disabled)

`Catalog`, `DLNA`, `Tracks`, `Transcoding`, `CacheMedia`, `ProxyLimiter`, `ForkPlayerXML`, `MsxNative`, `TelegramAuth`, and `TelegramAuthBot` are kept off to provide a small Home Assistant installation.

### 🧩 Optional feature modules

| Module | Description | Added upstream |
|--------|-------------|----------------|
| `Telemetry` | Local telemetry dashboard | 1.39.0 |
| `Music` | Music discovery and playback | 1.42.0 |
| `DatabaseEditor` | Browser-based SQLite editor | 1.42.6 |
| `NextHUB` | Lampa plugin hub | existing |
| `Sync` | Configuration synchronization | existing |
| `WatchTogether` | Synchronized viewing rooms | existing |
| `WebLog` | HTTP request log | existing |
| `GStreamer` | Media pipeline | existing |
| `Tg-notify.bot` | Telegram notification bot | existing |
| `LogUserRequest-Lite` | Lightweight request logger | existing |

Together with `AiLiberty` below, the three versioned entries are every new module introduced upstream between `1.37.7` and `1.47.2`. All are disabled by default.

---

### 🎬 Russian VOD

To enable — remove the module name from `SkipModules` in `init.conf`.

| Module | Description | Notes |
|--------|-------------|-------|
| `Rezka` | HDRezka — largest Russian VOD | Popular, recommended |
| `Filmix` | Filmix | Requires token |
| `Kodik` | Kodik CDN aggregator | Requires token |
| `Alloha` | Alloha CDN | Good quality |
| `HDVB` | HDVB CDN | |
| `Collaps` | Collaps CDN | |
| `Zetflix` | Zetflix CDN | |
| `ZetflixDB` | Zetflix database | |
| `Vibix` | Vibix CDN | |
| `Kinoflix` | Kinoflix | |
| `Kinogo` | Kinogo | |
| `Kinobase` | Kinobase | |
| `Kinotochka` | Kinotochka | |
| `VoKino` | VoKino | |
| `KinoPub` | KinoPub | Requires subscription |
| `IptvOnline` | IPTV Online | |
| `GetsTV` | Gets.tv | |
| `SakhTV` | SakhTV | |
| `iRemux` | iRemux | |
| `CDNvideohub` | CDNvideohub | |
| `Videoseed` | Videoseed | |
| `RutubeMovie` | Rutube Movies | |
| `Mirage` | Mirage CDN | |
| `Phantom` | Phantom CDN | |
| `PizdatoeHD` | PizdatoeHD | |
| `Spectre` | Spectre CDN | |
| `FlixCDN` | FlixCDN | |
| `VeoVeo` | VeoVeo | |
| `VkMovie` | VK Video | |
| `LeProduction` | LeProduction | |
| `VideoDB` | VideoDB | |
| `FanCDN` | FanCDN | |

---

### 🇺🇦 Ukrainian Sources

| Module | Description |
|--------|-------------|
| `UaKino` | UaKino |
| `HdvbUA` | HDVB Ukraine |
| `Eneyida` | Eneyida |
| `KinoUkr` | KinoUkr |
| `Tortuga` | Tortuga |
| `Ashdi` | Ashdi |
| `UAFilm` | UAFilm |
| `Geosaitebi` | Geosaitebi (Georgia) |
| `AsiaGe` | AsiaGe (Georgia) |

---

### 🌍 Foreign (English-language)

| Module | Description |
|--------|-------------|
| `VidSrc` | VidSrc |
| `AutoEmbed` | AutoEmbed |
| `PlayEmbed` | PlayEmbed |
| `SmashyStream` | SmashyStream |
| `TwoEmbed` | TwoEmbed |
| `RgShows` | RgShows |
| `MovPI` | MoviesPI |
| `VidLink` | VidLink |
| `HydraFlix` | HydraFlix |
| `Videasy` | Videasy |
| `BamBoo` | BamBoo |

---

### 🎌 Anime

| Module | Description |
|--------|-------------|
| `AniLibria` | AniLibria |
| `AnimeGo` | AnimeGo |
| `AnimeLib` | AnimeLib |
| `AiLiberty` | AiLiberty (added in 1.38.0) |
| `AniMedia` | AniMedia |
| `Mikai` | Mikai |
| `Dreamerscast` | Dreamerscast |
| `AnimeON` | AnimeON |
| `Animebesst` | Animebesst |
| `AniLiberty` | AniLiberty |
| `Animevost` | Animevost |
| `MoonAnime` | MoonAnime |

---

### 🧲 Torrent

| Module | Description | Notes |
|--------|-------------|-------|
| `TorrServer` | TorrServer integration | Enable via toggle in add-on config |
| `JacRed` | JacRed torrent indexer aggregator | |
| `PidTor` | PidTor torrent streaming | |

---

### 🔞 Adult (18+)

| Module | Description |
|--------|-------------|
| `SISI` | SISI adult aggregator |
| `PornHub` | PornHub |
| `HQporner` | HQporner |
| `Xvideos` | Xvideos |
| `Xhamster` | Xhamster |
| `Xnxx` | Xnxx |
| `Chaturbate` | Chaturbate |
| `BongaCams` | BongaCams |
| `Runetki` | Runetki |
| `Eporner` | Eporner |
| `Porntrex` | Porntrex |
| `Spankbang` | Spankbang |
| `Ebalovo` | Ebalovo |
| `Tizam` | Tizam |

---

## AdminPanel

Open AdminPanel at:
```
http://YOUR_HA_IP:9118/adminpanel/auth
```
Password: `root_password` from Configuration.

## Connecting to Lampa

Add Lampac as a source in Lampa settings:
```
http://YOUR_HA_IP:9118
```

## Credits

- [Lampac NextGen](https://github.com/lampac-nextgen/lampac) — original project

## License

MIT
