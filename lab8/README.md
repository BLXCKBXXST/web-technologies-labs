# Лабораторная работа №8 — WordPress

**Тема:** Развёртывание WordPress на базе LAMP (Ubuntu Server 20.04)  
**Вариант:** N=29 | Студент: yazikov | Группа: iks531  
**Домен:** `yazikov.iks531.local`

## Скачать

**[📦 Скачать scripts.zip](https://github.com/BLXCKBXXST/web-technologies-labs/releases/download/overleaf-zips/lab8_scripts.zip)**

---

## Виртуальные машины

| ВМ | IP | ОС | Роль |
|---|---|---|---|
| `gateway` | 192.168.29.1 | Ubuntu Server 20.04 | Шлюз, DNS (BIND9), DHCP |
| `wordpress` | 192.168.29.6 | Ubuntu Server 20.04 | Веб-сервер WordPress (LAMP) |
| `desktop1` | 192.168.29.10+ | Ubuntu Desktop 20.04 | Клиент, браузер |

> ВМ `wordpress` — новый клон «золотого образа» с **одним** интерфейсом «Внутренняя сеть intnet».

---

## Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Единый конфиг варианта (N, STUDENT, DOMAIN, IP, БД…) |
| `gateway_lab8_dns.sh` | `gateway` | Добавляет A/PTR-записи для wordpress в BIND9 |
| `wordpress_lab8_prepare.sh` | `wordpress` | Hostname, netplan, LAMP, БД, WordPress |
| `wordpress_lab8_post.sh` | `wordpress` | Проверка сервисов, портов, HTTP, БД после установки |
| `desktop_lab8_check.sh` | `desktop1` | DNS/ping/порт-проверки + инструкция по заданию в wp-admin |
| `README.md` | — | Этот файл |

---

## Порядок запуска

### 0. Клонировать ВМ

Создать новую ВМ `wordpress` из «золотого образа» Ubuntu Server 20.04.  
Сетевой интерфейс: **Internal Network** (`intnet`).

---

### 1. На ВМ `gateway` — добавить DNS-запись

```bash
cd web-technologies-labs/lab8
sudo bash gateway_lab8_dns.sh
```

Скрипт добавляет:
- A-запись `wordpress → 192.168.29.6` в прямую зону
- PTR-запись `6 → wordpress.yazikov.iks531.local` в обратную зону
- Обновляет Serial, перезагружает BIND9

---

### 2. На ВМ `wordpress` — подготовка и установка

Скопируй папку `lab8` на ВМ wordpress (`scp` или `git clone`).

```bash
cd web-technologies-labs/lab8
sudo bash wordpress_lab8_prepare.sh
```

Скрипт выполняет:
- Установку hostname: `wordpress.yazikov.iks531.local`
- Настройку `/etc/hosts`
- Отключение `systemd-resolved` и запись статического `/etc/resolv.conf`
- Статический IP `192.168.29.6` через netplan
- Проверку связи с gateway, DNS и интернетом
- `apt-get update && upgrade`
- Установку LAMP (`tasksel lamp-server`) + PHP-расширения
- Настройку Apache2 (ServerName, права, Virtual Host)
- Создание БД и пользователя MySQL/MariaDB
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

Скрипт проверяет: Apache2, MySQL/MariaDB, порты 80/3306, HTTP-ответ, файлы WordPress, доступность БД.

---

### 5. На ВМ `desktop1` — проверка доступа

```bash
cd web-technologies-labs/lab8
sudo bash desktop_lab8_check.sh
```

Скрипт автоматически проверяет:
- DNS-разрешение `wordpress.yazikov.iks531.local` через gateway
- `ping 192.168.29.6` — доступность WordPress-сервера
- Порт 80 открыт (HTTP)

Затем выполни задание в браузере Firefox:

**а) Убедиться что сайт работает:**
- Открыть `http://192.168.29.6` — должна отобразиться главная страница WordPress
- То же через FQDN: `http://wordpress.yazikov.iks531.local`

**б) Создать тестовую запись:**
1. Перейти в `http://192.168.29.6/wp-admin`
2. Войти под учётными данными `admin`
3. **Записи → Добавить новую** → ввести заголовок и текст → **Опубликовать**
4. Убедиться что запись видна на `http://192.168.29.6`

**в) Создать нового пользователя:**
1. **Пользователи → Добавить нового**
2. Указать Email: `user1@yazikov.iks531.local`
3. Выбрать роль (например, Подписчик)
4. Нажать **«Добавить пользователя»**

---

## Файл паролей

Все пароли хранятся в `config.sh` — переменная `DB_PASSWORD`.  
Пароль администратора WordPress задаётся во время интерактивной установки через браузер.

---

## Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `ping gateway` не работает с wordpress-ВМ | Неверный интерфейс в netplan или ВМ не в intnet | Проверь `ip a`; убедись что ВМ в Internal Network |
| DNS не разрешает `wordpress` | A-запись не добавлена на gateway | Запусти `gateway_lab8_dns.sh` на ВМ gateway |
| `wget` не может скачать WordPress | `resolv.conf` указывает на `127.0.0.53` (`systemd-resolved`) | Скрипт отключает его автоматически |
| `Failed to enable unit: mariadb.service does not exist` | Ubuntu 20.04 `tasksel` устанавливает MySQL 8.0 вместо MariaDB | Скрипт автодетекции: если MariaDB нет — использует MySQL |
| `404 Not Found` при скачке WordPress | URL `ru.wordpress.org/latest-ruRU.tar.gz` устарел | Скрипт использует `wordpress.org/latest.tar.gz` |
| Apache не запускается | Конфликт портов или ошибка конфига | `apache2ctl configtest`; `journalctl -u apache2 -n 20` |
| HTTP-код 403 (Forbidden) | Неверные права на `/var/www/html` | `chown -R www-data:www-data /var/www/html` |
| WordPress предлагает установку повторно | `wp-config.php` не настроен или БД пуста | Проверь `wp-config.php`; запусти `wordpress_lab8_prepare.sh` заново |
| Ошибка подключения к БД при установке | Неверный пароль в `config.sh` | Поправь `DB_PASSWORD` в `config.sh` и пересоздай БД |
| `rsync: command not found` | rsync не установлен | `apt-get install -y rsync` |
| Страница не открывается с Desktop | Apache слушает на неверном IP | Проверь Virtual Host: `apache2ctl -S` |
| После `netplan apply` нет сети | Неверное имя интерфейса | `ip link show` — уточни имя и обнови `NET_IF` в `config.sh` |
