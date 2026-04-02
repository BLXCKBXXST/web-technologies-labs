#!/bin/bash
# =============================================================
# Lab 6 — скрипт для скриншотов
# Запуск: sudo bash screenshots/screenshots.sh
# Требуется: шлюз (lab4) и DNS (lab5) уже настроены,
#            ВМ seafile создана, IP статический назначен
# =============================================================

step() {
    local NUM="$1"
    local DESC="$2"
    local CMD="$3"

    echo ""
    echo "========================================"
    echo "  [Скриншот ${NUM}] ${DESC}"
    echo "  Файл: img/${NUM}_*.png"
    echo "========================================"
    echo ""
    read -rp "  → Нажми Enter чтобы выполнить команду..."
    echo ""
    eval "$CMD"
    echo ""
    read -rp "  ✔ Сделай скриншот и нажми Enter для продолжения..."
}

clear
echo "=============================================="
echo "  Lab 6 — Скрипт скриншотов"
echo "  Облачное файловое хранилище Seafile"
echo "  Всего: 15 шагов"
echo "=============================================="
echo ""
echo "  ! Скриншот 01 (настройка VirtualBox) — вручную."
echo "    Убедись что ВМ seafile подключена к Internal Network."
read -rp "  → Нажми Enter когда будешь готов..."

# ---- ГЛАВА 2 — ПОДГОТОВКА ВМ ----

# 01 — VirtualBox вручную
echo ""
echo "========================================"
echo "  [Скриншот 01] Настройка адаптера ВМ seafile в VirtualBox"
echo "  Файл: img/01_vbox_seafile_settings.png"
echo "  • VirtualBox → seafile → Настройка → Сеть"
echo "    Адаптер 1: Internal Network (intnet)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 02
step "02" "Файл netplan — статический IP seafile" \
    "cat /etc/netplan/00-installer-config.yaml"

# 03 — проверка связи
echo ""
echo "========================================"
echo "  [Скриншот 03] Проверка связи: ping gateway и ping ya.ru"
echo "  Файл: img/03_ping_gateway.png"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
echo ""
GW=$(ip route | awk '/default/{print $3; exit}' || echo "192.168.N.1")
ping -c 3 "${GW}" 2>/dev/null || ping -c 3 gateway
echo ""
ping -c 3 ya.ru
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 04 — nslookup seafile (выполняется на gateway или здесь если DNS настроен)
echo ""
echo "========================================"
echo "  [Скриншот 04] Разрешение имени seafile через DNS"
echo "  Файл: img/04_nslookup_seafile.png"
echo "  Выполни на ВМ Desktop или gateway:"
echo "    nslookup seafile"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# ---- ГЛАВА 3 — УСТАНОВКА SEAFILE ----

# 05 — установка зависимостей
echo ""
echo "========================================"
echo "  [Скриншот 05] Установка Python-зависимостей Seafile"
echo "  Файл: img/05_apt_install_deps.png"
echo "  Команды:"
echo "    apt-get update"
echo "    apt install python3 python3-setuptools python3-pip libmysqlclient-dev"
echo "    pip3 install django==3.2.* Pillow pylibmc captcha jinja2 ..."
echo "========================================"
read -rp "  → Нажми Enter чтобы установить системные пакеты..."
echo ""
apt-get update -q
apt install -y python3 python3-setuptools python3-pip libmysqlclient-dev
echo ""
pip3 install --timeout=3600 \
    "django>=3.2,<4.0" Pillow pylibmc captcha jinja2 \
    "sqlalchemy==1.4.3" django-pylibmc django-simple-captcha \
    mysqlclient "pycryptodome==3.12.0" "cffi==1.14.0" 2>&1 | tail -20
echo ""
read -rp "  ✔ Сделай скриншот (завершение pip3 install) и нажми Enter..."

# 06 — MariaDB
step "06" "Установка MariaDB + настройка root" \
    "apt install -y mariadb-server && mysqladmin -u root password && mysql -u root -e 'flush privileges;'"

