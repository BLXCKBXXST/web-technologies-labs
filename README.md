# linux-admin-labs

Лабораторные работы по Linux-администрированию (СибГУТИ).  
Курс: Web-Technologies / Linux, ИКС-531

---

## Лабораторные работы

| Лаба | Тема | Скачать ZIP | PDF | Гайд по скриншотам |
|------|------|------------|-----|--------------------|
| Lab 4 | NAT, DHCP, VirtualBox | [📦 zip](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab4_overleaf.zip) | [📄 PDF](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab4/latex-report/lab4_latex_report.pdf) | [📸 гайд](lab4/latex-report/screenshots/README.md) |
| Lab 5 | DNS, DDNS, BIND9 | [📦 zip](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab5_overleaf.zip) | [📄 PDF](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab5/latex-report/lab5_latex_report.pdf) | [📸 гайд](lab5/latex-report/screenshots/README.md) |
| Lab 6 | Seafile Cloud Storage | [📦 zip](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab6_overleaf.zip) | [📄 PDF](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab6/latex-report/lab6_latex_report.pdf) | [📸 гайд](lab6/latex-report/screenshots/README.md) |
| Lab 7 | iRedMail | [📦 zip](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab7_overleaf.zip) | [📄 PDF](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab7/latex-report/lab7_latex_report.pdf) | [📸 гайд](lab7/latex-report/screenshots/README.md) |
| Lab 8 | WordPress / LAMP | [📦 zip](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab8_overleaf.zip) | [📄 PDF](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab8/latex-report/lab8_latex_report.pdf) | [📸 гайд](lab8/latex-report/screenshots/README.md) |
| Lab 9 | Ansible Monitoring | [📦 zip](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab9_overleaf.zip) | [📄 PDF](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab9/latex-report/lab9_latex_report.pdf) | [📸 гайд](lab9/latex-report/screenshots/README.md) |

---

## Структура репозитория

```
linux-admin-labs/
├── lab4/
│   └── latex-report/       ← LaTeX-проект для Overleaf
├── lab5/
│   └── latex-report/
├── lab6/
│   └── latex-report/
├── lab7/
│   └── latex-report/
├── lab8/
│   └── latex-report/
├── lab9/
│   └── latex-report/
└── .github/
    └── workflows/
        └── release-latex.yml  ← автосборка ZIP для Overleaf
```

Каждая папка `latex-report/` содержит:

```
latex-report/
├── main.tex             ← главный файл, не трогать
├── config.tex           ← твои данные, редактировать только этот файл
├── labN_latex_report.pdf
├── fonts/               ← Times New Roman (XeLaTeX)
├── img/                 ← скриншоты (01_..., 02_...)
├── screenshots/         ← скрипт и гайд по скриншотам
└── parts/               ← главы отчёта
```

---

## Как использовать (импорт в Overleaf)

1. Скачай ZIP нужной лабы из таблицы выше
2. Overleaf → **New Project → Upload Project** → выбери zip
3. Главный файл: `main.tex`, компилятор: **XeLaTeX**
4. Редактируй `config.tex` под себя
5. Скриншоты клади в `img/` — см. гайд в колонке "Гайд по скриншотам"
6. Нажми **Recompile**

---

## config.tex — что редактировать

```latex
\newcommand{\cfgLabStudentN}{29}        % номер студента (определяет IP-адреса)
\newcommand{\cfgStudentName}{...}       % ФИО
\newcommand{\cfgGroupName}{...}         % группа
\newcommand{\cfgTeacherName}{...}       % преподаватель
\newcommand{\cfgLabTitle}{...}          % название лабораторной работы
```

> Все IP-адреса в тексте отчёта автоматически вычисляются из `\cfgLabStudentN` —  
> например, при значении `29` адрес шлюза будет `192.168.29.1`.
