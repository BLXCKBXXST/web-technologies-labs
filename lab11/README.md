# Практическая работа №11
**Веб-дизайн. Создание макета сайта чемпионата по фиджитал-спорту (киберфутбол)**

Дизайн-лаба того же класса, что и [lab10](../lab10/) (Figma, без ВМ и bash-скриптов). В отличие от lab10, где был одностраничный лендинг интернет-магазина, здесь нужно сделать **пять страниц** сайта чемпионата с фирменным стилем и адаптивами. В этой папке лежат: методичка, HTML-каркас макета для импорта в Figma и LaTeX-отчёт.

Тема — гипотетический турнир **PHYGITAL FC** по киберфутболу (FIFA + футбольный матч 5×5), Новосибирск 2024.

---

## 🛠️ Среда

| Что | Где |
|---|---|
| Редактор | [Figma](https://www.figma.com) (веб) или desktop-приложение |
| Плагин импорта | [`html.to.design`](https://www.figma.com/community/plugin/1159123024924461424/html-to-design) — собирает Figma-фреймы из HTML-каркаса |
| Плагин фото | `Unsplash` — для замены плейсхолдеров на тематические снимки (стадион, болельщики, мерч) |
| Иконки | [Figma Community](https://www.figma.com/community), `Phosphor Icons`, `Lucide` |
| Доступ | Бесплатный план `Starter` |

---

## 📋 Задачи

Согласно методичке необходимо разработать пять страниц:

1. **Главная** — анонс турнира, ближайшие матчи, новости, футер.
2. **Команда** — обложка клуба, статистика, состав игроков, история матчей.
3. **Участник** — профиль игрока: портрет, ключевая статистика, последние матчи, соцсети.
4. **Турнирная таблица** — групповой этап и сетка плей-офф.
5. **Магазин** — единая страница с двумя секциями: продажа билетов (выбор матча, тип билета: «только просмотр» или «просмотр + дегустация») и каталог сувенирной продукции с символикой чемпионата.

Каждая страница — в трёх адаптивных версиях с настроенными `Layout grid` и `Constraints`.

---

## 📐 Адаптивы

| Версия | Ширина | Сетка |
|---|---|---|
| Desktop | 1440 px | 12 колонок, margin 80 px, gutter 24 px |
| Tablet  | 768 px  | 6 колонок, margin 32 px, gutter 16 px |
| Mobile  | 360 px  | 4 колонки, margin 16 px, gutter 8 px |

Итого 15 фреймов: 5 страниц × 3 ширины.

---

## 🎨 Фирменный стиль

- **Палитра.** Градиент `#0B1024` → `#11183A` (deep-navy), акценты `#3A8DFF` (electric-blue) и `#C7FF4F` (lime), карточки в стиле glassmorphism (`rgba(255,255,255,0.06)` + `backdrop-filter: blur(20px)` + тонкая обводка).
- **Шрифты.** `Space Grotesk` (заголовки), `Inter` (текст), `JetBrains Mono` (таблицы и статистика).
- **Иконография.** Линейные иконки толщиной 1.5 px (Phosphor / Lucide), синие или белые.

---

## 📁 Структура папки

```
lab11/
├── README.md                       ← этот файл
├── Методичка (lab11).pdf           ← задание преподавателя
│
├── figma-mockup/                   ← HTML-каркас для импорта в Figma
│   ├── README.md                   ← как импортировать в Figma и пересобирать
│   ├── build.py                    ← пересборка 15 HTML из img/ + шаблонов
│   ├── desktop/                    ← home/team/player/tournament/shop.html (1440 px)
│   ├── tablet/                     ← те же 5 страниц (768 px)
│   ├── mobile/                     ← те же 5 страниц (360 px)
│   └── img/                        ← 27 JPG-картинок (base64-вшиты в HTML)
│       └── PROMPTS.md              ← промты для AI-генерации финальных картинок
│
└── latex-report/                   ← LaTeX-отчёт для Overleaf
    ├── main.tex, config.tex, parts/, fonts/, screenshots/, img/
    └── lab11_latex_report.pdf      ← скомпилированный отчёт (появится после компиляции)
```

---

## 🚀 Порядок работы

1. **HTML-каркас.** Открыть [`figma-mockup/desktop/home.html`](figma-mockup/desktop/home.html) в браузере — посмотреть текущий вид. При желании заменить картинки в [`figma-mockup/img/`](figma-mockup/img/) (см. [`PROMPTS.md`](figma-mockup/img/PROMPTS.md)) и пересобрать: `cd figma-mockup && python3 build.py`.
2. **Импорт в Figma.** Установить плагин `html.to.design`, импортировать 15 HTML на 5 страниц файла Figma (детали — в [`figma-mockup/README.md`](figma-mockup/README.md)).
3. **Доводка в Figma.** Настроить `Layout grid` и `Constraints`, заменить плейсхолдеры на финальные изображения через плагин Unsplash, превратить повторяющиеся карточки в Components.
4. **Скриншоты.** Сделать 17 PNG-экспортов из Figma по списку [`latex-report/screenshots/README.md`](latex-report/screenshots/README.md), положить в [`latex-report/img/`](latex-report/img/).
5. **Share-link Figma.** `Share → Anyone with the link can view` → URL вставить в [`latex-report/parts/chap3.tex`](latex-report/parts/chap3.tex) (раздел «Готовый макет в Figma», там стоит `TODO`).
6. **Отчёт.** Скомпилировать `latex-report/` в Overleaf (Compiler: **XeLaTeX**, Main: `main.tex`) → положить итоговый PDF рядом с `main.tex`.

---

## 🔗 Ссылка на Figma

> **TODO:** вставить URL общего доступа к Figma-файлу (Share → `Anyone with the link can view`).

Эту же ссылку нужно подставить в `latex-report/parts/chap3.tex`.

---

## 📤 Формат сдачи

PDF-отчёт (скомпилированный из `latex-report/`) + ссылка на Figma-файл — загружаются в ЭИОС. Согласно методичке: ссылка не в режиме прототипа, timestamp последней правки должен совпадать с датой отправки.

---

## 📦 LaTeX-отчёт

- **[📦 Скачать latex-report.zip](https://github.com/BLXCKBXXST/web-technologies-labs/releases/download/overleaf-zips/lab11_overleaf.zip)** — каркас для импорта в Overleaf
- **[📄 Скачать готовый PDF](https://github.com/BLXCKBXXST/web-technologies-labs/raw/main/lab11/latex-report/lab11_latex_report.pdf)** *(появится после первой компиляции)*
