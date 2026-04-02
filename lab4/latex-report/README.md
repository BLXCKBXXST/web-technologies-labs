# Lab 4 — LaTeX Report (DHCP, NAT, маршрутизация)

## Скачать

**[📦 Скачать latex-report.zip](https://download-directory.github.io/?url=https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab4/latex-report)**

## Импорт в Overleaf

1. Скачай архив по ссылке выше
2. Overleaf → **New Project → Upload Project** → выбери zip
3. Главный файл: `main.tex`, компилятор: **XeLaTeX**
4. Свои данные — редактируй только `config.tex`
5. Скриншоты клади в папку `img/` (имена: `01_...`, `02_...`)

## Структура

```
latex-report/
├── main.tex
├── config.tex          ← ФИО, группа, тема, N сети
├── refs.bib
└── parts/
    ├── title.tex       ← титульник
    ├── intro.tex       ← введение
    ├── chap1.tex       ← теория (из методички)
    ├── chap2.tex       ← стенд и подготовка
    ├── chap3.tex       ← настройка DHCP + NAT
    └── conclusion.tex  ← заключение
```
