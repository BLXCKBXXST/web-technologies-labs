# 📸 Скриншоты — Lab 5

Интерактивный скрипт, который пошагово ведёт по всем 16 скриншотам для отчёта.

---

## ▶️ Запуск

```bash
# Из папки latex-report/ на ВМ gateway:
sudo bash screenshots/screenshots.sh
```

---

## ⚙️ Как работает скрипт

```
════════════════════════════════════════
  [Скриншот 09] Проверка конфигурации BIND9
  Файл: img/09_named_checkconf.png
════════════════════════════════════════

  → Нажми Enter чтобы выполнить команду...
  [Enter]

named-checkconf && ...    ← выполняется автоматически
...

  ✔ Сделай скриншот и нажми Enter...
  [Enter]    ← переход к следующему шагу
```

---

## 📝 Все 16 скриншотов

| № | Файл | Что показать |
|:---:|---|---|
| 01 | `01_vbox_gateway_settings.png` | VirtualBox → gateway → Настройка → Сеть — Адаптер 1 и 2 |
| 02 | `02_etc_hosts.png` | `nano /etc/hosts` — добавлена строка с hostname |
| 03 | `03_iptables_rules.png` | `nano /etc/iptables/rules.v4` — DNAT DNS удален |
| 04 | `04_bind9_install.png` | Установка `bind9` и `dnsutils` |
| 05 | `05_named_conf_options.png` | `nano /etc/bind/named.conf.options` |
| 06 | `06_named_conf_local.png` | `nano /etc/bind/named.conf.local` |
| 07 | `07_forward_db.png` | `nano /var/lib/bind/forward.db` |
| 08 | `08_reverse_db.png` | `nano /var/lib/bind/reverse.db` |
| 09 | `09_named_checkconf.png` | `named-checkconf` + `named-checkzone` — нет ошибок |
| 10 | `10_netplan_gateway.png` | `nano /etc/netplan/00-installer-config.yaml` — секция nameservers |
| 11 | `11_nslookup_forward.png` | `nslookup SERVERHOSTNAME` — прямое разрешение |
| 12 | `12_nslookup_reverse.png` | `nslookup 192.168.N.1` — обратное разрешение |
| 13 | `13_dhcpd_conf_ddns.png` | `nano /etc/dhcp/dhcpd.conf` — секция DDNS |
| 14 | `14_dhcp_status.png` | `service isc-dhcp-server status` |
| 15 | `15_nslookup_desktop.png` | `nslookup DESKTOPNAME01` — разрешение через DDNS |
| 16 | `16_syslog_ddns.png` | `tail -40 /var/log/syslog` — DDNS update succeeded |

> **⚠️ Шаг 01** — выполняется вручную в VirtualBox.
>
> **⚠️ Шаги 15 и 16** — требуют подключённого Desktop — он должен получить IP по DHCP и зарегистрироваться в DNS.

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
