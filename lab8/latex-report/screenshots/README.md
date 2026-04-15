# 📸 Скриншоты — Lab 8

Интерактивный скрипт, который пошагово ведёт по всем 9 скриншотам для отчёта.

---

## ▶️ Запуск

```bash
# Из папки latex-report/ на ВМ wordpress:
sudo bash screenshots/screenshots.sh
```

---

## ⚙️ Как работает скрипт

```
════════════════════════════════════════
  [Скриншот 04] Статус Apache2
  Файл: img/04_apache2_status.png
════════════════════════════════════════

  → Нажми Enter чтобы выполнить команду...
  [Enter]

systemctl status apache2    ← выполняется автоматически
...

  ✔ Сделай скриншот и нажми Enter...
  [Enter]    ← переход к следующему шагу
```

---

## 📝 Все 9 скриншотов

| № | Файл | Что показать |
|:---:|---|---|
| 01 | `01_vbox_wordpress_settings.png` | VirtualBox → wordpress → Настройка → Сеть — Адаптер 1 (Internal Network) |
| 02 | `02_gateway_dns_result.png` | Вывод `gateway_lab8_dns.sh` — A и PTR добавлены |
| 03 | `03_wp_network_check.png` | `ping gateway` и `dig wordpress.<DOMAIN>` |
| 04 | `04_apache2_status.png` | `systemctl status apache2` — active (running) |
| 05 | `05_vhost_conf.png` | `cat /etc/apache2/sites-enabled/wordpress.conf` |
| 06 | `06_wp_files.png` | `ls /var/www/html/` — файлы WordPress |
| 07 | `07_wp_install_success.png` | Браузер: страница «Установка завершена!» |
| 08 | `08_wp_post_published.png` | Браузер: тестовая запись на главной странице сайта |
| 09 | `09_post_check.png` | Вывод `wordpress_lab8_post.sh` — все проверки OK |

> **⚠️ Шаги 01, 07, 08** — выполняются вручную, скрипт только напомнит что делать.
>
> **⚠️ Шаги 07, 08** — нужны три ВМ одновременно: gateway (DNS), wordpress (Apache), desktop1 (браузер).

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
