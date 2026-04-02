#!/bin/bash
# =============================================================
# Lab 4 — скрипт для скриншотов
# Запуск: sudo bash screenshots.sh
# После каждого echo нажми Enter —
#   выполнится команда, сделай скриншот,
#   затем ещё раз Enter — следующий шаг.
# =============================================================

step() {
    local NUM="$1"
    local DESC="$2"
    local CMD="$3"

    echo ""
    echo "========================================"
    echo "  [Скриншот ${NUM}] ${DESC}"
    echo "========================================"
    echo "  Файл: img/${NUM}_*.png"
    echo ""
    read -rp "  → Нажми Enter чтобы выполнить команду..."
    echo ""
    eval "$CMD"
    echo ""
    read -rp "  ✔ Сделай скриншот и нажми Enter для продолжения..."
}

clear
echo "=============================================="
echo "  Lab 4 — Скрипт скриншотов"
echo "  Всего: 16 шагов"
echo "=============================================="
echo ""
echo "  ! Скриншот 01 (настройка VirtualBox) делается"
echo "    вручную — открой VirtualBox рядом."
read -rp "  → Нажми Enter когда будешь готов..."

# ---------------- ГЛАВА 2 ----------------

# 01 — в VirtualBox вручную
echo ""
echo "========================================"
echo "  [Скриншот 01] Настройка адаптеров ВМ gateway в VirtualBox"
echo "  Файл: img/01_vbox_adapters.png"
echo "  • Открой VirtualBox → gateway → Настройка"
echo "    → Сеть. Покажи вкладки Адаптер 1 и Адаптер 2"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 02
step "02" "Список интерфейсов до настройки (ip a)" \
    "ip a"

# 03
step "03" "Файл Netplan 00-installer-config.yaml" \
    "nano /etc/netplan/00-installer-config.yaml"

# 04
step "04" "Состояние интерфейсов после netplan apply" \
    "ip a"

# 05
step "05" "ping ya.ru с сервера" \
    "ping -c 5 ya.ru"

# 06 — на Desktop1 вручную
echo ""
echo "========================================"
echo "  [Скриншот 06] Настройка статического IP на Desktop1"
echo "  Файл: img/06_desktop_ip_manual.png"
echo "  • Перейди на Desktop1 → nm-connection-editor"
echo "    → покажи настройку IPv4 (статические параметры)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 07 — на Desktop1
echo ""
echo "========================================"
echo "  [Скриншот 07] ping шлюза с Desktop1"
echo "  Файл: img/07_ping_gateway_from_desktop.png"
echo "  • На Desktop1 выполни:"
echo "    ping 192.168.N.1"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# ---------------- ГЛАВА 3 ----------------

# 08
step "08" "Файл sysctl.conf (включён ip_forward)" \
    "nano /etc/sysctl.conf"

# 09 — dpkg-reconfigure вызовет диалог
echo ""
echo "========================================"
echo "  [Скриншот 09] Диалог iptables-persistent"
echo "  Файл: img/09_iptables_persistent_dialog.png"
echo "  • Команда вызовет диалог подтверждения —"
echo "    сделай скриншот на нём."
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить команду..."
echo ""
dpkg-reconfigure iptables-persistent
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 10
step "10" "Правила NAT (iptables -t nat -L)" \
    "iptables -t nat -L -n -v"

# 11
step "11" "Файл /etc/default/isc-dhcp-server" \
    "nano /etc/default/isc-dhcp-server"

# 12
step "12" "Файл /etc/dhcp/dhcpd.conf" \
    "nano /etc/dhcp/dhcpd.conf"

# 13
step "13" "Статус isc-dhcp-server" \
    "service isc-dhcp-server status"

# 14 — на Desktop1
echo ""
echo "========================================"
echo "  [Скриншот 14] Desktop1 получил IP от DHCP"
echo "  Файл: img/14_desktop_dhcp_ip.png"
echo "  • Перейди на Desktop1 → убедись что IP получен"
echo "    автоматически (настройки сети или ip a)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 15 — на Desktop1
echo ""
echo "========================================"
echo "  [Скриншот 15] ping ya.ru с Desktop1"
echo "  Файл: img/15_ping_yaru_desktop.png"
echo "  • На Desktop1: ping ya.ru"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 16
step "16" "Пример ошибки в syslog" \
    "tail -50 /var/log/syslog"

# Итог
echo ""
echo "=============================================="
echo "  Все 16 скриншотов сделаны!"
echo "  Положи файлы в lab4/latex-report/img/"
echo "  с именами: 01_vbox_adapters.png ..."
echo "=============================================="
