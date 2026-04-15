# 📸 Скриншоты — Lab 6

Интерактивный скрипт, который пошагово ведёт по всем 15 скриншотам для отчёта.

---

## ▶️ Запуск

```bash
# Из папки latex-report/ на ВМ seafile:
sudo bash screenshots/screenshots.sh
```

---

## ⚙️ Как работает скрипт

```
════════════════════════════════════════
  [Скриншот 07] Установка Seafile (setup-seafile-mysql.sh)
  Файл: img/07_setup_seafile_sh.png
════════════════════════════════════════

  → Нажми Enter чтобы выполнить команду...
  [Enter]

./setup-seafile-mysql.sh    ← выполняется автоматически
...

  ✔ Сделай скриншот и нажми Enter...
  [Enter]    ← переход к следующему шагу
```

---

## 📝 Все 15 скриншотов

| № | Файл | Что показать |
|:---:|---|---|
| 01 | `01_vbox_seafile_settings.png` | VirtualBox → seafile → Настройка → Сеть — Адаптер 1 (Internal) |
| 02 | `02_netplan_seafile.png` | `nano /etc/netplan/00-installer-config.yaml` — статический IP |
| 03 | `03_ping_gateway.png` | `ping gateway` и `ping ya.ru` — связь работает |
| 04 | `04_nslookup_seafile.png` | `nslookup seafile` — A-запись разрешается |
| 05 | `05_apt_install_deps.png` | Установка Python-зависимостей через pip3 |
| 06 | `06_mariadb_install.png` | Установка MariaDB + `flush privileges` |
| 07 | `07_setup_seafile_sh.png` | Вывод `./setup-seafile-mysql.sh` — успешно завершён |
| 08 | `08_nginx_conf.png` | `nano /etc/nginx/sites-enabled/seafile.conf` |
| 09 | `09_seafile_start.png` | `seafile.sh start` + `seahub.sh start` |
| 10 | `10_seahub_admin_create.png` | Создание учётной записи администратора Seahub |
| 11 | `11_seafile_service.png` | `systemctl status seafile` — active (running) |
| 12 | `12_seafile_web_login.png` | Браузер: страница входа Seafile (`http://seafile`) |
| 13 | `13_seafile_web_library.png` | Браузер: библиотека с загруженным файлом |
| 14 | `14_seafile_client_install.png` | `apt-get install seafile-gui` на Desktop |
| 15 | `15_seafile_client_sync.png` | Клиент Seafile на Desktop — синхронизированная библиотека |

> **⚠️ Шаг 01** делается вручную в VirtualBox.
> Шаги **12–13** выполняются на ВМ Desktop в браузере.
> Шаги **14–15** выполняются на ВМ Desktop в терминале.

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).