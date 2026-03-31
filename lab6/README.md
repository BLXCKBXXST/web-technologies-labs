# Практическая работа №6
**Облачное файловое хранилище Seafile** на Ubuntu Server 22.04

---

## ⚙️ Параметры варианта

Все параметры хранятся **в одном файле** [`config.sh`](config.sh).  
Чтобы адаптировать скрипты под другого студента — меняй только его:

```bash
# config.sh
N="29"                          # Номер в журнале
STUDENT="yazikov"              # Фамилия транслитом
GROUP="iks531"                  # Номер группы
SEAFILE_HOSTNAME="seafile"      # Имя новой ВМ
SEAFILE_VER="9.0.9"             # Версия Seafile
NET_IF="enp0s3"                 # Сетевой интерфейс ВМ seafile
SEAFILE_SYSTEM_USER="ubuntu"    # Пользователь системы
```

---

## 📁 Файлы

| Файл | ВМ | Описание |
|---|---|---|
| `config.sh` | — | Параметры варианта (редактировать здесь) |
| `gateway_lab6_dns.sh` | gateway | Добавление A-записи seafile в DNS |
| `seafile_net_hostname.sh` | seafile | Статический IP, hostname, /etc/hosts |
| `seafile_install.sh` | seafile | Пакеты, MariaDB, pip-зависимости, скачивание Seafile |
| `seafile_setup.sh` | seafile | Подсказки перед запуском интерактивного установщика |
| `seafile_nginx.sh` | seafile | nginx как reverse-proxy |
| `seafile_services.sh` | seafile | systemd-юниты + первый запуск seafile.sh |
| `desktop_lab6_client.sh` | Desktop | Установка Seafile GUI-клиента |

---

## 🚀 Порядок запуска

### Подготовка
Скопируй папку `lab6/` на нужные ВМ (через `scp` или вставь вручную).  
Выдай права на исполнение:
```bash
chmod +x lab6/*.sh
```

---

### Шаг 1 — ВМ `gateway` (DNS)

> Предполагается, что лаб.5 уже выполнена: gateway, DHCP, Bind9 работают.

```bash
sudo bash gateway_lab6_dns.sh
```

Что делает скрипт:
- Добавляет A-запись `seafile → 192.168.29.4` в `/var/lib/bind/forward.db`
- Перезапускает bind9
- Проверяет `nslookup seafile`

Проверка:
```bash
nslookup seafile
# ожидаем: seafile.yazikov.iks531.local -> 192.168.29.4
```

---

### Шаг 2 — Клонировать ВМ seafile

В VirtualBox:
1. Клонировать из **золотого образа** Ubuntu Server 22.04
2. Имя ВМ: `seafile`
3. При клонировании — **сгенерировать новый MAC-адрес**
4. Тип сетевого адаптера: **Внутренняя сеть (intnet)**

---

### Шаг 3 — ВМ `seafile` (сеть и hostname)

```bash
sudo bash seafile_net_hostname.sh
```

Что делает скрипт:
- Прописывает статический IP `192.168.29.4/24` через netplan
- Устанавливает gateway `192.168.29.1`, DNS `192.168.29.1`
- Переименовывает сервер в `seafile`
- Обновляет `/etc/hosts`

После завершения — **перезагрузи**:
```bash
sudo reboot
```

Проверки после перезагрузки:
```bash
hostname              # seafile
ping 192.168.29.1     # gateway
ping ya.ru            # интернет
nslookup gateway      # DNS работает
```

---

### Шаг 4 — ВМ `seafile` (пакеты, MariaDB, скачивание)

```bash
sudo bash seafile_install.sh
```

Что делает скрипт:
- Устанавливает `python3`, `pip`, `libmysqlclient-dev`
- Устанавливает и запускает MariaDB
- Устанавливает pip-зависимости Seafile
- Скачивает и распаковывает Seafile в `/opt/seafile/`

> **[Интерактивный шаг]** После скрипта — задай пароль root для MariaDB:

```bash
mysqladmin -u root password
# введи пароль дважды

mysql
flush privileges;
\q;
```

---

### Шаг 5 — ВМ `seafile` (интерактивный установщик)

