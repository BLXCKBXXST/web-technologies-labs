# 📸 Скриншоты — Lab 7

Интерактивный скрипт, который пошагово ведёт по всем 10 скриншотам для отчёта.

---

## ▶️ Запуск

```bash
# Из папки latex-report/ на ВМ mail:
sudo bash screenshots/screenshots.sh
```

---

## ⚙️ Как работает скрипт

```
════════════════════════════════════════
  [Скриншот 06] Статус Postfix
  Файл: img/06_postfix_status.png
════════════════════════════════════════

  → Нажми Enter чтобы выполнить команду...
  [Enter]

systemctl status postfix    ← выполняется автоматически
...

  ✔ Сделай скриншот и нажми Enter...
  [Enter]    ← переход к следующему шагу
```

---

## 📝 Все 10 скриншотов

| № | Файл | Что показать |
|:---:|---|---|
| 01 | `01_vbox_mail_network.png` | VirtualBox → mail → Настройка → Сеть — Адаптер 1 (Internal Network) |
| 02 | `02_mail_ip_a.png` | `ip a` — адрес `192.168.\cfgLabStudentN.5` на `enp0s3` |
| 03 | `03_mail_ping_nslookup.png` | `ping -c 4 192.168.\cfgLabStudentN.1` и `nslookup gateway` |
| 04 | `04_mail_etc_hosts.png` | `/etc/hosts` с FQDN `mail.\cfgDomain` |
| 05 | `05_dns_mail_record.png` | `nslookup mail.\cfgDomain` — A-запись разрешается |
| 06 | `06_postfix_status.png` | `systemctl status postfix` — active (running) |
| 07 | `07_dovecot_status.png` | `systemctl status dovecot` — active (running) |
| 08 | `08_iredadmin_login.png` | Браузер: страница входа `https://mail.../iredadmin` |
| 09 | `09_iredadmin_dashboard.png` | Дашборд iRedAdmin после успешного входа |
| 10 | `10_roundcube_login.png` | Браузер: страница входа `https://mail.../mail` |

> **⚠️ Шаги 01, 08–10** — выполняются вручную, скрипт только напомнит что делать.
>
> **⚠️ Шаг 05** — выполняется на ВМ **gateway**, а не на mail.
>
> **⚠️ Шаги 08–10** — нужен запущенный браузер на ВМ Desktop.

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
