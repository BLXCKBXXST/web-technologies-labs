# Практическая работа №7
**Электронная почта — iRedMail** на Ubuntu Server 22.04

---

## ⚙️ Параметры варианта

Все параметры хранятся **в одном файле** [`config.sh`](config.sh).  
Чтобы адаптировать скрипты под другого студента — меняй только его:

```bash
# config.sh
N="29"                          # Номер в журнале
STUDENT="yazikov"               # Фамилия транслитом
GROUP="iks531"                  # Номер группы
MAIL_HOSTNAME="mail"            # Имя почтового сервера
MAIL_IP="192.168.29.5"          # IP почтового сервера
GW_IP="192.168.29.1"            # IP gateway (DNS + шлюз)
NET_IF="enp0s3"                 # Сетевой интерфейс
IREDMAIL_VER="1.6.2"            # Версия iRedMail
```

---

## 🖥️ Виртуальные машины

| ВМ | ОС | Сеть | IP | Роль |
|---|---|---|---|---|
| `gateway` | Ubuntu Server 22.04 | Internal Network `intnet` | 192.168.29.1 | DNS + шлюз (лаб.4/5) |
| `mail` | Ubuntu Server 22.04 | Internal Network `intnet` | 192.168.29.5 | Почтовый сервер (iRedMail) |
| `Desktop` | Ubuntu Desktop | Internal Network `intnet` | DHCP / 192.168.29.10 | Клиент для проверки |

> ВМ `mail` клонируется из золотого образа с **одним** сетевым интерфейсом `Internal Network intnet`.

---

## 📁 Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Параметры варианта (редактировать здесь) |
| `mail_prepare.sh` | mail | Hostname, IP, /etc/hosts, resolv.conf |
| `gateway_add_mail_dns.sh` | gateway | Добавляет A и PTR записи для mail в Bind9 |
| `mail_install_iredmail.sh` | mail | Скачивает iRedMail, выводит подсказки по установщику |
| `desktop_lab7_hints.sh` | Desktop | Проверка DNS/ping/порта, подсказки по веб-интерфейсу |

---

## 🚀 Порядок запуска

### Подготовка
Скопируй папку `lab-7` на нужные ВМ (через `scp` или вставь содержимое вручную).
Выдай права:
```bash
chmod +x lab-7/*.sh
```

---

### 1. ВМ `mail` — подготовка

> Предполагается, что лаб.4 и лаб.5 выполнены: gateway работает как шлюз + DNS.

```bash
sudo bash mail_prepare.sh
```

Что делает скрипт:
- Меняет hostname → `mail.yazikov.iks531.local`, обновляет `/etc/hosts`
- Создаёт netplan с IP `192.168.29.5/24`, шлюз `192.168.29.1`
- Отключает `systemd-resolved`, прописывает статический `resolv.conf`
- Проверяет пинг до gateway и ya.ru

После завершения:
```bash
ping 192.168.29.1
ping ya.ru
hostname -f   # должно вернуть mail.yazikov.iks531.local
```

---

### 2. ВМ `gateway` — добавить DNS-запись для mail

```bash
sudo bash gateway_add_mail_dns.sh
```

Что делает скрипт:
- Добавляет A-запись `mail IN A 192.168.29.5` в `/var/lib/bind/forward.db`
- Добавляет PTR-запись `5 IN PTR mail.yazikov.iks531.local.` в `reverse.db`
- Перезапускает `bind9`, проверяет `nslookup mail`

Проверка с gateway:
```bash
nslookup mail
nslookup 192.168.29.5
```

---

### 3. ВМ `mail` — установка iRedMail

```bash
sudo bash mail_install_iredmail.sh
```

Что делает скрипт:
- Обновляет пакеты (`apt-get update && upgrade`)
- Проверяет FQDN
- Скачивает архив iRedMail (если ещё нет)
- Распаковывает, скачивает зависимости через `pkgs/get_all.sh`
- **Запускает интерактивный установщик** и выводит подробные подсказки

**[Интерактивный шаг]** Отвечай на вопросы установщика:

| Вопрос установщика | Твой ответ |
|---|---|
| Default mail storage path | Enter (оставь `/var/vmail`) |
| Web server | `Nginx` |
| Backend to store mail accounts | `OpenLDAP` |
| LDAP suffix | `dc=yazikov,dc=iks531,dc=local` |
| Password for LDAP rootdn | Придумай (запомни!) |
| First mail domain name | `yazikov.iks531.local` |
| Password for mail domain administrator | Придумай без `$`, `#`, `@` |
| Optional components | `Roundcubemail`, `netdata`, `iRedAdmin`, `Fail2ban` |
| Confirm installation | `y` |
| Firewall | `y` |

После установки перезагрузи сервер:
```bash
reboot
```

---

### 4. ВМ `Desktop` — проверка и работа с почтой

```bash
sudo bash desktop_lab7_hints.sh
```

Что делает скрипт:
- Проверяет DNS (`nslookup mail`)
- Проверяет пинг до `192.168.29.5`
- Проверяет открытость порта 443
- Выводит подробные подсказки по работе с веб-интерфейсом

**[Интерактивный шаг]** Открой браузер Firefox:

| Интерфейс | URL |
|---|---|
| Панель администратора | `https://mail.yazikov.iks531.local/iredadmin` |
| Веб-почта (Roundcube) | `https://mail.yazikov.iks531.local/mail` |

Логин администратора: `postmaster@yazikov.iks531.local`  
Пароль: указанный при установке

> ⚠️ Браузер покажет предупреждение о самоподписанном сертификате.  
> Нажми **Advanced** → **Accept the Risk and Continue**.

**Задание:** создай пользователя и отправь письмо:
1. `iRedAdmin` → Users → Add user: `user1@yazikov.iks531.local`
2. Войди в Roundcube как `postmaster@yazikov.iks531.local`
3. Compose → To: `user1@yazikov.iks531.local`, отправь
4. Войди как `user1@yazikov.iks531.local`, проверь Inbox

---

## 🔧 Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `hostname -f` возвращает не `mail.yazikov.iks531.local` | Hostname не установлен как FQDN | `hostnamectl set-hostname mail.yazikov.iks531.local`, обнови `/etc/hosts` |
| iRedMail ругается на hostname = mail domain | FQDN совпадает с именем почтового домена | Mail domain должен быть `yazikov.iks531.local`, hostname — `mail.yazikov.iks531.local` |
| `nslookup mail` не работает с Desktop | DNS-запись не добавлена или bind9 не перезапущен | Запусти `gateway_add_mail_dns.sh` на gateway, затем `systemctl restart bind9` |
| Сайт `https://mail.../iredadmin` недоступен | iRedMail не запущен после reboot | `systemctl status nginx`, `systemctl start postfix dovecot` |
| Ошибка 502 Bad Gateway | Uwsgi/iredadmin не запущен | `systemctl start iredadmin` или `systemctl restart nginx` |
| Roundcube не отправляет письма | Postfix не работает | `systemctl status postfix`, `tail -50 /var/log/mail.log` |
| Нет интернета на mail, ping gateway ок | NAT правила на gateway | Проверь `iptables -t nat -L -v` на gateway, правило MASQUERADE должно быть |
| `pkgs/get_all.sh` зависает или падает | Проблема с интернетом | `ping ya.ru` с ВМ mail, проверь настройки netplan и gateway |
| Предупреждение о SSL-сертификате в браузере | Самоподписанный сертификат | Нажми Advanced → Accept the Risk |
