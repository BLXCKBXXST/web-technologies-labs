# Lab 10 — LaTeX Report (Основы Figma)

## Скачать

**[📦 Скачать latex-report.zip](https://github.com/BLXCKBXXST/web-technologies-labs/releases/download/overleaf-zips/lab10_overleaf.zip)**

**[📄 Скачать готовый PDF](https://github.com/BLXCKBXXST/web-technologies-labs/raw/main/lab10/latex-report/lab10_latex_report.pdf)** *(появится после первой компиляции)*

## Импорт в Overleaf

1. Скачай архив по ссылке выше
2. Overleaf → **New Project → Upload Project** → выбери zip
3. Главный файл: `main.tex`, компилятор: **XeLaTeX**
4. Свои данные — редактируй только `config.tex`
5. Скриншоты клади в папку `img/` (имена: `01_workspace`, `02_frame_1440`, …)
   — см. гайд [`screenshots/README.md`](screenshots/README.md)
6. В `parts/chap3.tex` замени плейсхолдер `TODO: вставить URL общего доступа к Figma-файлу` на реальную ссылку.

## Структура

```
latex-report/
├── main.tex
├── config.tex
├── fonts/
│   ├── times.ttf
│   ├── timesbd.ttf
│   ├── timesi.ttf
│   └── timesbi.ttf
├── img/
│   ├── 01_workspace.png
│   ├── 02_frame_1440.png
│   └── ...
├── screenshots/
│   └── README.md           ← список скриншотов (без screenshots.sh)
└── parts/
    ├── title.tex
    ├── intro.tex
    ├── chap1.tex
    ├── chap2.tex
    ├── chap3.tex
    └── conclusion.tex
```

> В отличие от серверных лаб у Lab 10 нет интерактивного `screenshots.sh` — Figma это GUI, и проводник по bash здесь неуместен. Все скриншоты делаются вручную из Figma (Export PNG) или PrintScreen окна браузера.