```bash
sudo bash seafile_setup.sh
# скрипт выведет подсказки по вводу
```

Затем **вручную**:
```bash
cd /opt/seafile/seafile-server-9.0.9/
./setup-seafile-mysql.sh
```

| Вопрос | Ответ |
|---|---|
| Server name | `seafile` |
| Server IP/Domain | `192.168.29.4` |
| Seafile server port | `8082` (Enter) |
| [1 or 2] | `1` |
| MySQL host | `localhost` (Enter) |
| MySQL port | `3306` (Enter) |
| MySQL root password | твой пароль от mysqladmin |
| Остальное | Enter (по умолчанию) |

---

### Шаг 6 — ВМ `seafile` (nginx)

```bash
sudo bash seafile_nginx.sh
```

Что делает скрипт:
- Устанавливает nginx
- Создаёт конфиг reverse-proxy на `192.168.29.4:80 → 127.0.0.1:8000`
- Удаляет дефолтный конфиг, создаёт симлинк, перезапускает nginx
- Проверяет синтаксис конфига (`nginx -t`)

Проверка:
```bash
systemctl status nginx
ss -tnlp | grep :80
```

---

### Шаг 7 — ВМ `seafile` (systemd + первый запуск)

```bash
sudo bash seafile_services.sh
```

Что делает скрипт:
- Создаёт `/etc/systemd/system/seafile.service` и `seahub.service`
- Включает автозапуск
- Запускает `seafile.sh start`

> **[Интерактивный шаг]** Первый запуск seahub — создание admin-аккаунта:

```bash
/opt/seafile/seafile-server-9.0.9/seahub.sh start
```

| Вопрос | Ответ |
|---|---|
| E-mail | `admin@yazikov.iks531.local` |
| Password | придумай сам |
| Password (again) | повтори |

---

### Шаг 8 — ВМ `Desktop` (Seafile-клиент)

```bash
sudo bash desktop_lab6_client.sh
```

Что делает скрипт:
- Добавляет PPA `ppa:seafile/seafile-client`
- Устанавливает `seafile-gui`
- Проверяет доступность сервера seafile

Далее **вручную**:
1. Открыть браузер → `http://seafile.lan` или `http://192.168.29.4`
2. Войти как `admin@yazikov.iks531.local`
3. Создать пользователя через веб-интерфейс
4. Запустить приложение Seafile, подключить сервер, синхронизировать библиотеку

---

## 🔧 Траблшутинг

| Симптом | Причина | Решение |
|---|---|---|
| `nslookup seafile` не работает с gateway | Нет A-записи в forward.db или bind не перезапущен | Проверь `nano /var/lib/bind/forward.db`, потом `systemctl restart bind9` |
| `ping 192.168.29.1` с seafile не работает | Неверный netplan или тип адаптера VirtualBox | Проверь `ip a`, тип адаптера должен быть «Внутренняя сеть intnet» |
| `ping ya.ru` с seafile не работает | Нет маршрута через gateway | Убедись, что лаб.4 настроена и gateway работает, проверь `gateway4` в netplan |
| `mysqladmin: connect to server failed` | MariaDB не запущена | `systemctl start mariadb`, `systemctl status mariadb` |
| `setup-seafile-mysql.sh` падает на MySQL | Неверный пароль root или MariaDB не запущена | Перепроверь пароль, `systemctl status mariadb` |
| `nginx -t` выдаёт ошибку | Синтаксис в `seafile.conf` | `nano /etc/nginx/sites-available/seafile.conf`, исправь, `nginx -t` снова |
| `http://seafile.lan` не открывается с Desktop | nginx не слушает или DNS не резолвит | `ss -tnlp \| grep :80` на seafile, `nslookup seafile` на Desktop |
| Seahub не стартует (ошибки при `seahub.sh start`) | Не установлены pip-зависимости или БД не создана | Проверь `seafile_install.sh`, повтори `setup-seafile-mysql.sh` |
| После перезагрузки Seafile не поднимается | systemd-юниты не включены | `systemctl enable seafile seahub`, проверь пути в unit-файлах |
| Клиент не подключается к серверу | Неверный URL или сервисы не запущены | URL = `http://192.168.29.4`, `systemctl status seafile seahub` |
