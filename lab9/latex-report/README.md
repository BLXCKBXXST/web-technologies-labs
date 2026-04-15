# Lab 9 — LaTeX Report (Ansible Monitoring)

## Скачать

**[📦 Скачать latex-report.zip](https://github.com/BLXCKBXXST/linux-admin-labs/releases/download/overleaf-zips/lab9_overleaf.zip)**

**[📄 Скачать готовый PDF](https://github.com/BLXCKBXXST/linux-admin-labs/raw/main/lab9/latex-report/lab9_latex_report.pdf)**

## Импорт в Overleaf

1. Скачай архив по ссылке выше
2. Overleaf → **New Project → Upload Project** → выбери zip
3. Главный файл: `main.tex`, компилятор: **XeLaTeX**
4. Свои данные — редактируй только `config.tex`
5. Скриншоты клади в папку `img/` (имена: `01_...`, `02_...`)
   — см. гайд [`screenshots/README.md`](screenshots/README.md)

## Структура

```
latex-report/
├── main.tex
├── config.tex
├── lab9_latex_report.pdf
├── fonts/
│   ├── times.ttf
│   ├── timesbd.ttf
│   ├── timesi.ttf
│   └── timesbi.ttf
├── img/
│   ├── 01_gateway_ip_a.png
│   ├── 02_client_ssh_status.png
│   └── ...
├── screenshots/
│   ├── screenshots.sh
│   └── README.md
└── parts/
    ├── title.tex
    ├── intro.tex
    ├── chap1.tex
    ├── chap2.tex
    ├── chap3.tex
    └── conclusion.tex
```
