# Lampac NextGen — Home Assistant Add-on

[🇷🇺 Русская версия](https://github.com/BrainDeLook/lampac-ha/blob/main/README_RU.md)

[![GitHub Release](https://img.shields.io/github/release/BrainDeLook/lampac-ha.svg?style=for-the-badge)](https://github.com/BrainDeLook/lampac-ha/releases)
[![License](https://img.shields.io/github/license/BrainDeLook/lampac-ha.svg?style=for-the-badge)](LICENSE)

![Lampac NextGen Logo](lampac/logo.png)

Home Assistant Add-on for [Lampac NextGen](https://github.com/lampac-nextgen/lampac) — a self-hosted backend that aggregates streaming links from 60+ VOD providers for use with the [Lampa](http://lampa.mx) player.

## Features

- 🎬 60+ VOD providers: Rezka, Filmix, Kodik, Alloha, HDVB and many more
- 🗂️ Module groups with toggle switches — enable only what you need
- 🔞 Adult content disabled by default
- 🛠️ **AdminPanel** built-in — manage config via web UI
- 🔄 Auto-updates via GitHub Actions
- 💾 Persistent data across restarts

## Configuration

| Option | Description | Default |
|--------|-------------|---------|
| `root_password` | AdminPanel root password | `changeme` |
| `admin_panel_url` | AdminPanel URL (replace YOUR_HA_IP) | `http://YOUR_HA_IP:9118/adminpanel/auth` |
| `enable_admin_panel` | Enable AdminPanel module | `true` |
| `enable_russian_vod` | Russian VOD: Rezka, Filmix, Kodik, Alloha, HDVB, etc. | `true` |
| `enable_anime` | Anime sources | `true` |
| `enable_adult` | Adult content (18+) | `false` |
| `enable_torrserver` | TorrServer integration | `true` |
| `enable_jacred` | JacRed torrent indexer | `true` |
| `enable_torrent_other` | Other torrent sources | `true` |
| `enable_foreign` | Foreign sources (VidSrc, AutoEmbed, etc.) | `true` |
| `enable_ukraine` | Ukrainian sources | `true` |

## AdminPanel

After starting the add-on, open AdminPanel at:
```
http://YOUR_HA_IP:9118/adminpanel/auth
```
Use the `root_password` from Configuration to log in.

## Connecting to Lampa

Add Lampac as a source in Lampa settings:
```
http://YOUR_HA_IP:9118
```

## Credits

- [Lampac NextGen](https://github.com/lampac-nextgen/lampac) — original project

## License

MIT
