# Lab 8 — Скриншоты для LaTeX-отчёта

## Запуск

На ВМ **wordpress** (от root):

```bash
sudo bash screenshots/screenshots.sh
```

> Скриншот 01 делается **вручную** (VirtualBox GUI).
> Скриншоты 07 и 08 делаются **вручную** (браузер на Desktop).
> Остальные шаги скрипт выполняет сам — нужно только сделать снимок экрана.

---

## Как работает скрипт

```
========================================
  [Скриншот NN] Описание
  Файл: img/NN_название.png
========================================
  → Нажми Enter чтобы выполнить команду...
<вывод команды>
  ✔ Сделай скриншот и нажми Enter для продолжения...
```

---

## Таблица скриншотов

| № | Файл | Что показать | ВМ |
|---|------|-------------|----|
| 01 | `01_vbox_wordpress_settings.png` | Настройка адаптера ВМ wordpress в VirtualBox (Internal Network) | Хост |
| 02 | `02_gateway_dns_result.png` | Вывод `gateway_lab8_dns.sh` — A и PTR добавлены | gateway |
| 03 | `03_wp_network_check.png` | `ping gateway` и `dig wordpress.<DOMAIN>` | wordpress |
| 04 | `04_apache2_status.png` | `systemctl status apache2` — active running | wordpress |
| 05 | `05_vhost_conf.png` | Содержимое `/etc/apache2/sites-enabled/wordpress.conf` | wordpress |
| 06 | `06_wp_files.png` | `ls /var/www/html/` — файлы WordPress | wordpress |
| 07 | `07_wp_install_success.png` | Страница «Установка завершена!» | desktop1 |
| 08 | `08_wp_post_published.png` | Тестовая запись на главной странице сайта | desktop1 |
| 09 | `09_post_check.png` | Вывод `wordpress_lab8_post.sh` — все проверки OK | wordpress |

---

## Зависимости между ВМ

> ⚠️ Скриншоты 07 и 08 требуют **трёх ВМ одновременно**:
> gateway (DNS работает), wordpress (Apache запущен), desktop1 (браузер).

Порядок запуска перед съёмкой:
1. Запустить ВМ `gateway`
2. Запустить ВМ `wordpress` — выполнить `wordpress_lab8_prepare.sh`
3. Запустить ВМ `desktop1`
4. На `desktop1` открыть `http://<WP_IP>/`

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
