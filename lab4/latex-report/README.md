# Lab 4 — LaTeX Report

## ⬇️ Скачать папку архивом

**[📦 Скачать только latex-report.zip](https://download-directory.github.io/?url=https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab4/latex-report)**

---

## Структура проекта

```
latex-report/
├── main.tex          ← точка входа, загружает config и parts
├── config.tex        ← ВСЕ входные данные: ФИО, тема, группа и т.д.
├── refs.bib          ← библиография
├── README.md
└── parts/
    ├── title.tex     ← титульный лист
    ├── intro.tex     ← введение
    ├── chap1.tex     ← глава 1: теория (NAT, iptables, DHCP, netplan)
    ├── chap2.tex     ← глава 2: стенд, настройка netplan
    ├── chap3.tex     ← глава 3: NAT + DHCP пошагово
    └── conclusion.tex← заключение
```

## Быстрое изменение данных

Открой **только `config.tex`** и измени нужные строки:

| Команда | Что меняет |
|---|---|
| `\cfgStudentFIO` | ФИО студента полностью |
| `\cfgStudentShort` | Краткое ФИО |
| `\cfgGroup` | Номер группы |
| `\cfgTeacherShort` | Краткое ФИО преподавателя |
| `\cfgTeacherRank` | Должность преподавателя |
| `\cfgDiscipline` | Название дисциплины |
| `\cfgReportType` | Тип работы (ОТЧЁТ / РЕФЕРАТ) |
| `\cfgTopic` | Тема работы |
| `\cfgLabNumber` | Номер лабы |
| `\cfgLabStudentN` | Твой N в журнале (в IP-адресах по всему тексту) |
| `\cfgYear` | Год |

## Компиляция в Overleaf

1. Загрузи **все файлы** (включая папку `parts/`)
2. Установи главный файл: **`main.tex`**
3. Компилятор: **pdfLaTeX**
4. Нажми **Recompile**
