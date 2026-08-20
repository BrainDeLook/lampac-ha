# Lampac NextGen — Дополнение для Home Assistant

[🇬🇧 English version](README.md)

[![GitHub Release](https://img.shields.io/github/release/BrainDeLook/lampac-ha.svg?style=for-the-badge)](https://github.com/BrainDeLook/lampac-ha/releases)
[![License](https://img.shields.io/github/license/BrainDeLook/lampac-ha.svg?style=for-the-badge)](LICENSE)

![Lampac NextGen Logo](lampac/logo.png)

Дополнение для Home Assistant на основе [Lampac NextGen](https://github.com/lampac-nextgen/lampac) — самохостируемый бэкенд для агрегации ссылок с 60+ VOD-провайдеров для плеера [Lampa](https://lampa.mx).

## Возможности

- 🎬 60+ VOD провайдеров
- 🛠️ **AdminPanel** встроена — управляй модулями и конфигом через веб-интерфейс
- 📊 Дашборд статистики включён
- 🔄 Автообновления через GitHub Actions
- 💾 Сохранение данных между перезапусками

## Установка

### Установка в один клик

[![Добавить репозиторий в Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2FBrainDeLook%2Flampac-ha)

1. Нажми кнопку выше чтобы добавить репозиторий в Home Assistant
2. Перейди в **Настройки → Дополнения → Магазин дополнений**
3. Найди **Lampac NextGen** и нажми **Установить**
4. Настрой дополнение
5. Нажми **Запустить**

### Ручная установка

1. Перейди в **Настройки → Дополнения → Магазин дополнений**
2. Нажми три точки (⋮) → **Репозитории**
3. Добавь: `https://github.com/BrainDeLook/lampac-ha`
4. Найди **Lampac NextGen** и установи

## Конфигурация

| Параметр | Описание | По умолчанию |
|----------|----------|--------------|
| `root_password` | Пароль для AdminPanel | `changeme` |
| `enable_admin_panel` | Включить AdminPanel + Статистику | `true` |
| `enable_torrserver` | Включить интеграцию с TorrServer | `false` |
| `extra_skip_modules` | Мультиселектор отключённых необязательных модулей | все необязательные модули |

## Как включить модули

По умолчанию **все необязательные модули отключены**. Чтобы включить нужные:

1. Перейди в **Настройки → Дополнения → Lampac NextGen → Конфигурация**
2. Найди список `extra_skip_modules`
3. **Удали** названия модулей которые хочешь включить
4. Нажми **Сохранить** и перезапусти дополнение

Дополнение синхронизирует и `BaseModule.SkipModules`, и upstream-манифесты. Без этого `Music`, `Telemetry` и `DatabaseEditor`, у которых `manifest.enable=false`, невозможно было бы реально включить из панели HA.

---

## Справочник модулей

> ⚠️ **Внимание:** Модули с пометкой 🔒 являются **системными** — не добавляй их в `SkipModules`, иначе дополнение может перестать работать.

---

### 🔒 Системные модули (всегда отключены, не настраиваются)

Эти модули отключены на системном уровне и не управляются через `extra_skip_modules`.

| Модуль | Назначение |
|--------|-----------|
| `Catalog` | Каталог |
| `DLNA` | DLNA сервер |
| `Tracks` | Субтитры и аудиодорожки |
| `Transcoding` | Перекодирование видео |
| `CacheMedia` | Кэширование медиа |
| `ProxyLimiter` | Ограничитель прокси |
| `ForkPlayerXML` | Интерфейс ForkPlayer XML |
| `MsxNative` | Нативный интерфейс MSX |
| `TelegramAuth` | Авторизация через Telegram |
| `TelegramAuthBot` | Бот авторизации Telegram |

### ✅ Всегда активные модули (не добавлять в список отключения)

| Модуль | Назначение |
|--------|-----------|
| `Online` | Основной движок маршрутизации для всех VOD источников |
| `SyncEvents` | Синхронизация событий между модулями |
| `Storage` | Сервис хранения данных |
| `TimeCode` | Сохранение позиции воспроизведения |
| `CorsMedia` | CORS прокси для медиапотоков |
| `CubProxy` | Прокси-сервис |
| `Corseu` | EU CORS прокси |
| `TmdbProxy` | Прокси TMDB API (постеры, метаданные) |
| `Kit` | Базовый инструментарий |
| `LampaWeb` | Веб-интерфейс Lampa |

---

### 🎬 Русские VOD

Чтобы включить — удали название модуля из `SkipModules` в `init.conf`.

| Модуль | Описание | Примечания |
|--------|----------|------------|
| `Rezka` | HDRezka — крупнейший русскоязычный VOD | Популярный, рекомендуется |
| `Filmix` | Filmix | Требует токен |
| `Kodik` | Kodik CDN агрегатор | Требует токен |
| `Alloha` | Alloha CDN | Хорошее качество |
| `HDVB` | HDVB CDN | |
| `Collaps` | Collaps CDN | |
| `Zetflix` | Zetflix CDN | |
| `ZetflixDB` | База данных Zetflix | |
| `Vibix` | Vibix CDN | |
| `Kinoflix` | Kinoflix | |
| `Kinogo` | Kinogo | |
| `Kinobase` | Kinobase | |
| `Kinotochka` | Kinotochka | |
| `VoKino` | VoKino | |
| `KinoPub` | KinoPub | Требует подписку |
| `IptvOnline` | IPTV Online | |
| `GetsTV` | Gets.tv | |
| `SakhTV` | SakhTV | |
| `iRemux` | iRemux | |
| `CDNvideohub` | CDNvideohub | |
| `Videoseed` | Videoseed | |
| `RutubeMovie` | Фильмы на Rutube | |
| `Mirage` | Mirage CDN | |
| `Phantom` | Phantom CDN | |
| `PizdatoeHD` | PizdatoeHD | |
| `Spectre` | Spectre CDN | |
| `FlixCDN` | FlixCDN | |
| `VeoVeo` | VeoVeo | |
| `VkMovie` | VK Видео | |
| `LeProduction` | LeProduction | |
| `VideoDB` | VideoDB | |
| `FanCDN` | FanCDN | |
| `Potok` | Potok.rip | |

---

### 🇺🇦 Украинские источники

| Модуль | Описание |
|--------|----------|
| `UaKino` | UaKino |
| `HdvbUA` | HDVB Украина |
| `Eneyida` | Eneyida |
| `KinoUkr` | KinoUkr |
| `Tortuga` | Tortuga |
| `Ashdi` | Ashdi |
| `UAFilm` | UAFilm |
| `Geosaitebi` | Geosaitebi (Грузия) |
| `AsiaGe` | AsiaGe (Грузия) |

---

### 🌍 Зарубежные (англоязычные)

| Модуль | Описание |
|--------|----------|
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

### 🎌 Аниме

| Модуль | Описание |
|--------|----------|
| `AniLibria` | AniLibria |
| `AnimeGo` | AnimeGo |
| `AnimeLib` | AnimeLib |
| `AiLiberty` | AiLiberty (добавлен в 1.38.0) |
| `AniMedia` | AniMedia |
| `Mikai` | Mikai |
| `Dreamerscast` | Dreamerscast |
| `AnimeON` | AnimeON |
| `Animebesst` | Animebesst |
| `AniLiberty` | AniLiberty |
| `Animevost` | Animevost |
| `MoonAnime` | MoonAnime |

---

### 🤝 Совместный просмотр / Функции

| Модуль | Описание |
|--------|----------|
| `NextHUB` | Хаб плагинов Lampa |
| `Sync` | Синхронизация конфига между устройствами |
| `WatchTogether` | Сеансы совместного просмотра |
| `WebLog` | Логирование HTTP-запросов |
| `GStreamer` | Медиапайплайн GStreamer |
| `Tg-notify.bot` | Бот уведомлений Telegram |
| `LogUserRequest-Lite` | Лёгкий логгер запросов |
| `Telemetry` | Локальная панель телеметрии (добавлен в 1.39.0) |
| `Music` | Поиск и воспроизведение музыки (добавлен в 1.42.0) |
| `DatabaseEditor` | Веб-редактор баз SQLite (добавлен в 1.42.6) |

`AiLiberty`, `Telemetry`, `Music` и `DatabaseEditor` — все новые модули оригинального Lampac NextGen между версиями `1.37.7` и `1.47.2`. По умолчанию все четыре выключены.

---

### 🧲 Торренты

| Модуль | Описание | Примечания |
|--------|----------|------------|
| `TorrServer` | Интеграция с TorrServer | Включается переключателем в конфиге |
| `JacRed` | JacRed — агрегатор торрент-индексаторов | |
| `PidTor` | PidTor — стриминг через торрент | |

---

### 🔞 Для взрослых (18+)

| Модуль | Описание |
|--------|----------|
| `SISI` | SISI агрегатор 18+ |
| `PornHub` | PornHub |
| `HQporner` | HQporner |
| `Xvideos` | Xvideos |
| `XvideosRED` | Xvideos RED |
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

После запуска дополнения открой AdminPanel:
```
http://YOUR_HA_IP:9118/adminpanel/auth
```
Пароль: `root_password` из Конфигурации.

## Подключение к Lampa

Добавь Lampac как источник в настройках Lampa:
```
http://YOUR_HA_IP:9118
```

## Благодарности

- [Lampac NextGen](https://github.com/lampac-nextgen/lampac) — оригинальный проект

## Лицензия

MIT
