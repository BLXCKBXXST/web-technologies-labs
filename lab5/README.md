# Практическая работа №5
**Настройка DNS + DHCP + DDNS** для локальной сети на Ubuntu Server

## Скачать

**[📦 Скачать scripts.zip](https://github.com/BLXCKBXXST/web-technologies-labs/releases/download/overleaf-zips/lab5_scripts.zip)**

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
NET_IF_EXT="enp0s3"        # Внешний интерфейс
NET_IF_INT="enp0s8"        # Внутренний интерфейс
EXT_IP="10.0.2.15/24"      # IP внешнего интерфейса (NAT)
EXT_GW="10.0.2.2"          # Шлюз внешней сети
```

---

## 📁 Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Параметры варианта (редактировать здесь) |
| `gateway_lab5.sh` | gateway | Bind9, зоны, hostname, netplan, resolv.conf |
| `gateway_lab5_dhcp_ddns.sh` | gateway | DHCP + DDNS через rndc-ключ |
| `desktop_lab5_prepare.sh` | Desktop | Hostname, resolv.conf, подсказки по GUI |

---

## 🚀 Порядок запуска

### Подготовка
Скопируй папку на ВМ (например, через `scp` или вставь содержимое вручную).  
Выдай права:
```bash
chmod +x lab5/*.sh
```

---

### ВМ `gateway` — часть 1 (DNS)

> Предполагается, что лаб.4 уже выполнена: шлюз + DHCP работают.

```bash
sudo bash gateway_lab5.sh
```

Что делает скрипт:
- Меняет hostname → `gateway`, обновляет `/etc/hosts`
- Удаляет DNAT-правила DNS из `/etc/iptables/rules.v4` (были в лаб.4)
- Устанавливает `bind9`, `dnsutils`
- Настраивает `named.conf.options` (forwarders 8.8.8.8, listen-on)
- Настраивает `named.conf.local` (зоны прямая + обратная)
- Создаёт `/var/lib/bind/forward.db` и `reverse.db`
- Обновляет netplan (DNS → 192.168.29.1, search → yazikov.iks531.local)
- **Отключает `systemd-resolved`** и прописывает статический `resolv.conf`
- Перезапускает bind9, делает `nslookup` для самопроверки

После завершения — **перезагрузи**:
```bash
reboot
```

Проверь после перезагрузки:
```bash
nslookup gateway
nslookup 192.168.29.1
ping ya.ru
```

---

### ВМ `gateway` — часть 2 (DHCP + DDNS)

```bash
sudo bash gateway_lab5_dhcp_ddns.sh
```

Что делает скрипт:
- Копирует `/etc/bind/rndc.key` → `/etc/dhcp/ddns-keys/rndc.key`
- Перезаписывает `dhcpd.conf` с поддержкой DDNS
- Перезапускает `bind9` и `isc-dhcp-server`

Проверка DHCP:
```bash
service isc-dhcp-server status
tail -40 /var/log/syslog   # при ошибках
```

---

### ВМ `Desktop`

```bash
sudo bash desktop_lab5_prepare.sh
```

Что делает скрипт:
- Меняет hostname → `desktop1`, обновляет `/etc/hosts`
- Отключает `systemd-resolved`, прописывает `resolv.conf` с DNS 192.168.29.1
- Выводит подсказки по настройке сети в GUI

**[Интерактивный шаг]** Настрой сеть вручную в GUI:

| Параметр | Статика (Вариант А) | DHCP (Вариант Б) |
|---|---|---|
| IPv4 Method | Manual | Automatic (DHCP) |
| Address | 192.168.29.10 | — |
| Netmask | 255.255.255.0 | — |
| Gateway | 192.168.29.1 | — |
| DNS | 192.168.29.1 | — |

Проверка с Desktop:
```bash
ping 192.168.29.1
ping ya.ru
nslookup gateway
nslookup desktop1
```

Проверка с gateway:
```bash
nslookup desktop1
nslookup <IP клиента>
```

---

## 🔧 Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `SERVFAIL` от `127.0.0.53` | Работает systemd-resolved вместо bind | `systemctl disable --now systemd-resolved`, прописать resolv.conf |
| `nslookup gateway` не работает | Ошибка в зонах или named.conf | `systemctl restart bind9`, `tail -40 /var/log/syslog` |
| `isc-dhcp-server` failed | Ошибка синтаксиса в dhcpd.conf (пропущен `;`) | `tail -40 /var/log/syslog` → найди строку с ошибкой → исправь → restart |
| Клиент не получает IP по DHCP | Неверный интерфейс в `/etc/default/isc-dhcp-server` | Должно быть `INTERFACESv4="enp0s8"` |
| `nslookup desktop1` — нет ответа после DHCP | DDNS не обновил зону | Проверь `rndc.key`, блоки `zone` в dhcpd.conf, рестартни оба сервиса |
| Нет интернета на Desktop, ping 192.168.29.1 ок | NAT/iptables или DNS не тот | Проверь `nslookup ya.ru`, переписать правила NAT из лаб.4 |
| После `netplan apply` пропал доступ | Ошибка YAML (отступы пробелами) | Восстанови `*.bak_lab5`, правь аккуратно, `netplan apply` снова |
