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

# Домен (собирается автоматически из STUDENT и GROUP)
DOMAIN="${STUDENT}.${GROUP}.local"

# Имя почтового сервера
MAIL_HOSTNAME="mail"

# FQDN почтового сервера
MAIL_FQDN="${MAIL_HOSTNAME}.${DOMAIN}"

# IP почтового сервера (в локальной сети)
MAIL_IP="192.168.${N}.5"
MAIL_CIDR="${MAIL_IP}/24"

# Шлюз и DNS (сервер gateway из лаб.4/5)
GW_IP="192.168.${N}.1"

# Сетевой интерфейс почтового сервера
NET_IF="enp0s3"

# Файл netplan
NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"

# Пользователь-администратор почты (postmaster)
MAIL_ADMIN="postmaster@${DOMAIN}"

# Имя DNS-записи A, которую надо добавить в gateway forward.db
FORWARD_DB="/var/lib/bind/forward.db"

# URL репозитория iRedMail
IREDMAIL_VER="1.6.2"
IREDMAIL_URL="https://github.com/iredmail/iRedMail/archive/refs/tags/${IREDMAIL_VER}.tar.gz"
