# Практическая работа №7
**Настройка Samba AD/DC + файловый сервер** для локальной сети на Ubuntu Server

---

## ⚙️ Параметры варианта

Все параметры хранятся **в одном файле** [`config.sh`](config.sh).  
Чтобы адаптировать скрипты под другого студента — меняй только его:

```bash
# config.sh
N="14"                        # Номер в журнале
STUDENT="mazurina"            # Фамилия транслитом
GROUP="iks531"                # Номер группы
DOMAIN_UPPER="MAZURINA.IKS531.LOCAL"  # Realm Kerberos (ВЕРХНИЙ регистр)
NETBIOS_DOMAIN="MAZURINA"     # NetBIOS-имя домена
ADMIN_PASS="Admin1234!"       # Пароль администратора AD
```

---

## 🖥️ Виртуальные машины

| ВМ | OS | IP | Роль |
|---|---|---|---|
| `gateway` | Ubuntu Server 22.04 | 192.168.14.1 | Samba AD/DC + файловый сервер |
| `desktop1` | Ubuntu Desktop 22.04 | 192.168.14.10 | Клиент домена |

---

## 📁 Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Параметры варианта (редактировать здесь) |
| `gateway_lab7_samba_dc.sh` | gateway | Установка и provisioning Samba AD/DC |
| `gateway_lab7_shares.sh` | gateway | Создание шаров и пользователей домена |
| `gateway_lab7_dns.sh` | gateway | Добавление DNS-записи для desktop1 |
| `desktop_lab7_join.sh` | desktop1 | Подключение Desktop к домену AD |

---

## 🚀 Порядок запуска

### Подготовка
Скопируй папку на ВМ (через `scp` или вставь вручную).  
Выдай права:
```bash
chmod +x lab7/*.sh
```

> **Предполагается**, что лаб.5 (DNS + DHCP) уже выполнена: bind9 настроен,  
> сеть 192.168.14.0/24 работает.

---

### ВМ `gateway` — шаг 1: Samba AD/DC

```bash
sudo bash gateway_lab7_samba_dc.sh
```

Что делает скрипт:
- Устанавливает FQDN-hostname `gateway.mazurina.iks531.local`
- Отключает `systemd-resolved`, прописывает `resolv.conf`
- Удаляет `bind9` (Samba использует встроенный DNS)
- Устанавливает `samba`, `krb5-user`, `winbind`, `smbclient`
- Выполняет `samba-tool domain provision` (роль DC, DNS SAMBA_INTERNAL)
- Настраивает `/etc/krb5.conf` → symlink на `/var/lib/samba/private/krb5.conf`
- Включает `samba-ad-dc`, отключает `smbd`/`nmbd`
- Проверяет SRV-записи DNS

После завершения — **перезагрузи**:
```bash
reboot
```

Проверь после перезагрузки:
```bash
samba-tool domain level show
host -t SRV _kerberos._udp.mazurina.iks531.local
host -t SRV _ldap._tcp.mazurina.iks531.local
```

---

### ВМ `gateway` — шаг 2: шары и пользователи

```bash
sudo bash gateway_lab7_shares.sh
```

Что делает скрипт:
- Создаёт `/srv/samba/public` (chmod 777) и `/srv/samba/secret` (chmod 770)
- Добавляет секции `[public]` и `[secret]` в `smb.conf`
- Создаёт доменных пользователей `user1` и `user2` через `samba-tool`
- Перезапускает `samba-ad-dc`, проверяет шары через `smbclient`

Проверка:
```bash
smbclient -L //192.168.14.1 -U Administrator%Admin1234!
smbclient //192.168.14.1/public -U guest -N -c 'ls'
```

---

### ВМ `gateway` — шаг 3: DNS для desktop1

```bash
# Укажи IP клиентской машины (можно посмотреть через ip a на desktop1)
DESKTOP_IP=192.168.14.10 sudo bash gateway_lab7_dns.sh
```

Что делает скрипт:
- Добавляет A-запись `desktop1 → <IP>` через `samba-tool dns add`
- Добавляет PTR-запись в обратную зону
- Проверяет `nslookup desktop1`

---

### ВМ `desktop1` — подключение к домену

```bash
sudo bash desktop_lab7_join.sh
```

Что делает скрипт:
- Устанавливает FQDN-hostname `desktop1.mazurina.iks531.local`
- Настраивает `resolv.conf` → DC `192.168.14.1`
- Устанавливает `realmd`, `sssd`, `adcli`, `krb5-user`
- Проверяет доступность домена (`realm discover`)
- Присоединяет машину к домену (`realm join`)
- Настраивает `sssd.conf`: вход без суффикса `@домена`, homedir `/home/<user>`
- Включает `pam_mkhomedir`
- Проверяет `id user1`

**[Интерактивный шаг]** Подключение сетевой папки выводится прямо в терминал скриптом.

| Способ | Команда / путь |
|---|---|
| CLI (гостевая) | `mount -t cifs //192.168.14.1/public /mnt -o guest,vers=3.0` |
| CLI (домен) | `mount -t cifs //192.168.14.1/secret /mnt -o username=user1,password=User1pass!,vers=3.0` |
| Nautilus | `smb://192.168.14.1/public` или `smb://192.168.14.1/secret` |
| Вход в систему | Выйди из сессии → логин `user1`, пароль `User1pass!` |

---

## 🔧 Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `samba-ad-dc` не запускается | Остался старый `smb.conf` или базы .ldb | Удали `/etc/samba/smb.conf` и `/var/lib/samba/private/*.ldb`, повтори provisioning |
| `samba-tool domain provision` — ошибка порта 53 | bind9 ещё занимает порт 53 | `systemctl stop bind9; apt remove --purge bind9`, затем provision снова |
| SRV-записи не находятся | Samba DNS не слушает на `192.168.14.1` | Проверь `smb.conf`: `interfaces = lo enp0s8`, `bind interfaces only = yes` |
| `realm discover` провалился | resolv.conf на desktop1 не указывает на DC | `cat /etc/resolv.conf` → должно быть `nameserver 192.168.14.1` |
| `realm join` — ошибка Kerberos | Разница времени >5 мин между DC и клиентом | `timedatectl set-ntp true` на обеих ВМ, или `ntpdate 192.168.14.1` |
| `id user1` не находит пользователя | sssd не запущен или кеш устарел | `systemctl restart sssd; sss_cache -G -U` |
| Нельзя подключить `secret` | Пользователь не в группе Domain Users | `samba-tool group addmembers "Domain Users" user1` |
| `mount.cifs` — ошибка версии протокола | Старый клиент не поддерживает SMB3 | Добавь опцию `vers=2.0` или `vers=1.0` (не рекомендуется) |
| После перезагрузки samba-ad-dc не стартует | Неверный порядок юнитов systemd | `systemctl edit samba-ad-dc` → добавь `After=network-online.target` |
