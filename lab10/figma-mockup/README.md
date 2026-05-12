# HTML-каркас макета для импорта в Figma

Три HTML-файла со статичным макетом интернет-магазина растений «Зелёный дом». Каждый файл — самодостаточный (CSS встроен в `<style>`, картинки с `placehold.co`, шрифты с Google Fonts).

| Файл | Ширина | Сетка |
|---|---|---|
| [desktop.html](desktop.html) | 1440 px | 12 колонок, margin 80 px, gutter 24 px |
| [tablet.html](tablet.html) | 768 px | 6 колонок, margin 32 px, gutter 16 px |
| [mobile.html](mobile.html) | 360 px | 4 колонки, margin 16 px, gutter 8 px |

Стиль — cozy boho: терракот `#C97B5E`, охра `#D9A55A`, олива `#6B7A4B`, крем `#FAF6EE`, тёмно-коричневый `#3A2E22`. Шрифты — Playfair Display (заголовки), Inter (текст), Caveat (рукописные акценты).

## Локальный просмотр

```bash
xdg-open desktop.html
xdg-open tablet.html
xdg-open mobile.html
```

Перед импортом в Figma убедиться, что:
- Картинки загрузились (`placehold.co` живой).
- Шрифты применились (Google Fonts).
- Раскладка не ломается.

## Импорт в Figma

1. Открыть Figma → создать пустой файл `Plant shop — Lab 10`.
2. Установить плагин [html.to.design](https://www.figma.com/community/plugin/1159123024924461424/html-to-design).
3. `Plugins → html.to.design → Run` → вкладка **Upload file**.
4. Загрузить `desktop.html`, в поле **Viewport width** поставить `1440`. Импорт.
5. В диалоге **Import options** включить только три тумблера:
   - ✅ **Use Autolayout** — без него `Constraints` и `Layout grid` потом не лягут.
   - ✅ **Create styles & variables** — CSS-переменные превратятся в Figma Variables (палитра в правой панели).
   - ✅ **HTML layer names** — имена классов станут именами слоёв (`hero`, `product-card`, …).
   - ❌ Use existing local styles · For hover effects · High-res images (PRO) · Add hyperlinks — оставить выключенными.
6. Повторить для `tablet.html` (`768`) и `mobile.html` (`360`) с теми же опциями.
7. Расположить три фрейма в ряд и подписать `Desktop / Tablet / Mobile`.

## Доводка в Figma (требования методички)

После импорта плагин даёт фреймы с Auto-Layout, но учебная часть лабы — настроить:

- **Layout grid** на корневом фрейме: тип `Columns`, count `12/6/4`, margin `80/32/16`, gutter `24/16/8`.
- **Constraints** в карточке товара: фото `Left & Right + Top`, текст `Left & Right`, кнопка `Left & Right + Bottom`.
- **Карточка товара → Component**: первую `Ctrl+Alt+K`, остальные через `Instance` (Right-click → Reset all changes).
- **Заменить картинки**: плагин Unsplash → ввести `monstera`, `ficus`, etc.
- **Иконки** при желании заменить из Figma Community (Phosphor / Lucide).
- **Share**: `Anyone with the link → can view` → URL вставить в `../latex-report/parts/chap3.tex`.

## Семантические имена секций

Имена классов в HTML → имена фреймов в Figma после импорта:

- `site-header` — шапка с лого, навигацией и иконками
- `hero` — обложка с заголовком и CTA
- `categories` — плитки категорий
- `offers` — «Предложения месяца» с карточками товара
- `promo` — оливковый баннер с подпиской
- `site-footer` — футер

## Замена placeholder-картинок на реальные

В HTML картинки используют `placehold.co` с английскими названиями растений (Monstera, Ficus, Calathea и т. д.) — это плейсхолдеры. В Figma после импорта они становятся обычными raster-fill'ами, которые удобно заменить через плагин Unsplash.

Если хочется живые фото уже в HTML-превью — заменить URL вида
`https://placehold.co/300x300/6B7A4B/FAF6EE?text=Monstera`
на прямой URL фото с unsplash.com (например, `https://images.unsplash.com/photo-<id>?w=600&q=80&auto=format&fit=crop`, ID берётся со страницы фото).