# 07 — setup-seafile-mysql.sh (только открываем директорию)
echo ""
echo "========================================"
echo "  [Скриншот 07] Запуск setup-seafile-mysql.sh"
echo "  Файл: img/07_setup_seafile_sh.png"
echo "  Если ещё не выполнено:"
echo "    mkdir /opt/seafile && cd /opt/seafile"
echo "    wget https://s3.eu-central-1.amazonaws.com/download.seadrive.org/seafile-server_9.0.9_x86-64.tar.gz"
echo "    tar -xzf seafile-server_9.0.9_x86-64.tar.gz"
echo "    cd seafile-server-9.0.9"
echo "    ./setup-seafile-mysql.sh"
echo "========================================"
read -rp "  ✔ Сделай скриншот финального вывода скрипта и нажми Enter..."

# 08 — Nginx conf
step "08" "Конфигурация Nginx (reverse proxy Seahub)" \
    "cat /etc/nginx/sites-enabled/seafile.conf"

# 09 — запуск Seafile + Seahub
echo ""
echo "========================================"
echo "  [Скриншот 09] Запуск Seafile и Seahub"
echo "  Файл: img/09_seafile_start.png"
echo "========================================"
read -rp "  → Нажми Enter чтобы запустить..."
echo ""
SF_DIR="/opt/seafile/seafile-server-9.0.9"
if [ -d "${SF_DIR}" ]; then
    "${SF_DIR}/seafile.sh" start
    echo ""
    "${SF_DIR}/seahub.sh" start
else
    echo "  Директория ${SF_DIR} не найдена."
    echo "  Запусти вручную: ./seafile.sh start && ./seahub.sh start"
fi
echo ""
read -rp "  ✔ Сделай скриншот (Started) и нажми Enter..."

# 10 — создание admin (только описание — интерактивно при первом seahub.sh start)
echo ""
echo "========================================"
echo "  [Скриншот 10] Создание учётной записи администратора"
echo "  Файл: img/10_seahub_admin_create.png"
echo "  При первом запуске seahub.sh спрашивает e-mail и пароль."
echo "  Скриншот должен показывать: e-mail/пароль введены + 'Done.'"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 11 — systemctl status seafile
step "11" "Статус сервиса seafile (active running)" \
    "systemctl status seafile"

# 12 — Web UI (только подсказка, снимается на Desktop)
echo ""
echo "========================================"
echo "  [Скриншот 12] Страница входа Seafile в браузере"
echo "  Файл: img/12_seafile_web_login.png"
echo "  • Перейди на ВМ Desktop → открой браузер"
echo "  • Адрес: http://seafile  (или http://192.168.N.4)"
echo "  • Войди с учётной записью admin"
echo "========================================"
read -rp "  ✔ Сделай скриншот страницы входа и нажми Enter..."

# 13 — библиотека
echo ""
echo "========================================"
echo "  [Скриншот 13] Веб-интерфейс — библиотека с файлом"
echo "  Файл: img/13_seafile_web_library.png"
echo "  • Создай библиотеку, загрузи любой файл"
echo "  • Скриншот: файл виден в списке"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 14 — установка клиента (на Desktop)
echo ""
echo "========================================"
echo "  [Скриншот 14] Установка seafile-gui на Desktop"
echo "  Файл: img/14_seafile_client_install.png"
echo "  Выполни на ВМ Desktop:"
echo "    sudo add-apt-repository ppa:seafile/seafile-client"
echo "    sudo apt-get update"
echo "    sudo apt-get install seafile-gui"
echo "========================================"
read -rp "  ✔ Сделай скриншот завершения установки и нажми Enter..."

# 15 — синхронизация
echo ""
echo "========================================"
echo "  [Скриншот 15] Клиент Seafile — синхронизированная библиотека"
echo "  Файл: img/15_seafile_client_sync.png"
echo "  • Запусти клиент Seafile на Desktop"
echo "  • Введи адрес: http://192.168.N.4, e-mail, пароль"
echo "  • Выбери библиотеку → Start Sync"
echo "  • Скриншот: библиотека отображается как 'Synced'"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# Итог
echo ""
echo "=============================================="
echo "  Все 15 скриншотов сделаны!"
echo "  Положи файлы в lab6/latex-report/img/"
echo "  имена: 01_vbox_seafile_settings.png ..."
echo "=============================================="
