# Лабораторная работа №7 — Электронная почта (iRedMail)

**Тема:** Развёртывание почтового сервера iRedMail на базе Ubuntu 20.04  
**Вариант:** N=29 | Студент: yazikov | Группа: iks531  
**Домен:** `yazikov.iks531.local`

---

## Виртуальные машины

| ВМ | IP | ОС | Роль |
|---|---|---|---|
| `gateway` | 192.168.29.1 | Ubuntu Server 20.04 | Шлюз, DNS (BIND9), DHCP |
| `mail` | 192.168.29.5 | Ubuntu Server 20.04 | Почтовый сервер (iRedMail) |
| `desktop1` | 192.168.29.10+ | Ubuntu Desktop 20.04 | Клиент, браузер для веб-почты |

> ВМ `mail` — новый клон «золотого образа» с **одним** интерфейсом «Внутренняя сеть intnet».

---

## Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Единый конфиг варианта (N, STUDENT, DOMAIN, IP…) |
| `gateway_lab7_dns.sh` | `gateway` | Добавляет A/MX/PTR-записи для mail в BIND9, reload |
| `mail_lab7_prepare.sh` | `mail` | Hostname, /etc/hosts, netplan, resolv.conf, apt upgrade, загрузка iRedMail |
| `mail_lab7_post.sh` | `mail` | Проверка сервисов и портов после reboot + подсказки URL |
| `desktop_lab7_hints.sh` | `desktop1` | DNS/ping/порт-проверки с Desktop + инструкция по iRedAdmin и Roundcube |
| `README.md` | — | Этот файл |

---

## Порядок запуска

### 0. Клонировать ВМ

Создать новую ВМ `mail` из «золотого образа» Ubuntu 20.04.  
Сетевой интерфейс: **Internal Network** (`intnet`).

---

### 1. На ВМ `gateway` — добавить DNS-записи

```bash
cd linux-admin-labs/lab7
sudo bash gateway_lab7_dns.sh
```

Скрипт добавляет:
- A-запись `mail → 192.168.29.5` в прямую зону
- MX-запись `@ → mail.yazikov.iks531.local` (если MX уже есть с чужой фамилией — заменит автоматически)
- PTR-запись `5 → mail.yazikov.iks531.local` в обратную зону
- Автоматически обновляет Serial
- Выполняет `named-checkzone` + перезагрузку BIND9 + проверку резолвинга

---

### 2. На ВМ `mail` — подготовка системы

Скопируй папку `lab7` на ВМ mail (через shared folder или `scp`).

```bash
cd linux-admin-labs/lab7
sudo bash mail_lab7_prepare.sh
```

Скрипт выполняет:
- Установку hostname: `mail.yazikov.iks531.local`
- Прописывание `/etc/hosts`
- Настройку статического IP `192.168.29.5` через netplan
- Отключение `systemd-resolved` + статический `/etc/resolv.conf`
- Проверку связи с gateway и DNS
- `apt-get update && upgrade`
- Скачивание и распаковку iRedMail, запуск `get_all.sh`
- Вывод подсказок для интерактивного установщика

> **Примечание:** скрипт скачивает актуальную версию iRedMail (на момент написания — 1.6.8).  
> Путь `/root/iRedMail-1.6.8` может отличаться — уточни командой `ls /root/iRedMail-*`.

---

### 3. На ВМ `mail` — интерактивная установка iRedMail

```bash
cd /root/iRedMail-1.6.8   # замени на актуальную версию
chmod +x iRedMail.sh
./iRedMail.sh
```

В мастере установки выбирай:

| Шаг | Значение |
|---|---|
| Mail storage path | `/var/vmail` (по умолчанию) |
| Web server | **Nginx** |
| Database backend | **OpenLDAP** |
| LDAP suffix | `dc=yazikov,dc=iks531,dc=local` |
| Пароль LDAP rootdn | надёжный (без `$`, `#`, `@`) |
| Mail domain | `yazikov.iks531.local` |
| Пароль postmaster | надёжный |
| Roundcubemail, iRedAdmin, Fail2ban | **Yes** |
| Остальные вопросы | **Yes** |

