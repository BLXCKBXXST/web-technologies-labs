# Практическая работа №4
**Настройка шлюза (NAT) и DHCP-сервера** на Ubuntu Server 20.04

---

## ⚙️ Параметры варианта

Все параметры хранятся **в одном файле** [`config.sh`](config.sh).  
Чтобы адаптировать скрипты под другого студента — меняй только его:

```bash
# config.sh
N="29"                     # Номер в журнале
STUDENT="yazikov"         # Фамилия транслитом
GROUP="iks531"             # Номер группы
SERVER_HOSTNAME="gateway"  # Имя сервера
DESKTOP_HOSTNAME="desktop1"
NET_IF_EXT="enp0s3"        # Внешний интерфейс (NAT / мост)
NET_IF_INT="enp0s8"        # Внутренний интерфейс (Internal Network)
EXT_IP="10.0.2.15/24"      # IP внешнего интерфейса (NAT VirtualBox)
EXT_GW="10.0.2.2"          # Шлюз внешней сети
```

---

## 📁 Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Параметры варианта (редактировать здесь) |
| `gateway_lab4_net.sh` | gateway | Netplan, ip_forward, iptables NAT + DNAT DNS |
| `gateway_lab4_dhcp.sh` | gateway | Установка и настройка isc-dhcp-server |
| `desktop_lab4_prepare.sh` | Desktop1 | Hostname, подсказки по настройке GUI |

---

## 🖥️ ВМ и роли

| ВМ | ОС | Роль | Адрес |
|---|---|---|---|
| gateway | Ubuntu Server 20.04 | Шлюз + DHCP | enp0s3: 10.0.2.15/24 (NAT), enp0s8: 192.168.29.1/24 |
| Desktop1 | Ubuntu Desktop | Клиент | 192.168.29.10 (статик) → DHCP |

> **Тип адаптеров в VirtualBox:**  
> gateway enp0s3 → NAT или Сетевой мост  
> gateway enp0s8 → Внутренняя сеть (`intnet`)  
> Desktop1 enp0s3 → Внутренняя сеть (`intnet`)

---

## 🚀 Порядок запуска

### Подготовка
Скопируй папку `lab4` на ВМ (через `scp` или вставь содержимое вручную) и выдай права:
```bash
chmod +x lab4/*.sh
```

---

### ВМ `gateway` — Часть 1: сеть + NAT

> Предполагается, что ОС установлена, ВМ склонирована из шаблона и два адаптера настроены в VirtualBox.

```bash
sudo bash gateway_lab4_net.sh
```

Что делает скрипт:
- Проверяет наличие интерфейсов `enp0s3` и `enp0s8`
- Записывает `/etc/netplan/00-installer-config.yaml` (enp0s3: 10.0.2.15, enp0s8: 192.168.29.1)
- Применяет `netplan apply`
- Проверяет интернет на шлюзе (`ping ya.ru`)
- Включает `net.ipv4.ip_forward=1` в `/etc/sysctl.conf`
- Устанавливает `iptables-persistent`
- Прописывает правила iptables: MASQUERADE, DNAT DNS → 8.8.8.8
- Сохраняет правила в `/etc/iptables/rules.v4`

**[Интерактивный шаг]** При установке `iptables-persistent` — ответь **Yes** на оба вопроса «Сохранить текущие правила?».

Проверь после завершения:
```bash
ip -br a
ping ya.ru
iptables -t nat -L -n -v
```

---

### ВМ `Desktop1` — статический IP

```bash
sudo bash desktop_lab4_prepare.sh
```

Что делает скрипт:
- Меняет hostname → `desktop1`
- Выводит подсказки по настройке GUI

**[Интерактивный шаг]** Настрой сеть в GUI:

| Параметр | Значение |
|---|---|
| IPv4 Method | Manual |
| Address | 192.168.29.10 |
| Netmask | 255.255.255.0 |
| Gateway | 192.168.29.1 |
| DNS | 192.168.29.1 |

Проверка:
```bash
ping 192.168.29.1
ping ya.ru
```

---

### ВМ `gateway` — Часть 2: DHCP

> Перед этим шагом рекомендуется сделать снимок ВМ (Snapshot → «Lab4»).

```bash
sudo bash gateway_lab4_dhcp.sh
```

Что делает скрипт:
- Устанавливает `isc-dhcp-server`
- Прописывает `INTERFACESv4="enp0s8"` в `/etc/default/isc-dhcp-server`
- Создаёт `/etc/dhcp/dhcpd.conf`:
  - Подсеть `192.168.29.0/24`
  - Диапазон `192.168.29.10 – 192.168.29.254`
  - Шлюз + DNS: `192.168.29.1`
  - Время аренды: 7 дней
- Перезапускает сервис и проверяет статус

Проверка DHCP:
```bash
service isc-dhcp-server status
cat /var/lib/dhcp/dhcpd.leases    # аренды после подключения клиента
```

---

### ВМ `Desktop1` — переключение на DHCP

**[Интерактивный шаг]** В настройках сети GUI:
- IPv4 Method → **Automatic (DHCP)**
- Отключи и включи соединение

Проверка:
```bash
ip a                               # убедись, что IP из диапазона 192.168.29.x
ping 192.168.29.1
ping ya.ru
```

---

## ✅ Ожидаемый результат

- **gateway**: доступ в Интернет, `isc-dhcp-server` работает
- **Desktop1**: получает IP по DHCP, пингует шлюз и `ya.ru`
- Оба `ping ya.ru` проходят

---

## 🔧 Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| Нет Интернета на `gateway` | Неверный IP/GW для enp0s3, тип адаптера не NAT/мост | Проверь netplan-файл и настройки VirtualBox, `netplan apply` |
| `netplan apply` выдаёт warnings | Ошибки отступов в YAML (только пробелы!) | Проверь файл, сравни с эталоном, применить снова |
| Desktop не пингует `192.168.29.1` | Неверные настройки IP/маска/шлюз, интерфейс down | Исправить IPv4-профиль в GUI, переподключить |
| Ping шлюза есть, но нет `ping ya.ru` с Desktop | NAT не работает или не сохранился | Перезапусти `gateway_lab4_net.sh`, проверь `iptables -t nat -L` |
| `isc-dhcp-server` не стартует (failed) | Синтаксическая ошибка в `dhcpd.conf` | `tail -50 /var/log/syslog` → найди строку ошибки → исправь → restart |
| Клиент не получает IP по DHCP | DHCP не запущен, неверный `INTERFACESv4`, Desktop на статике | Включить DHCP на Desktop, проверить `/etc/default/isc-dhcp-server` |
| После перезагрузки gateway NAT пропал | Правила не сохранились в `rules.v4` | `iptables-save > /etc/iptables/rules.v4`, убедись что `iptables-persistent` установлен |
