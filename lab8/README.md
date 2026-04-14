# Лабораторная работа №8 — WordPress

**Тема:** Развёртывание WordPress на базе LAMP (Ubuntu 22.04)  
**Вариант:** N=29 | Студент: yazikov | Группа: iks531  
**Домен:** `yazikov.iks531.local`

---

## Виртуальные машины

| ВМ | IP | ОС | Роль |
|---|---|---|---|
| `gateway` | 192.168.29.1 | Ubuntu Server 22.04 | Шлюз, DNS (BIND9), DHCP |
| `wordpress` | 192.168.29.6 | Ubuntu Server 22.04 | Веб-сервер WordPress (LAMP) |
| `desktop1` | 192.168.29.10+ | Ubuntu Desktop 22.04 | Клиент, браузер |

> ВМ `wordpress` — новый клон «золотого образа» с **одним** интерфейсом «Внутренняя сеть intnet».

---

## Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Единый конфиг варианта (N, STUDENT, DOMAIN, IP, БД…) |
| `gateway_lab8_dns.sh` | `gateway` | Добавляет A/PTR-записи для wordpress в BIND9 |
| `wordpress_lab8_prepare.sh` | `wordpress` | Hostname, netplan, LAMP, БД, WordPress |
| `wordpress_lab8_post.sh` | `wordpress` | Проверка сервисов, портов, HTTP, БД после установки |
| `desktop_lab8_check.sh` | `desktop1` | DNS/ping/порт-проверки + инструкция по WordPress |
| `README.md` | — | Этот файл |

---

## Порядок запуска

### 0. Клонировать ВМ

Создать новую ВМ `wordpress` из «золотого образа» Ubuntu 22.04.  
Сетевой интерфейс: **Internal Network** (`intnet`).

---

### 1. На ВМ `gateway` — добавить DNS-запись

```bash
cd linux-admin-labs/lab8
sudo bash gateway_lab8_dns.sh
```

Скрипт добавляет:
- A-запись `wordpress → 192.168.29.6` в прямую зону
- PTR-запись `6 → wordpress.yazikov.iks531.local` в обратную зону
- Обновляет Serial, перезагружает BIND9

---

### 2. На ВМ `wordpress` — подготовка и установка

Скопируй папку `lab8` на ВМ wordpress (`scp` или shared folder).

```bash
cd linux-admin-labs/lab8
sudo bash wordpress_lab8_prepare.sh
```

Скрипт выполняет:
- Установку hostname: `wordpress.yazikov.iks531.local`
- Настройку `/etc/hosts`
- Статический IP `192.168.29.6` через netplan
- Проверку связи с gateway и DNS
- `apt-get update && upgrade`
- Установку LAMP (`tasksel lamp-server`) + PHP-расширения
- Настройку Apache2 (ServerName, права, Virtual Host)
- Создание БД и пользователя MariaDB
- Скачивание и настройку WordPress
- Развёртывание WordPress в `/var/www/html`

> **Пароли БД** берутся из `config.sh` — поменяй `DB_PASSWORD` перед запуском!

---

### 3. Интерактивная установка WordPress

После завершения скрипта на **ВМ Desktop** открой браузер:

```
http://192.168.29.6
```

Заполни форму установки:

| Поле | Значение |
|---|---|
| Название сайта | `yazikov.iks531.local` |
| Имя пользователя | `admin` |
| Пароль | придумай надёжный |
| Email | `admin@yazikov.iks531.local` |

Нажми **«Установить WordPress»**.

---

### 4. На ВМ `wordpress` — проверка после установки

```bash
sudo bash wordpress_lab8_post.sh
```

Скрипт проверяет: Apache2, MariaDB, порты 80/3306, HTTP-ответ, файлы WordPress, доступность БД.

---

### 5. На ВМ `desktop1` — проверка доступа

```bash
cd linux-admin-labs/lab8
sudo bash desktop_lab8_check.sh
```

Затем в браузере:
1. Открыть `http://192.168.29.6` — убедиться что сайт работает
2. Зайти в `http://192.168.29.6/wp-admin`
3. Создать запись: **Записи → Добавить новую** → опубликовать
4. Убедиться что запись видна на главной странице

---

## Файл паролей

Все пароли хранятся в `config.sh` — переменные `DB_PASSWORD`.  
Пароль администратора WordPress задаётся во время интерактивной установки через браузер.

---

## Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `ping gateway` не работает с wordpress-ВМ | Неверный интерфейс в netplan или ВМ не в intnet | Проверь `ip a`; убедись что ВМ в Internal Network |
| DNS не разрешает `wordpress` | A-запись не добавлена на gateway | Запусти `gateway_lab8_dns.sh` на ВМ gateway |
| Apache не запускается | Конфликт портов или ошибка конфига | `apache2ctl configtest`; `journalctl -u apache2 -n 20` |
| `tasksel` не находит lamp-server | Не добавлен universe репозиторий | `add-apt-repository universe && apt-get update` |
| HTTP-код 403 (Forbidden) | Неверные права на `/var/www/html` | `chown -R www-data:www-data /var/www/html` |
| WordPress предлагает установку повторно | `wp-config.php` не настроен или БД пуста | Проверь `wp-config.php`; запусти `wordpress_lab8_prepare.sh` заново |
| Ошибка подключения к БД при установке | Неверный пароль в `config.sh` | Поправь `DB_PASSWORD` в `config.sh` и пересоздай БД |
| `rsync: command not found` | rsync не установлен | `apt-get install -y rsync` |
| Страница не открывается с Desktop | Apache слушает на неверном IP | Проверь Virtual Host: `apache2ctl -S` |
| После `netplan apply` нет сети | Неверное имя интерфейса | `ip link show` — уточни имя и обнови `NET_IF` в `config.sh` |
