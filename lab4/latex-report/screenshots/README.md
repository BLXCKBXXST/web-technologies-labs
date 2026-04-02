# Скрипт для скриншотов — Lab 4

Скрипт `screenshots.sh` ведёт по всем 16 шагам по очереди:
показывает описание → ты нажимаешь Enter → выполняется команда →
ты делаешь скриншот → нажимаешь Enter → следующий шаг.

## Запуск

```bash
# На ВМ gateway, из папки latex-report/
chmod +x screenshots/screenshots.sh
sudo bash screenshots/screenshots.sh
```

## Как работает каждый шаг

```
========================================
  [Скриншот 04] Состояние интерфейсов после netplan apply
========================================
  Файл: img/04_*.png

  → Нажми Enter чтобы выполнить команду...
                                          ← жмёшь Enter

ip a                                      ← команда выполняется
... вывод ...

  ✔ Сделай скриншот и нажми Enter...     ← делаешь скриншот, жмёшь Enter
```

## Особые шаги (без команды, вручную)

Скрипт напомнит что сделать, но команда не выполняется автоматически:

| № | Файл | Что сделать |
|---|---|---|
| 01 | `01_vbox_adapters.png` | VirtualBox → gateway → Настройка → Сеть → показать Адаптер 1 и Адаптер 2 |
| 06 | `06_desktop_ip_manual.png` | Перейти на Desktop1 → открыть `nm-connection-editor` → вкладка IPv4 |
| 07 | `07_ping_gateway_from_desktop.png` | На Desktop1: `ping 192.168.N.1` |
| 09 | `09_iptables_persistent_dialog.png` | Скрипт сам запустит `dpkg-reconfigure` — снять диалог |
| 14 | `14_desktop_dhcp_ip.png` | На Desktop1: настройки сети или `ip a` — показать полученный IP |
| 15 | `15_ping_yaru_desktop.png` | На Desktop1: `ping ya.ru` |

## Полный список скриншотов

| № | Файл | Команда / что показать |
|---|---|---|
| 01 | `01_vbox_adapters.png` | Настройка адаптеров ВМ gateway в VirtualBox |
| 02 | `02_ip_a_before.png` | `ip a` до netplan apply |
| 03 | `03_netplan_yaml.png` | `nano /etc/netplan/00-installer-config.yaml` |
| 04 | `04_ip_a_after.png` | `ip a` после netplan apply |
| 05 | `05_ping_yaru_server.png` | `ping -c 5 ya.ru` с gateway |
| 06 | `06_desktop_ip_manual.png` | Статический IP на Desktop1 |
| 07 | `07_ping_gateway_from_desktop.png` | `ping 192.168.N.1` с Desktop1 |
| 08 | `08_sysctl_ipforward.png` | `nano /etc/sysctl.conf` — строка `net.ipv4.ip_forward=1` |
| 09 | `09_iptables_persistent_dialog.png` | Диалог при `dpkg-reconfigure iptables-persistent` |
| 10 | `10_iptables_rules.png` | `iptables -t nat -L -n -v` |
| 11 | `11_dhcp_interfaces.png` | `nano /etc/default/isc-dhcp-server` |
| 12 | `12_dhcpd_conf.png` | `nano /etc/dhcp/dhcpd.conf` |
| 13 | `13_dhcp_status.png` | `service isc-dhcp-server status` |
| 14 | `14_desktop_dhcp_ip.png` | Desktop1 получил IP от DHCP |
| 15 | `15_ping_yaru_desktop.png` | `ping ya.ru` с Desktop1 |
| 16 | `16_syslog_error.png` | `tail -50 /var/log/syslog` |

## После скриншотов

Положи все 16 файлов `.png` в `../img/` с именами **точно как в таблице**.

```bash
# Пример переноса с хоста через scp:
scp скриншоты/*.png user@192.168.N.1:/path/to/lab4/latex-report/img/
```
