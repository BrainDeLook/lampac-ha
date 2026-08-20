# Changelog

## 1.47.2 (2026-08-20)

- Update the runtime image to the pinned upstream version `1.47.2`.
- Add every module introduced after `1.37.7` to the Home Assistant disabled-module selector: `AiLiberty`, `Telemetry`, `Music`, and `DatabaseEditor`.
- Keep all four new modules disabled by default.
- Synchronize manifest-disabled modules with the Home Assistant selector so `Music`, `Telemetry`, and `DatabaseEditor` can actually be enabled.
- Persist `init.conf` under `/data` and reapply only Home Assistant-managed settings at startup.
- Add Russian and English names and descriptions to the Home Assistant configuration panel.
- Remove the unused `admin_panel_url` setting; AdminPanel remains available at `/adminpanel/auth` on port `9118`.
- Persist Lampac databases, cache, logs, and account state in the Home Assistant add-on data volume.
- Enable WebSocket proxying and unbuffered media streaming in nginx; remove the unused internal port `8077` listener.
- Pin the upstream container tag and teach the automatic updater to update that tag together with the add-on version.
- Includes upstream LampaWeb/plugin URL fixes from `1.47.2` ([upstream changelog](https://github.com/lampac-nextgen/lampac/releases/tag/1.47.2)).

### Upstream highlights since 1.37.7

- `1.38.0`: new `AiLiberty` anime provider.
- `1.39.0`: new opt-in `Telemetry` module, DLNA request validation, and Telegram notification fixes.
- `1.42.0`: new opt-in `Music` module.
- `1.42.3`–`1.42.7`: WatchTogether reconnect, playback, and speed synchronization improvements; new opt-in `DatabaseEditor` module.
- `1.43.0`: browser runtime migrated from Chromium to Google Chrome.
- `1.44.0`–`1.47.2`: further WatchTogether, NextHUB, Music, dependency, plugin URL, and LampaWeb fixes.

## 1.47.1 (2026-08-19)

- Update to upstream version ([changelog](https://github.com/lampac-nextgen/lampac/releases/tag/1.47.1)).

## 1.47.0 (2026-08-17)

- Update to upstream version; Apple Music country is now configurable in the Music module ([changelog](https://github.com/lampac-nextgen/lampac/releases/tag/1.47.0)).

## 1.46.0 (2026-08-17)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.46.0)


## 1.45.2 (2026-08-08)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.45.2)


## 1.43.0 (2026-08-03)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.43.0)


## 1.42.7 (2026-07-27)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.42.7)


## 1.42.3 (2026-07-20)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.42.3)


## 1.40.0 (2026-07-13)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.40.0)


## 1.37.7 (2026-07-06)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.37.7)


## 1.36.0 (2026-06-30)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.36.0)


## 1.35.18 (2026-06-29)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.18)


## 1.35.17 (2026-06-28)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.17)


## 1.35.15 (2026-06-27)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.15)


## 1.35.12 (2026-06-24)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.12)


## 1.35.10 (2026-06-23)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.10)


## 1.35.9 (2026-06-22)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.9)


## 1.35.5 (2026-06-21)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.5)


## 1.35.4 (2026-06-20)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.4)


## 1.34.0 (2026-06-19)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.34.0)


## 1.35.0-beta.2 (2026-06-18)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.35.0-beta.2)


## 1.34.0 (2026-06-12)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.34.0)


## 1.33.6 (2026-06-10)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.33.6)


## 1.33.4 (2026-06-08)

- Update to upstream version (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.33.4)


## 1.33.2 (2026-06-08)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.33.2)


## 1.33.1 (2026-06-06)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.33.1)


## 1.32.1 (2026-06-05)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.32.1)


## 1.31.2 (2026-06-03)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.31.2)


## 1.30.12 (2026-06-02)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.30.12)


## 1.30.8 (2026-06-01)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.30.8)


## 1.30.5 (2026-05-31)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.30.5)


## 1.30.4 (2026-05-30)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.30.4)


## 1.30.1 (2026-05-29)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.30.1)


## 1.29.22 (2026-05-28)

- Update to latest version from Lampac NextGen (changelog: https://github.com/lampac-nextgen/lampac/releases/tag/1.29.22)