> ⚠️ **Не прерывай установку** (`Ctrl+C`)! Если мастер выйдет с `Cancelled, Exit` —  
> запусти `./iRedMail.sh` заново и пройди все вопросы до конца.

По завершении установщик выведет сводку. **Обязательно выполни `reboot`** перед следующим шагом:

```bash
reboot
```

---

### 4. На ВМ `mail` — проверка после перезагрузки

```bash
cd linux-admin-labs/lab7
sudo bash mail_lab7_post.sh
```

Скрипт проверяет запуск `postfix`, `dovecot`, `nginx`, `slapd`, открытые порты и MX-запись.

---

### 5. На ВМ `desktop1` — проверка доступа и отправка письма

```bash
cd linux-admin-labs/lab7
sudo bash desktop_lab7_hints.sh
```

Скрипт проверит DNS, ping, порт 443 и выведет инструкцию:
1. Открыть iRedAdmin: `https://mail.yazikov.iks531.local/iredadmin`  
   Логин: `postmaster@yazikov.iks531.local`
2. Создать пользователя: **iRedAdmin → Users → Add User**  
   Email: `user1@yazikov.iks531.local`
3. Открыть Roundcube: `https://mail.yazikov.iks531.local/mail`
4. Войти и отправить письмо — проверить доставку во входящих.

---

## Файл паролей

После успешной установки iRedMail сохраняет все пароли и URL в файл:

```
/root/iRedMail-*/iRedMail.tips
```

Там хранятся:
- Пароль LDAP rootdn
- Пароль postmaster
- Ссылки на веб-интерфейсы iRedAdmin и Roundcube

**Сохрани этот файл** — без него восстановить пароли будет сложно.

---

## Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `mail_lab7_prepare.sh` падает на DNS-проверке | DNS-записи не добавлены на gateway | Сначала запусти `gateway_lab7_dns.sh` на ВМ gateway |
| `ping gateway` не работает с mail-ВМ | Неверный интерфейс в netplan или ВМ не в intnet | Проверь `ip a`; убедись, что ВМ в Internal Network |
| MX-запись указывает на чужой домен | Старая MX-запись от другого студента осталась в зоне | Запусти `gateway_lab7_dns.sh` — скрипт автоматически заменит MX на правильное значение |
| `iRedMail.sh` падает с ошибкой зависимостей | `get_all.sh` не завершился | Повтори `mail_lab7_prepare.sh` или запусти `get_all.sh` вручную |
| Установщик сообщает «Ваша версия устарела» | Скрипт проверяет версию онлайн | Это предупреждение, не ошибка — установка продолжится автоматически |
| Установщик выходит с `Cancelled, Exit` | Файл `config` не был создан (прерван прошлый запуск) | `cd /root/iRedMail-*; bash iRedMail.sh` — пройди все вопросы до конца |
| Сервисы не найдены после reboot (`Unit not found`) | Установка не завершилась до конца | Проверь `ls /etc/postfix`; если пусто — повтори установку |
| `postfix` не запущен после reboot | Конфликт с Sendmail | `systemctl disable sendmail; systemctl start postfix` |
| Браузер: «Ошибка сертификата» | Самоподписанный сертификат iRedMail | Advanced → Accept the Risk (нормально для лабы) |
| Письмо не доставляется | Неверный LDAP suffix или mail domain | Проверь `/etc/postfix/main.cf`: `mydomain` и `myhostname` |
| iRedAdmin недоступен | nginx или php-fpm не запущен | `systemctl status nginx php*-fpm` |
| PTR-запись не разрешается | Опечатка в обратной зоне | `named-checkzone 29.168.192.in-addr.arpa /var/lib/bind/reverse.db` |
| `/etc/resolv.conf` сбрасывается | systemd-resolved не отключён | Запусти шаг 4 из `mail_lab7_prepare.sh` вручную |
