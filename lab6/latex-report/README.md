# Lab 6 — LaTeX Report (Seafile)

## ⬇️ Скачать папку архивом

**[📦 Скачать latex-report.zip](https://download-directory.github.io/?url=https://github.com/BLXCKBXXST/linux-admin-labs/tree/main/lab6/latex-report)**

---

## Структура проекта

```
latex-report/
├── main.tex           ← точка входа
├── config.tex         ← ВСЕ входные данные: ФИО, тема, N и т.д.
├── refs.bib           ← библиография (Seafile, Nginx, MariaDB, netplan)
├── README.md
└── parts/
    ├── title.tex
    ├── intro.tex
    ├── chap1.tex      ← теория: Seafile, Nginx, MariaDB, systemd
    ├── chap2.tex      ← подготовка ВМ: netplan, hostname, DNS
    ├── chap3.tex      ← установка: зависимости → MariaDB → Seafile → Nginx → autostart → клиент
    └── conclusion.tex
```

## Быстрое изменение данных — только `config.tex`

| Команда | Что задаёт |
|---|---|
| `\cfgStudentFIO` / `\cfgStudentShort` | ФИО студента |
| `\cfgGroup` | Группа |
| `\cfgTeacherShort` / `\cfgTeacherRank` | Преподаватель |
| `\cfgLabStudentN` | **N** — подставляется в IP-адреса по всему тексту |
| `\cfgStudentLogin` | Логин пользователя в Ubuntu |
| `\cfgStudentDomain` | `STUDENT.GROUP.local` (например `ivanov.ia131.local`) |
| `\cfgSeafileVersion` | Версия Seafile |
| `\cfgYear` / `\cfgCity` | Год и город |

## Компиляция в Overleaf

1. Загрузи **все файлы** (включая папку `parts/`)
2. Главный файл: **`main.tex`**
3. Компилятор: **pdfLaTeX**
4. Нажми **Recompile**
