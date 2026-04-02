#!/bin/bash
# =============================================================
# Lab 5 — скрипт для скриншотов
# Запуск: sudo bash screenshots/screenshots.sh
#   (из папки latex-report/)
# =============================================================

step() {
    local NUM="$1"
    local DESC="$2"
    local CMD="$3"

    echo ""
    echo "════════════════════════════════════════"
    echo "  [Скриншот ${NUM}] ${DESC}"
    echo "  Файл: img/${NUM}_*.png"
    echo "════════════════════════════════════════"
    echo ""
    read -rp "  → Нажми Enter чтобы выполнить команду..."
    echo ""
    eval "$CMD"
    echo ""
    read -rp "  ✔ Сделай скриншот и нажми Enter для продолжения..."
}

manual() {
    local NUM="$1"
    local DESC="$2"
    local HINT="$3"

    echo ""
    echo "════════════════════════════════════════"
    echo "  [Скриншот ${NUM}] ${DESC}"
    echo "  Файл: img/${NUM}_*.png"
    echo "════════════════════════════════════════"
    echo "  • ${HINT}"
    echo ""
    read -rp "  ✔ Сделай скриншот и нажми Enter..."
}

clear
echo "════════════════════════════════════════════"
echo "  Lab 5 — Скрипт скриншотов (DNS/DDNS, BIND9)"
echo "  Всего: 16 шагов"
echo "════════════════════════════════════════════"
read -rp "  → Нажми Enter чтобы начать..."

# ---------------- ГЛАВА 2 ----------------

manual "01" "Настройки ВМ gateway в VirtualBox" \
    "VirtualBox → gateway → Настройка → Сеть — показать Адаптер 1 и 2"

step "02" "Файл /etc/hosts с прописанным hostname" \
    "nano /etc/hosts"

step "03" "Файл rules.v4 — строки DNAT DNS удалены" \
    "nano /etc/iptables/rules.v4"

step "04" "Установка bind9 и dnsutils" \
    "apt list --installed 2>/dev/null | grep -E 'bind9|dnsutils'"

# ---------------- ГЛАВА 3 ----------------

step "05" "Файл named.conf.options" \
    "nano /etc/bind/named.conf.options"

step "06" "Файл named.conf.local (описание зон)" \
    "nano /etc/bind/named.conf.local"

step "07" "Файл прямой зоны forward.db" \
    "nano /var/lib/bind/forward.db"

step "08" "Файл обратной зоны reverse.db" \
    "nano /var/lib/bind/reverse.db"

step "09" "Проверка конфигурации BIND9" \
    "named-checkconf && echo 'checkconf: OK' && named-checkzone STUDENT.GROUP.local /var/lib/bind/forward.db"

step "10" "Файл netplan gateway (с nameservers)" \
    "nano /etc/netplan/00-installer-config.yaml"

step "11" "nslookup прямое разрешение" \
    "nslookup SERVERHOSTNAME"

step "12" "nslookup обратное разрешение" \
    "nslookup 192.168.N.1"

step "13" "Файл dhcpd.conf с секцией DDNS" \
    "nano /etc/dhcp/dhcpd.conf"

step "14" "Статус isc-dhcp-server" \
    "service isc-dhcp-server status"

step "15" "nslookup имени Desktop-клиента (через DDNS)" \
    "nslookup DESKTOPNAME01"

step "16" "Лог syslog — DDNS update succeeded" \
    "tail -40 /var/log/syslog"

echo ""
echo "════════════════════════════════════════════"
echo "  Все 16 скриншотов сделаны!"
echo "  Положи файлы в lab5/latex-report/img/"
echo "════════════════════════════════════════════"
