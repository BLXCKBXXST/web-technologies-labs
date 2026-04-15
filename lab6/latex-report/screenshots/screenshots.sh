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
echo "  Всего: 10 шагов"
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

# 04 — nslookup seafile
echo ""
echo "========================================"
echo "  [Скриншот 04] Разрешение имени seafile через DNS"
echo "  Файл: img/04_nslookup_seafile.png"
echo "  Выполни на ВМ Desktop или gateway:"
echo "    nslookup seafile"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# ---- ГЛАВА 3 — УСТАНОВКА SEAFILE ----

# 05 — Nginx conf
step "05" "Конфигурация Nginx (reverse proxy Seahub)" \
    "cat /etc/nginx/sites-enabled/seafile.conf"

# 06 — запуск Seafile + Seahub
echo ""
echo "========================================"
echo "  [Скриншот 06] Запуск Seafile и Seahub"
echo "  Файл: img/06_seafile_start.png"
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

# 07 — systemctl status seafile
step "07" "Статус сервиса seafile (active running)" \
    "systemctl status seafile"

# 08 — Web UI (только подсказка, снимается на Desktop)
echo ""
echo "========================================"
echo "  [Скриншот 08] Страница входа Seafile в браузере"
echo "  Файл: img/08_seafile_web_login.png"
echo "  • Перейди на ВМ Desktop → открой браузер"
echo "  • Адрес: http://seafile  (или http://192.168.N.4)"
echo "  • Войди с учётной записью admin"
echo "========================================"
read -rp "  ✔ Сделай скриншот страницы входа и нажми Enter..."

# 09 — библиотека
echo ""
echo "========================================"
echo "  [Скриншот 09] Веб-интерфейс — библиотека с файлом"
echo "  Файл: img/09_seafile_web_library.png"
echo "  • Создай библиотеку, загрузи любой файл"
echo "  • Скриншот: файл виден в списке"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 10 — синхронизация
echo ""
echo "========================================"
echo "  [Скриншот 10] Клиент Seafile — синхронизированная библиотека"
echo "  Файл: img/10_seafile_client_sync.png"
echo "  • Запусти клиент Seafile на Desktop"
echo "  • Введи адрес: http://192.168.N.4, e-mail, пароль"
echo "  • Выбери библиотеку → Start Sync"
echo "  • Скриншот: библиотека отображается как 'Synced'"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# Итог
echo ""
echo "=============================================="
echo "  Все 10 скриншотов сделаны!"
echo "  Положи файлы в lab6/latex-report/img/"
echo "  имена: 01_vbox_seafile_settings.png ..."
echo "=============================================="
