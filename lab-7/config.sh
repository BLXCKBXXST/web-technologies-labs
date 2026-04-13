#!/usr/bin/env bash
# =============================================================
#  ПАРАМЕТРЫ ВАРИАНТА — меняй только здесь под своего студента
# =============================================================

# Номер студента в журнале
N="1"

# Фамилия транслитом
STUDENT="boychenko"

# Номер группы
GROUP="iks531"

# Домен (собирается автоматически из STUDENT и GROUP)
DOMAIN="${STUDENT}.${GROUP}.local"

# Имя хоста mail-сервера
MAIL_HOSTNAME="mail"
MAIL_FQDN="${MAIL_HOSTNAME}.${DOMAIN}"

# IP-адрес mail-сервера (192.168.N.5)
MAIL_IP="192.168.${N}.5"

# Имя хоста сервера-шлюза / DNS
GW_HOSTNAME="gateway"
GW_IP="192.168.${N}.1"

# Интерфейс mail-машины (один — Internal Network)
NET_IF="enp0s3"

# Файл netplan на mail-машине
NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"

# Пути к файлам зон bind (на gateway)
FORWARD_DB="/var/lib/bind/forward.db"
REVERSE_DB="/var/lib/bind/reverse.db"

# Netplan-файл на gateway (для шага 0 в gateway_lab7_dns.sh)
GW_NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"

# Внешний интерфейс gateway (для named.conf.options listen-on)
NET_IF_INT="enp0s8"

# Версия iRedMail
# 1.6.8 — последняя версия с поддержкой Ubuntu 20.04 (focal)
IREDMAIL_VER="1.6.8"
IREDMAIL_DIR="/root/iRedMail-${IREDMAIL_VER}"
IREDMAIL_ARCHIVE="${IREDMAIL_VER}.tar.gz"
IREDMAIL_URL="https://github.com/iredmail/iRedMail/archive/refs/tags/${IREDMAIL_ARCHIVE}"

# Почтовый домен для iRedMail (НЕ должен совпадать с FQDN сервера)
MAIL_DOMAIN="${STUDENT}.${GROUP}.local"

# postmaster-пользователь
POSTMASTER="postmaster@${MAIL_DOMAIN}"
