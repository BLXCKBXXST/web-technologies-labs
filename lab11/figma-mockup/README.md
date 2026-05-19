# HTML-каркас макета для импорта в Figma

15 HTML-файлов со статичным макетом сайта чемпионата по фиджитал-футболу «PHYGITAL FC» — 5 страниц × 3 ширины. Каждый файл самодостаточный: CSS встроен в `<style>`, картинки вшиты как `data:image/jpeg;base64,...`, шрифты подгружаются с Google Fonts.

| Файл | Ширина | Сетка |
|---|---|---|
| [desktop/](desktop/) | 1440 px | 12 колонок, margin 80 px, gutter 24 px |
| [tablet/](tablet/)   | 768 px  | 6 колонок, margin 32 px, gutter 16 px |
| [mobile/](mobile/)   | 360 px  | 4 колонки, margin 16 px, gutter 8 px |

Пять страниц в каждой ширине:

| Файл | Содержимое |
|---|---|
| `home.html`       | Hero-блок чемпионата, ближайшие матчи, новости, футер |
| `team.html`       | Обложка клуба «NSK Phantoms», статистика, состав, история |
| `player.html`     | Профиль игрока «delta_10»: портрет, статистика, медиа |
| `tournament.html` | Турнирная таблица группы A + плей-офф bracket |
| `shop.html`       | Магазин: вкладка «Билеты» (выбор матча, тип билета, sticky-summary) + каталог сувениров |

Стиль — hybrid (gradient + glassmorphism): deep-navy `#0B1024` → `#11183A` градиент, акценты electric-blue `#3A8DFF` и lime `#C7FF4F`, полупрозрачные карточки с `backdrop-filter: blur(20px)`. Шрифты — Space Grotesk (заголовки), Inter (текст), JetBrains Mono (статистика).

## Локальный просмотр

```bash
xdg-open desktop/home.html
xdg-open tablet/home.html
xdg-open mobile/home.html
```

Картинки вшиты как base64, поэтому HTML-файлы открываются без интернета (только шрифты Google Fonts тянутся при наличии сети).

## Пересборка HTML после замены картинок

Если ты заменил JPG-файлы в [img/](img/) (например, нагенерил их в визуальной AI-модели по [img/PROMPTS.md](img/PROMPTS.md)):

```bash
python3 build.py
```

Скрипт перечитает все `*.jpg` из `img/`, перекодирует их в base64 и пересоберёт все 15 HTML-файлов. Имена картинок жёстко привязаны к таблице — менять нельзя, иначе HTML их не найдёт.

## Импорт в Figma

1. Открыть Figma → создать пустой файл `Lab 11 — PHYGITAL FC`.
2. Установить плагин [html.to.design](https://www.figma.com/community/plugin/1159123024924461424/html-to-design).
3. На левой панели создать 5 страниц: `Главная`, `Команда`, `Участник`, `Турнирная таблица`, `Магазин`.
4. Для каждой страницы Figma:
   - `Plugins → html.to.design → Run` → вкладка **Upload file**.
   - Загрузить три HTML соответствующей темы: `desktop/<page>.html` (`Viewport width: 1440`), `tablet/<page>.html` (`768`), `mobile/<page>.html` (`360`). Импорт по очереди.
5. В диалоге **Import options** включить только три тумблера:
   - ✅ **Use Autolayout** — без него `Constraints` и `Layout grid` потом не лягут.
   - ✅ **Create styles & variables** — CSS-переменные превратятся в Figma Variables (палитра/типографика в правой панели).
   - ✅ **HTML layer names** — имена классов станут именами слоёв (`site-header`, `hero`, `card-match`, …).
   - ❌ Use existing local styles · For hover effects · High-res images (PRO) · Add hyperlinks — оставить выключенными.
6. После импорта расположить три фрейма каждой страницы в ряд и подписать `Desktop / Tablet / Mobile`. Получится сетка `5 страниц × 3 ширины = 15 фреймов`, по три на каждой странице файла.

## Доводка в Figma (требования методички)

После импорта плагин даёт фреймы с Auto-Layout, но учебная часть лабы — настроить:

- **Layout grid** на корневом фрейме каждой страницы: тип `Columns`, count `12/6/4`, margin `80/32/16`, gutter `24/16/8`.
- **Constraints** для ключевых блоков: шапка/футер `Left & Right + Top/Bottom`, Hero `Left & Right + Top`, ряды карточек `Left & Right + Top`, внутри карточек — `Scale`, sticky-summary магазина — `Right + Top`.
- **Карточка матча / товара → Component**: первую `Ctrl+Alt+K`, остальные через `Instance`.
- **Заменить картинки** на финальные (если хочется): плагин Unsplash → ключевые слова `esports football`, `arena`, `championship`. Либо оставить как есть, если AI-генерация по [img/PROMPTS.md](img/PROMPTS.md) уже даёт нужный визуал.
- **Иконки** при желании заменить из Figma Community (Phosphor / Lucide / Heroicons).
- **Share**: `Anyone with the link → can view` → URL вставить в [`../latex-report/parts/chap3.tex`](../latex-report/parts/chap3.tex) (раздел «Готовый макет в Figma»).

## Семантические имена секций

Имена классов в HTML → имена фреймов в Figma после импорта:

- `site-header` — шапка с лого, навигацией и иконками
- `hero` / `team-hero` / `player-head` — главные обложки соответствующих страниц
- `card-match`, `card-news`, `card-player`, `card-merch` — карточки
- `grid-match`, `grid-news`, `grid-player`, `grid-merch`, `grid-stats` — сетки карточек
- `glass` / `glass-strong` — glassmorphism-плашки
- `bracket`, `bracket-col`, `bracket-match` — сетка плей-офф
- `standings` — таблица турнира
- `tabs-row`, `tab` — вкладки магазина
- `shop-layout`, `summary` — раскладка страницы билетов
- `ticket-type` — карточка выбора типа билета
- `site-footer` — футер

## Картинки в `img/`

В папке лежат 27 JPG-плейсхолдеров и [PROMPTS.md](img/PROMPTS.md) — промты для генерации финальных изображений в визуальной AI-модели. Текущие плейсхолдеры — рабочие заглушки в нужной палитре, чтобы каркас был визуально читаемым. Финальные картинки генерятся по промтам, складываются в эту же папку под теми же именами, после чего нужно один раз запустить `python3 build.py` — HTML-файлы пересоберутся с новыми base64.

## Build-скрипт

[`build.py`](build.py) — единственный исполняемый файл каркаса. Что делает:

1. Читает все `*.jpg` из `img/`, кодирует в base64.
2. По шаблонам собирает 15 HTML (5 страниц × 3 ширины) с разными CSS-настройками для каждой ширины (количество колонок в карточках, кегли, видимость навигации).
3. Записывает результат в `desktop/`, `tablet/`, `mobile/`.

Запускается одной командой, без аргументов. Никакие сторонние пакеты не нужны (только стандартная библиотека Python 3).
