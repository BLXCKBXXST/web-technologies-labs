# Лабораторная работа №7 — Электронная почта (iRedMail)

**Тема:** Развёртывание почтового сервера iRedMail на базе Ubuntu 22.04  
**Вариант:** N=29 | Студент: yazikov | Группа: iks531  
**Домен:** `yazikov.iks531.local`

---

## Виртуальные машины

| ВМ | IP | ОС | Роль |
|---|---|---|---|
| `gateway` | 192.168.29.1 | Ubuntu Server 22.04 | Шлюз, DNS (BIND9), DHCP |
| `mail` | 192.168.29.5 | Ubuntu Server 22.04 | Почтовый сервер (iRedMail) |
| `desktop1` | 192.168.29.10+ | Ubuntu Desktop 22.04 | Клиент, браузер для веб-почты |

> ВМ `mail` — новый клон «золотого образа» с **одним** интерфейсом «Внутренняя сеть intnet».

---

## Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Единый конфиг варианта (N, STUDENT, DOMAIN, IP…) |
| `gateway_lab7_dns.sh` | `gateway` | Добавляет A/PTR/MX-записи для mail в BIND9 |
| `mail_lab7_prepare.sh` | `mail` | Hostname, статический IP, загрузка iRedMail |
| `mail_lab7_post.sh` | `mail` | Проверка сервисов после установки + подсказки |
| `README.md` | — | Этот файл |

---

## Порядок запуска

### 0. Клонировать ВМ

Создать новую ВМ `mail` из «золотого образа» Ubuntu 22.04.  
Сетевой интерфейс: **Internal Network** (`intnet`).

---

### 1. На ВМ `gateway` — добавить DNS-записи

```bash
cd linux-admin-labs/lab-7
sudo bash gateway_lab7_dns.sh
```

Скрипт добавит:
- A-запись `mail → 192.168.29.5` в прямую зону
- MX-запись `@ → mail.yazikov.iks531.local`
- PTR-запись `5 → mail.yazikov.iks531.local` в обратную зону
- Перезагрузит BIND9 и проверит разрешение

---

### 2. На ВМ `mail` — подготовка системы

Скопируй папку `lab-7` на ВМ mail (через shared folder или `scp`).

```bash
cd linux-admin-labs/lab-7
sudo bash mail_lab7_prepare.sh
```

Скрипт выполнит:
- Установку hostname: `mail.yazikov.iks531.local`
- Прописывание `/etc/hosts`
- Настройку статического IP `192.168.29.5` через netplan
- `apt-get update`
- Загрузку и распаковку iRedMail 1.6.2
- Запуск `get_all.sh` для загрузки зависимостей

---

### 3. На ВМ `mail` — интерактивная установка iRedMail

```bash
cd /root/iRedMail-1.6.2
chmod +x iRedMail.sh
./iRedMail.sh
```

В мастере установки выбери:

| Шаг | Значение |
|---|---|
| Mail storage path | `/var/vmail` (по умолчанию) |
| Web server | **Nginx** |
| Database backend | **OpenLDAP** |
| LDAP suffix | `dc=yazikov,dc=iks531,dc=local` |
| Пароль admin DB | любой надёжный |
| Mail domain | `yazikov.iks531.local` |
| Пароль postmaster | любой надёжный |
| Roundcubemail, iRedAdmin, Fail2ban | **Yes** |
| Остальные вопросы | **Yes** |

По завершении — **перезагрузить**: `reboot`

---

### 4. На ВМ `mail` — проверка после установки

```bash
cd linux-admin-labs/lab-7
sudo bash mail_lab7_post.sh
```

Скрипт проверяет запуск `postfix`, `dovecot`, `nginx`, `slapd` и открытые порты.

---

### 5. На ВМ `desktop1` — создать пользователя и отправить письмо

1. Открыть браузер
2. Перейти на панель iRedAdmin:  
   `https://mail.yazikov.iks531.local/iredadmin`  
   Логин: `postmaster@yazikov.iks531.local`
3. Создать пользователя: **iRedAdmin → Users → Add User**  
   Email: `user1@yazikov.iks531.local`
4. Открыть веб-почту:  
   `https://mail.yazikov.iks531.local/mail`
5. Войти и отправить письмо (себе или другому пользователю).

---

## Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `mail_lab7_prepare.sh` падает на DNS-проверке | DNS-записи не добавлены на gateway | Сначала запусти `gateway_lab7_dns.sh` на ВМ gateway |
| `ping gateway` не работает с mail-ВМ | Неверный интерфейс в netplan или ВМ не в intnet | Проверь `ip a`; убедись, что ВМ в Internal Network |
| `iRedMail.sh` падает с ошибкой зависимостей | `get_all.sh` не завершился | Повтори `mail_lab7_prepare.sh` или запусти `get_all.sh` вручную |
| `postfix` не запущен после reboot | Конфликт с Sendmail | `systemctl disable sendmail; systemctl start postfix` |
| Браузер: «Certificate Error» | Самоподписанный сертификат iRedMail | Добавь исключение в браузере (Advanced → Accept Risk) |
| Письмо не доставляется | Неверный LDAP suffix или почтовый домен | Проверь `/etc/postfix/main.cf`: поля `mydomain` и `myhostname` |
| iRedAdmin недоступен | nginx или php-fpm не запущен | `systemctl status nginx php*-fpm` |
| PTR-запись не разрешается | Опечатка в обратной зоне | `named-checkzone 29.168.192.in-addr.arpa /var/lib/bind/reverse.db` |
