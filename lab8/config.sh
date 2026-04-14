#!/usr/bin/env bash
# =============================================================
#  ПАРАМЕТРЫ ВАРИАНТА — меняй только здесь под своего студента
# =============================================================

# Номер студента в журнале
N="29"

# Фамилия транслитом
STUDENT="yazikov"

# Номер группы
GROUP="iks531"

# Домен
DOMAIN="${STUDENT}.${GROUP}.local"

# ВМ WordPress
WP_HOSTNAME="wordpress"
WP_FQDN="${WP_HOSTNAME}.${DOMAIN}"
WP_IP="192.168.${N}.6"

# Шлюз / DNS
GW_HOSTNAME="gateway"
GW_IP="192.168.${N}.1"

# Сетевой интерфейс ВМ wordpress (один — Internal Network)
NET_IF="enp0s3"

# Файл netplan на ВМ wordpress
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"

# Пути к файлам зон bind (на gateway)
FORWARD_DB="/var/lib/bind/forward.db"
REVERSE_DB="/var/lib/bind/reverse.db"

# MySQL / MariaDB
DB_NAME="wordpress"
DB_USER="author"
DB_PASSWORD="Pssw0rd1!"   # <-- смени на свой
DB_HOST="localhost"

# URL WordPress (по IP, без HTTPS)
WP_URL="http://${WP_IP}"
