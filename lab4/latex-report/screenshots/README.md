# 📸 Скриншоты — Lab 4

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
  [Скриншот 04] Интерфейсы после netplan apply
  Файл: img/04_ip_a_after.png
════════════════════════════════════════

  → Нажми Enter чтобы выполнить команду...
  [Enter]

ip a         ← выполняется автоматически
...

  ✔ Сделай скриншот и нажми Enter...
  [Enter]    ← переход к следующему шагу
```

---

## 📝 Все 16 скриншотов

| № | Файл | Что показать |
|:---:|---|---|
| 01 | `01_vbox_adapters.png` | VirtualBox → gateway → Настройка → Сеть — Адаптер 1 и 2 |
| 02 | `02_ip_a_before.png` | `ip a` до `netplan apply` |
| 03 | `03_netplan_yaml.png` | `nano /etc/netplan/00-installer-config.yaml` |
| 04 | `04_ip_a_after.png` | `ip a` после `netplan apply` |
| 05 | `05_ping_yaru_server.png` | `ping -c 5 ya.ru` с gateway |
| 06 | `06_desktop_ip_manual.png` | Desktop1: `nm-connection-editor` → вкладка IPv4 |
| 07 | `07_ping_gateway_from_desktop.png` | Desktop1: `ping 192.168.N.1` |
| 08 | `08_sysctl_ipforward.png` | `nano /etc/sysctl.conf` — `net.ipv4.ip_forward=1` |
| 09 | `09_iptables_persistent_dialog.png` | Диалог `dpkg-reconfigure iptables-persistent` |
| 10 | `10_iptables_rules.png` | `iptables -t nat -L -n -v` |
| 11 | `11_dhcp_interfaces.png` | `nano /etc/default/isc-dhcp-server` |
| 12 | `12_dhcpd_conf.png` | `nano /etc/dhcp/dhcpd.conf` |
| 13 | `13_dhcp_status.png` | `service isc-dhcp-server status` |
| 14 | `14_desktop_dhcp_ip.png` | Desktop1: полученный IP от DHCP |
| 15 | `15_ping_yaru_desktop.png` | Desktop1: `ping ya.ru` |
| 16 | `16_syslog_error.png` | `tail -50 /var/log/syslog` |

> **⚠️ Шаги 01, 06, 07, 14, 15** — выполняются вручную, скрипт только напомнит что делать.
> 
> **⚠️ Шаг 09** — запускает `dpkg-reconfigure` автоматически.

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
