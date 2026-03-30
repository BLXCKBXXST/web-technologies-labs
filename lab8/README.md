# Практическая работа №8
**Настройка почтового сервера Postfix + Dovecot** для локальной сети на Ubuntu Server

---

## ⚙️ Параметры варианта

Все параметры хранятся **в одном файле** [`config.sh`](config.sh).  
Чтобы адаптировать скрипты под другого студента — меняй только его:

```bash
# config.sh
N="14"                          # Номер в журнале
STUDENT="mazurina"              # Фамилия транслитом
GROUP="iks531"                  # Номер группы
SERVER_HOSTNAME="gateway"       # Имя сервера
DESKTOP_HOSTNAME="desktop1"     # Имя клиента
MAIL_USER1="user1"              # Почтовый пользователь 1
MAIL_USER1_PASS="User1pass!"    # Пароль пользователя 1
MAIL_USER2="user2"              # Почтовый пользователь 2
MAIL_USER2_PASS="User2pass!"    # Пароль пользователя 2
```

---

## 🖥️ Виртуальные машины

| ВМ | OS | IP | Роль |
|---|---|---|---|
| `gateway` | Ubuntu Server 22.04 | 192.168.14.1 | Postfix SMTP + Dovecot IMAP/POP3 |
| `desktop1` | Ubuntu Desktop 22.04 | 192.168.14.10 | Почтовый клиент (Thunderbird + mutt) |

---

## 📁 Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Параметры варианта (редактировать здесь) |
| `gateway_lab8_postfix.sh` | gateway | Установка и настройка Postfix (SMTP) |
| `gateway_lab8_dovecot.sh` | gateway | Установка и настройка Dovecot (IMAP/POP3) |
| `gateway_lab8_users.sh` | gateway | Создание пользователей, Maildir, MX-запись, тест |
| `desktop_lab8_client.sh` | desktop1 | Проверка соединения, установка Thunderbird, подсказки GUI |

---

## 🚀 Порядок запуска

### Подготовка
Скопируй папку на ВМ (через `scp` или вставь вручную).  
Выдай права:
```bash
chmod +x lab8/*.sh
```

> **Предполагается**, что лаб.5 (DNS + DHCP) выполнена: bind9 настроен,  
> сеть 192.168.14.0/24 работает. Лаб.7 (Samba AD) не обязательна.

---

### ВМ `gateway` — шаг 1: Postfix

```bash
sudo bash gateway_lab8_postfix.sh
```

Что делает скрипт:
- Устанавливает FQDN hostname `gateway.mazurina.iks531.local`
- Устанавливает `postfix`, `mailutils` (без интерактивного меню через debconf)
- Настраивает `/etc/postfix/main.cf`: домен, сеть, формат Maildir
- Открывает порт 25 в UFW (если включён)
- Перезапускает и проверяет Postfix

Проверь после запуска:
```bash
ss -tlnp | grep :25
echo "test" | mail -s "hello" user1
```

---

### ВМ `gateway` — шаг 2: Dovecot

```bash
sudo bash gateway_lab8_dovecot.sh
```

Что делает скрипт:
- Устанавливает `dovecot-imapd`, `dovecot-pop3d`
- Включает протоколы `imap pop3` в `dovecot.conf`
- Настраивает хранилище почты: `mail_location = maildir:~/Maildir`
- Разрешает plaintext-аутентификацию (для учебной среды без TLS)
- Добавляет `unix_listener` для интеграции с Postfix через SASL
- Открывает порты 143 (IMAP) и 110 (POP3) в UFW
- Перезапускает оба сервиса

Проверь после запуска:
```bash
ss -tlnp | grep -E ':110|:143'
systemctl status dovecot
```

---

### ВМ `gateway` — шаг 3: пользователи и тест

```bash
sudo bash gateway_lab8_users.sh
```

Что делает скрипт:
- Создаёт системных пользователей `user1` и `user2` с паролями
- Создаёт структуру `Maildir` для каждого
- Добавляет MX-запись в `forward.db` (bind9) и обновляет serial
- Отправляет тестовое письмо от `user1` → `user2`
- Проверяет наличие письма в `Maildir/new` пользователя user2

Проверка на сервере:
```bash
ls -la /home/user2/Maildir/new/
tail -20 /var/log/mail.log
```

---

### ВМ `desktop1`

```bash
sudo bash desktop_lab8_client.sh
```

Что делает скрипт:
- Проверяет доступность сервера (ping, nc на порты 25/143)
- Устанавливает `thunderbird` и `mutt`
- Выводит подсказки по настройке Thunderbird в GUI

**[Интерактивный шаг]** Настрой Thunderbird вручную:

| Параметр | Значение |
|---|---|
| Email | user1@mazurina.iks531.local |
| IMAP сервер | 192.168.14.1, порт 143 |
| SMTP сервер | 192.168.14.1, порт 25 |
| Защита | None (учебная среда) |
| Аутентификация | Normal password |
| Логин | user1 |

**Telnet-проверка IMAP прямо в терминале:**
```bash
telnet 192.168.14.1 143
a001 LOGIN user1 User1pass!
a002 SELECT INBOX
a003 LOGOUT
```

Проверка SMTP:
```bash
telnet 192.168.14.1 25
EHLO desktop1
MAIL FROM:<user1@mazurina.iks531.local>
RCPT TO:<user2@mazurina.iks531.local>
DATA
Subject: Test

Hello from desktop1
.
QUIT
```

---

## 🔧 Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `postfix` не запускается, ошибка hostname | FQDN не резолвится локально | Проверь `/etc/hosts`: должно быть `127.0.1.1 gateway.mazurina.iks531.local gateway` |
| `Connection refused` на порт 25 | Postfix не запущен или UFW блокирует | `systemctl start postfix`, `ufw allow 25/tcp` |
| `Connection refused` на порт 143 | Dovecot не запущен | `systemctl start dovecot`, проверь `dovecot -n` |
| Письмо в очереди, не доставляется | Ошибка в `mydestination` или нет пользователя | `postqueue -p`, `tail -20 /var/log/mail.log` |
| `Authentication failed` в Thunderbird | plaintext auth выключен | В `10-auth.conf`: `disable_plaintext_auth = no` |
| Maildir не создаётся автоматически | Postfix не настроен на Maildir | `postconf home_mailbox` → должно быть `Maildir/` |
| `Permission denied` при чтении Maildir | Неверный владелец папки | `chown -R user1:user1 /home/user1/Maildir` |
| MX-запись не работает | bind9 не перезагружен или ошибка serial | `rndc reload`, проверь `/var/log/syslog` на ошибки named |
| Thunderbird не видит письма | IMAP папка не INBOX, а INBOX.INBOX | В настройках account: Server Settings → Advanced → IMAP prefix = "" |
| Нет интернет-доставки (только локальная) | Это ожидаемо в учебной среде | Внешняя почта не нужна — только локальный обмен |
