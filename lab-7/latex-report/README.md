# LaTeX-отчёт — Лабораторная работа №7
**Электронная почта. Развёртывание почтового сервера iRedMail**

---

## ⚙️ Параметры варианта

Все параметры — в [`config.tex`](config.tex). Редактируй **только его**:

```tex
\newcommand{\cfgLabNumber}{7}
\newcommand{\cfgLabStudentN}{29}
\newcommand{\cfgTopic}{Электронная почта. Развёртывание почтового сервера iRedMail}
```

---

## 📁 Структура

```
latex-report/
├── main.tex               % преамбула, ГОСТ 7.32, сборка
├── config.tex             % данные студента — редактировать здесь
├── fonts/                 % TTF Times New Roman (скопируй из lab5/)
├── img/                   % скриншоты (добавляешь сам)
│   └── .gitkeep
├── parts/
│   ├── title.tex          % титульный лист
│   ├── intro.tex          % введение
│   ├── chap1.tex          % теория
│   ├── chap2.tex          % стенд и подготовка
│   ├── chap3.tex          % практическая часть
│   └── conclusion.tex     % заключение
└── screenshots/
    ├── screenshots.sh     % скрипт для скриншотов (23 шага)
    └── README.md          % таблица скриншотов
```

---

## 🚀 Как открыть в Overleaf

1. Скопируй шрифты из `lab5/latex-report/fonts/` в `lab-7/latex-report/fonts/`
   (либо используй системный Times New Roman — тогда папка не нужна).
2. Скачай папку `latex-report/` как ZIP.
3. Overleaf → **New Project → Upload Project** → выбери ZIP.
4. Настройки: Main file = `main.tex`, Compiler = **XeLaTeX**.
5. Добавь скриншоты в `img/` с именами `NN_name.png`.

---

## 📸 Скриншоты

См. [`screenshots/README.md`](screenshots/README.md) — полная таблица 23 скриншотов.

```bash
sudo bash screenshots/screenshots.sh
```

---

## 🔧 Компиляция локально (XeLaTeX)

```bash
cd lab-7/latex-report
xelatex main.tex
xelatex main.tex   # дважды для оглавления
```
