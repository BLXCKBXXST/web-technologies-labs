# Практическая работа №10
**Основы Figma. Создание макета интернет-магазина домашних растений**

В отличие от серверных лаб (4–9) здесь нет ВМ, `config.sh` и bash-скриптов: вся работа ведётся в графическом редакторе Figma в браузере. В этой папке лежит только методичка и LaTeX-отчёт.

---

## 🛠️ Среда

| Что | Где |
|---|---|
| Редактор | [Figma](https://www.figma.com) (веб) или desktop-приложение |
| Плагин | `Unsplash` — для подбора фотографий растений |
| Иконки | [Figma Community](https://www.figma.com/community), `Iconify`, `Material Icons` |
| Доступ | Бесплатный план `Starter` |

---

## 📋 Задачи

**Задание 1 — главная страница (десктоп 1440 px):**
- меню (шапка) с логотипом, навигацией и иконками;
- обложка (Hero) с заголовком и CTA-кнопкой;
- блок с тематическими карточками-категориями.

**Задание 2 — дополнение и адаптивы:**
- блок «Предложения месяца» — карточки товара в 2 ряда;
- футер с подпиской на новости и иконками соцсетей;
- 12-колоночная `Layout grid` на корневом фрейме;
- `Constraints` (привязки) для всех ключевых элементов;
- адаптивная версия 768 px (планшет);
- адаптивная версия 360 px (мобильный).

---

## 📐 Адаптивы

| Версия | Ширина | Сетка |
|---|---|---|
| Desktop | 1440 px | 12 колонок, margin 80 px, gutter 24 px |
| Tablet | 768 px | 6 колонок, margin 32 px, gutter 16 px |
| Mobile | 360 px | 4 колонки, margin 16 px, gutter 8 px |

---

## 🔗 Ссылка на Figma

> **TODO:** вставить URL общего доступа к Figma-файлу (Share → `Anyone with the link can view`).

Эту же ссылку нужно подставить в `latex-report/parts/chap3.tex` (раздел «Готовый макет в Figma»).

---

## 📤 Формат сдачи

PDF-отчёт (скомпилированный из `latex-report/`) + ссылка на работу в Figma — загружаются в ЭИОС.

---

## 📦 LaTeX-отчёт

- **[📦 Скачать latex-report.zip](https://github.com/BLXCKBXXST/web-technologies-labs/releases/download/overleaf-zips/lab10_overleaf.zip)** — каркас для импорта в Overleaf
- **[📄 Скачать готовый PDF](https://github.com/BLXCKBXXST/web-technologies-labs/raw/main/lab10/latex-report/lab10_latex_report.pdf)** *(появится после первой компиляции)*

Подробнее об импорте — [latex-report/README.md](latex-report/README.md).
