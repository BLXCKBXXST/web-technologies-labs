#!/bin/bash
# =============================================================
# Lab 5 — скрипт для скриншотов
# Запуск: sudo bash screenshots.sh
# Требуется: уже выполненная лабораторная работа №4 (шлюз + DHCP)
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
echo "  Lab 5 — Скрипт скриншотов"
echo "  Настройка DNS (BIND9) + DHCP DDNS"
echo "  Всего: 16 шагов"
echo "=============================================="
echo ""
echo "  ! Скриншот 01 (настройка VirtualBox) — вручную."
echo "    Требуется до начала работы: шлюз и DHCP уже работают."
read -rp "  → Нажми Enter когда будешь готов..."

# ---------------- ГЛАВА 2 — ПОДГОТОВКА ----------------

# 01 — VirtualBox вручную
echo ""
echo "========================================"
echo "  [Скриншот 01] Настройка адаптеров ВМ gateway в VirtualBox"
echo "  Файл: img/01_vbox_gateway_settings.png"
echo "  • VirtualBox → gateway → Настройка → Сеть"
echo "    Покажи вкладки Адаптер 1 (НАТ) и Адаптер 2 (Внутренняя сеть)"
echo "========================================"
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 02
step "02" "Файл /etc/hosts с hostnameом" \
    "nano /etc/hosts"

# 03
step "03" "Файл /etc/iptables/rules.v4 (строки DNAT DNS удалены)" \
    "nano /etc/iptables/rules.v4"

# 04
step "04" "Установка bind9 и dnsutils" \
    "apt-get update && apt install -y bind9 dnsutils"

# ---------------- ГЛАВА 3 — НАСТРОЙКА BIND9 ----------------

# 05
step "05" "Файл named.conf.options" \
    "nano /etc/bind/named.conf.options"

# 06
step "06" "Файл named.conf.local (описание зон)" \
    "nano /etc/bind/named.conf.local"

# 07
step "07" "Файл прямой зоны forward.db" \
    "nano /var/lib/bind/forward.db"

# 08
step "08" "Файл обратной зоны reverse.db" \
    "nano /var/lib/bind/reverse.db"

# 09 — важно: проверяем конфигурацию перед перезапуском
echo ""
echo "========================================"
echo "  [Скриншот 09] Проверка конфигурации BIND9"
echo "  Файл: img/09_named_checkconf.png"
echo "  Важно: обе команды должны вывести 'OK'"
echo "  Если есть ошибка — исправь файл зоны, повтори проверку."
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить проверку..."
echo ""
named-checkconf
NAME=$(hostname -s 2>/dev/null || echo "SERVERHOSTNAME")
DOMAIN=$(grep -oP 'zone "\K[^"]+\.local' /etc/bind/named.conf.local 2>/dev/null | head -1 || echo "STUDENT.GROUP.local")
REVZONE=$(grep -oP 'zone "\K[0-9]+\.168\.192[^"]+' /etc/bind/named.conf.local 2>/dev/null | head -1 || echo "N.168.192.in-addr.arpa")
echo ""
echo "  Зона: ${DOMAIN}"
named-checkzone "${DOMAIN}" /var/lib/bind/forward.db
echo ""
echo "  Зона: ${REVZONE}"
named-checkzone "${REVZONE}" /var/lib/bind/reverse.db
echo ""
read -rp "  ✔ Сделай скриншот (должно быть 'OK') и нажми Enter..."

# 10
step "10" "Файл netplan (enp0s8 с nameservers)" \
    "nano /etc/netplan/00-installer-config.yaml"

# 11 — перезапуск bind9, затем nslookup
echo ""
echo "========================================"
echo "  [Скриншот 11] Прямое разрешение через nslookup"
echo "  Файл: img/11_nslookup_forward.png"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
echo ""
systemctl restart bind9 2>/dev/null; sleep 1
NAME=$(hostname -s 2>/dev/null || echo "SERVERHOSTNAME")
nslookup "${NAME}"
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 12 — обратное разрешение
echo ""
echo "========================================"
echo "  [Скриншот 12] Обратное разрешение через nslookup"
echo "  Файл: img/12_nslookup_reverse.png"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить..."
echo ""
LANIP=$(ip -4 addr show enp0s8 2>/dev/null | grep -oP '(?<=inet )\d+\.\d+\.\d+\.\d+' | head -1 || echo "192.168.N.1")
nslookup "${LANIP}"
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 13
step "13" "Файл dhcpd.conf (блок DDNS + zone)" \
    "nano /etc/dhcp/dhcpd.conf"

# 14 — перезапуск + статус
echo ""
echo "========================================"
echo "  [Скриншот 14] Статус isc-dhcp-server (активен)"
echo "  Файл: img/14_dhcp_status.png"
echo "========================================"
read -rp "  → Нажми Enter чтобы перезапустить..."
echo ""
cp -Rr /etc/bind/rndc.key /etc/dhcp/ddns-keys 2>/dev/null || true
systemctl restart bind9
service isc-dhcp-server restart
sleep 1
service isc-dhcp-server status
echo ""
read -rp "  ✔ Сделай скриншот (active running) и нажми Enter..."

# 15 — Desktop вручную
echo ""
echo "========================================"
echo "  [Скриншот 15] Desktop зарегистрировался в DNS через DDNS"
echo "  Файл: img/15_nslookup_desktop.png"
echo "  • Перейди на Desktop → убедись что IP получен"
echo "  • Вернись на gateway, выполни:"
echo "    nslookup DESKTOPNAME01   (hostname Desktop)"
echo "========================================"
read -rp "  → Нажми Enter чтобы выполнить nslookup..."
echo ""
read -rp "  Введи hostname машины Desktop (hostname, например: desktop01): " DNAME
nslookup "${DNAME:-desktop01}"
echo ""
read -rp "  ✔ Сделай скриншот и нажми Enter..."

# 16
step "16" "Системный лог (DDNS update succeeded)" \
    "tail -40 /var/log/syslog"

# Итог
echo ""
echo "=============================================="
echo "  Все 16 скриншотов сделаны!"
echo "  Положи файлы в lab5/latex-report/img/"
echo "  имена: 01_vbox_gateway_settings.png ..."
echo "=============================================="
