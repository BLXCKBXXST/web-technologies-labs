# Lab 5 — LaTeX Report

## ⬇️ Скачать папку архивом

**[📦 Скачать только latex-report.zip](https://download-directory.github.io/?url=https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab5/latex-report)**

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
    ├── chap1.tex     ← глава 1: теория
    ├── chap2.tex     ← глава 2: стенд и подготовка
    ├── chap3.tex     ← глава 3: настройка DNS + DDNS
    └── conclusion.tex← заключение
```

## Быстрое изменение данных

Открой **только `config.tex`** и измени нужные строки:

| Команда | Что меняет |
|---|---|
| `\cfgStudentFIO` | ФИО студента полностью |
| `\cfgStudentShort` | Краткое ФИО (Д.А. Язиков) |
| `\cfgGroup` | Номер группы |
| `\cfgTeacherShort` | Краткое ФИО преподавателя |
| `\cfgTeacherRank` | Должность преподавателя |
| `\cfgDiscipline` | Название дисциплины |
| `\cfgReportType` | Тип работы (РЕФЕРАТ / ОТЧЁТ и т.д.) |
| `\cfgTopic` | Тема работы |
| `\cfgLabNumber` | Номер лабы |
| `\cfgLabStudentN` | Твой номер в журнале (N в IP-сети) |
| `\cfgYear` | Год |

## Компиляция в Overleaf

1. Загрузи **все файлы** (включая папку `parts/`)
2. Установи главный файл: **`main.tex`**
3. Компилятор: **pdfLaTeX**
4. Нажми **Recompile**
