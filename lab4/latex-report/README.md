# Лабораторная работа №4 — LaTeX-отчёт

**Тема:** NAT и DHCP-сервер на VirtualBox (Ubuntu 20.04 Server + Ubuntu Desktop)

## Структура папки

```
latex-report/
├── main.tex              # Главный файл, точка входа для компилятора
├── config.tex            # Номер студента (подставить!), настройки оформления
├── refs.bib              # Список литературы
├── fonts/                # Шрифты Times New Roman (.ttf)
├── img/                  # ← Сюда класть скриншоты (.png)
├── parts/
│   ├── titlepage.tex
│   ├── intro.tex
│   ├── chap2.tex
│   ├── chap3.tex
│   └── conclusion.tex
└── screenshots/          # Скрипт для сбора скриншотов + инструкция
```

## Быстрый старт

1. Открой `config.tex`, поставь свой номер студента:
   ```tex
   \newcommand{\cfgLabStudentN}{99}  % <-- здесь
   ```
2. Сделай скриншоты — см. [`screenshots/README.md`](screenshots/README.md)
3. Положи 16 файлов `.png` в папку `img/`
4. Зазипуй `latex-report/` и загрузи в [Overleaf](https://overleaf.com)
5. Компилятор — **XeLaTeX**, главный файл — `main.tex`
