# linux-admin-labs

Лабораторные работы по Linux-администрированию (СибГУТИ).  
Курс: Web-Technologies / Linux, ИКС-531

Среда: VirtualBox + Ubuntu 20.04/22.04 Server/Desktop.  
Каждая лаба содержит LaTeX-отчёт, готовый для импорта в Overleaf.

---

## Лабораторные работы

| Лаба | Тема | Что делается | ZIP | PDF | Скриншоты | Методичка |
|------|------|----------------|-----|-----|----------|----------|
| Lab 4 | NAT + DHCP | Настройка шлюза (gateway) с NAT и iptables, установка DHCP-сервера isc-dhcp-server | [📦](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab4_overleaf.zip) | [📄](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab4/latex-report/lab4_latex_report.pdf) | [📸](lab4/latex-report/screenshots/README.md) | [📖](lab4/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab4).pdf) |
| Lab 5 | DNS + DDNS | Установка BIND9, настройка прямой/обратной DNS-зоны, интеграция с DHCP (динамические DNS-записи) | [📦](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab5_overleaf.zip) | [📄](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab5/latex-report/lab5_latex_report.pdf) | [📸](lab5/latex-report/screenshots/README.md) | [📖](lab5/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab5).pdf) |
| Lab 6 | Seafile | Развёртывание облачного хранилища Seafile на MariaDB + Nginx, подключение Desktop-клиента | [📦](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab6_overleaf.zip) | [📄](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab6/latex-report/lab6_latex_report.pdf) | [📸](lab6/latex-report/screenshots/README.md) | [📖](lab6/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab6).pdf) |
| Lab 7 | iRedMail | Настройка полноценного почтового сервера iRedMail (Postfix + Dovecot + OpenLDAP + Nginx), отправка писем | [📦](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab7_overleaf.zip) | [📄](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab7/latex-report/lab7_latex_report.pdf) | [📸](lab7/latex-report/screenshots/README.md) | [📖](lab7/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab7).pdf) |
| Lab 8 | WordPress + PrivateBin | Развёртывание LAMP-стека (Apache2 + MySQL + PHP), установка WordPress и PrivateBin с HTTPS | [📦](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab8_overleaf.zip) | [📄](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab8/latex-report/lab8_latex_report.pdf) | [📸](lab8/latex-report/screenshots/README.md) | [📖](lab8/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab8).pdf) |
| Lab 9 | Ansible Monitoring | Автоматизация сбора информации с узлов сети через Ansible (SSH-ключи, inventory, playbook) | [📦](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab9_overleaf.zip) | [📄](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab9/latex-report/lab9_latex_report.pdf) | [📸](lab9/latex-report/screenshots/README.md) | [📖](lab9/%D0%9C%D0%B5%D1%82%D0%BE%D0%B4%D0%B8%D1%87%D0%BA%D0%B0%20(lab9).pdf) |

---

## Топология сети

Все лабы строятся на одной внутренней сети VirtualBox (`intnet`):

```
 Internet
    |
enp0s3 (NAT)
 [gateway]  192.168.N.1
enp0s8 (intnet)
    |
    ├── desktop1    192.168.N.10  (Ubuntu Desktop, DHCP)
    ├── seafile     192.168.N.4   (Seafile)
    ├── mail        192.168.N.5   (iRedMail)
    ├── wordpress   192.168.N.6   (LAMP + WordPress)
    └── privatebin  192.168.N.7   (PrivateBin)
```

> `N` — твой номер студента, задаётся один раз в `config.tex` и проходит через все отчёты автоматически.

---

## Структура репозитория

```
linux-admin-labs/
├── lab4/
│   ├── Методичка (lab4).pdf
│   └── latex-report/
├── lab5/
│   ├── Методичка (lab5).pdf
│   └── latex-report/
├── lab6/
│   ├── Методичка (lab6).pdf
│   └── latex-report/
├── lab7/
│   ├── Методичка (lab7).pdf
│   └── latex-report/
├── lab8/
│   ├── Методичка (lab8).pdf
│   └── latex-report/
├── lab9/
│   ├── Методичка (lab9).pdf
│   └── latex-report/
└── .github/
    └── workflows/
        └── release-latex.yml  ← автосборка ZIP для Overleaf при каждом push
```

Каждая папка `latex-report/` содержит:

```
latex-report/
├── main.tex              ← главный файл, не трогать
├── config.tex            ← твои данные, редактировать только этот файл
├── labN_latex_report.pdf ← готовый PDF
├── fonts/                ← Times New Roman для XeLaTeX
├── img/                  ← скриншоты (01_..., 02_...)
├── screenshots/          ← скрипт и гайд по скриншотам
└── parts/                ← главы отчёта (intro, chap1–3, conclusion)
```

---

## Как использовать (импорт в Overleaf)

1. Скачай ZIP нужной лабы из таблицы выше
2. Overleaf → **New Project → Upload Project** → выбери zip
3. Главный файл: `main.tex`, компилятор: **XeLaTeX**
4. Открой `config.tex` и заполни свои данные
5. Скриншоты по гайду из колонки «Скриншоты», положи в `img/`
6. Нажми **Recompile**

---

## config.tex — что редактировать

```latex
\newcommand{\cfgLabStudentN}{29}        % номер студента N
\newcommand{\cfgStudentName}{...}       % ФИО
\newcommand{\cfgGroupName}{...}         % группа
\newcommand{\cfgTeacherName}{...}       % преподаватель
\newcommand{\cfgLabTitle}{...}          % название лабораторной работы
```

> Все IP-адреса вида `192.168.N.x` в тексте отчёта автоматически вычисляются из `\cfgLabStudentN`.  
> Например, при `N=29` адрес шлюза будет `192.168.29.1`, а desktop1 — `192.168.29.10`.
