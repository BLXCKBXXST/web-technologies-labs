# Скриншоты — Лабораторная работа №7 (iRedMail)

## Запуск скрипта

```bash
sudo bash screenshots/screenshots.sh
```

> Скрипт запускается **на ВМ `mail`** (кроме шагов, явно помеченных как `[gateway]`).  
> Перед запуском убедитесь, что лабораторная работа выполнена целиком.

---

## Как работает скрипт

Каждый шаг выглядит так:

```
========================================
  [Скриншот NN] Описание действия
========================================
  Файл: img/NN_название.png

  → Нажми Enter чтобы выполнить команду...
<вывод команды>
  ✔ Сделай скриншот и нажми Enter для продолжения...
```

Для **ручных шагов** (VirtualBox GUI, браузер) команда не выполняется —
скрипт объясняет, что именно нужно показать, и ждёт нажатия Enter.

---

## Таблица скриншотов

| № | Файл | ВМ | Что показать |
|---|------|----|--------------|
| 01 | `01_vbox_mail_network.png` | host | VirtualBox → mail → Настройка → Сеть (вкладка Адаптер 1, Internal Network) |
| 02 | `02_mail_ip_a.png` | mail | Вывод `ip a` — адрес 192.168.29.5 на enp0s3 |
| 03 | `03_mail_ping_nslookup.png` | mail | `ping -c 4 192.168.29.1` и `nslookup gateway` |
| 04 | `04_mail_etc_hosts.png` | mail | Файл `/etc/hosts` с FQDN `mail.yazikov.iks531.local` |
| 05 | `05_dns_mail_record.png` | gateway | `nslookup mail.yazikov.iks531.local` после добавления A-записи |
| 06 | `06_postfix_status.png` | mail | `systemctl status postfix` — active (running) |
| 07 | `07_dovecot_status.png` | mail | `systemctl status dovecot` — active (running) |
| 08 | `08_iredadmin_login.png` | Desktop | Браузер: страница входа `https://mail.../iredadmin` |
| 09 | `09_iredadmin_dashboard.png` | Desktop | Дашборд iRedAdmin после успешного входа |
| 10 | `10_roundcube_login.png` | Desktop | Браузер: страница входа `https://mail.../mail` |

---

## Предупреждения

- **Шаги 01, 08–10** — ручные (GUI/браузер), выполняются без команды.
- **Шаг 05** выполняется на **gateway**, а не на mail.
- Для шагов 08–10 нужен запущенный браузер на ВМ **Desktop**.

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
