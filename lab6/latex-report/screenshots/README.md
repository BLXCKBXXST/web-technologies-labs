# 📸 Скриншоты — Lab 6

Интерактивный скрипт, который пошагово ведёт по всем 10 скриншотам для отчёта.

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
  [Скриншот 05] Конфигурация Nginx (reverse proxy Seahub)
  Файл: img/05_nginx_conf.png
════════════════════════════════════════

  → Нажми Enter чтобы выполнить команду...
  [Enter]

cat /etc/nginx/sites-enabled/seafile.conf    ← выполняется автоматически
...

  ✔ Сделай скриншот и нажми Enter...
  [Enter]    ← переход к следующему шагу
```

---

## 📝 Все 10 скриншотов

| № | Файл | Что показать |
|:---:|---|---|
| 01 | `01_vbox_seafile_settings.png` | VirtualBox → seafile → Настройка → Сеть — Адаптер 1 (Internal) |
| 02 | `02_netplan_seafile.png` | `cat /etc/netplan/00-installer-config.yaml` — статический IP |
| 03 | `03_ping_gateway.png` | `ping gateway` и `ping ya.ru` — связь работает |
| 04 | `04_nslookup_seafile.png` | `nslookup seafile` — A-запись разрешается |
| 05 | `05_nginx_conf.png` | `cat /etc/nginx/sites-enabled/seafile.conf` |
| 06 | `06_seafile_start.png` | `seafile.sh start` + `seahub.sh start` |
| 07 | `07_seafile_service.png` | `systemctl status seafile` — active (running) |
| 08 | `08_seafile_web_login.png` | Браузер: страница входа Seafile (`http://seafile`) |
| 09 | `09_seafile_web_library.png` | Браузер: библиотека с загруженным файлом |
| 10 | `10_seafile_client_sync.png` | Клиент Seafile на Desktop — синхронизированная библиотека |

> **⚠️ Шаг 01** — выполняется вручную в VirtualBox.
>
> **⚠️ Шаги 08–09** — выполняются на ВМ Desktop в браузере.
>
> **⚠️ Шаг 10** — выполняется на ВМ Desktop.

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
