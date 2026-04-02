# Лабораторная работа №6 — Облачное файловое хранилище Seafile

## Быстрый старт (Overleaf)

1. Скачать [lab6-latex-report.zip](../../releases/latest) (или `Code → Download ZIP` этой папки).
2. На [overleaf.com](https://overleaf.com) → **New Project → Upload Project** → выбрать ZIP.
3. Открыть **Menu → Compiler → XeLaTeX**.
4. Нажать **Recompile**.
5. Вставить скриншоты в папку `img/` (имена файлов совпадают с `\includegraphics{...}` в тексте).

## Структура

```
lab6/latex-report/
├── main.tex          # Главный файл — точка входа компилятора
├── config.tex        # Все переменные отчёта (ФИО, группа, тема, N)
├── refs.bib          # Список литературы (BibTeX)
├── parts/
│   ├── title.tex     # Титульный лист
│   ├── intro.tex     # Введение
│   ├── chap1.tex     # Гл. 1 — Теоретические сведения
│   ├── chap2.tex     # Гл. 2 — Стенд и подготовка
│   ├── chap3.tex     # Гл. 3 — Установка и настройка Seafile
│   └── conclusion.tex# Заключение
├── fonts/            # Times New Roman (.ttf) — только если нет системного шрифта
└── img/              # Скриншоты (добавляются вручную)
```

## Скриншоты для подстановки

| Файл в `img/` | Что снять |
|---|---|
| `01_vbox_seafile_settings` | Настройки ВМ seafile в VirtualBox (сеть) |
| `02_netplan_seafile` | `nano /etc/netplan/00-installer-config.yaml` |
| `03_ping_gateway` | `ping gateway` и `ping ya.ru` |
| `04_nslookup_seafile` | `nslookup seafile` |
| `05_apt_install_deps` | Установка Python-зависимостей |
| `06_mariadb_install` | Установка MariaDB |
| `07_setup_seafile_sh` | Вывод `./setup-seafile-mysql.sh` |
| `08_nginx_conf` | `nano /etc/nginx/sites-enabled/seafile.conf` |
| `09_seafile_start` | Запуск `seafile.sh start` + `seahub.sh start` |
| `10_seahub_admin_create` | Создание admin-аккаунта |
| `11_seafile_service` | `systemctl status seafile` |
| `12_seafile_web_login` | Браузер: страница входа Seafile |
| `13_seafile_web_library` | Браузер: библиотека / загрузка файла |
| `14_seafile_client_install` | `apt install seafile-gui` на Desktop |
| `15_seafile_client_sync` | Клиент Seafile на Desktop — синхронизированная библиотека |
