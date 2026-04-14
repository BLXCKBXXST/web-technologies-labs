# Lab 8 — LaTeX-отчёт: WordPress / LAMP

## Скачать и открыть в Overleaf

**[📦 Скачать latex-report.zip](https://download-directory.github.io/?url=https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab8/latex-report)**

1. Зайди в [Overleaf](https://overleaf.com)
2. `New Project → Upload Project` → выбери скачанный ZIP
3. Настройки проекта:
   - Main file: **`main.tex`**
   - Compiler: **XeLaTeX**
4. Свои данные — редактируй только **`config.tex`**
5. Скриншоты клади в `img/` с именами из таблицы в `screenshots/README.md`

---

## Структура

```
latex-report/
├── main.tex               % преамбула и сборка (не трогать)
├── config.tex             % данные студента — редактировать здесь
├── fonts/                 % TTF Times New Roman (нужны если нет системного шрифта)
├── img/                   % скриншоты (добавляешь сам)
│   └── .gitkeep
├── parts/
│   ├── title.tex          % титульный лист
│   ├── intro.tex          % введение
│   ├── chap1.tex          % теория (LAMP, Apache, MariaDB, WordPress)
│   ├── chap2.tex          % описание стенда и подготовка
│   ├── chap3.tex          % практика (установка, настройка, проверка)
│   └── conclusion.tex     % заключение
└── screenshots/
    ├── screenshots.sh     % скрипт для сбора скриншотов
    └── README.md          % таблица скриншотов и инструкция
```

---

## Скриншоты

Запусти скрипт на ВМ **wordpress**:

```bash
sudo bash screenshots/screenshots.sh
```

Всего **12 скриншотов**. Подробнее — в [`screenshots/README.md`](screenshots/README.md).
