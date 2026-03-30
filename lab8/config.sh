#!/usr/bin/env bash
# =============================================================
#  ПАРАМЕТРЫ ВАРИАНТА — меняй только здесь под своего студента
# =============================================================

# Номер студента в журнале
N="14"

# Фамилия транслитом
STUDENT="mazurina"

# Номер группы
GROUP="iks531"

# Домен (собирается автоматически)
DOMAIN="${STUDENT}.${GROUP}.local"

# Домен в ВЕРХНЕМ регистре (для Kerberos/SASL)
DOMAIN_UPPER="MAZURINA.IKS531.LOCAL"

# Имя хоста сервера-шлюза / почтового сервера
SERVER_HOSTNAME="gateway"

# Имя хоста клиентской машины
DESKTOP_HOSTNAME="desktop1"

# Сетевые интерфейсы сервера gateway
NET_IF_EXT="enp0s3"   # внешний (NAT / мост)
NET_IF_INT="enp0s8"   # внутренний (Internal Network)

# IP адрес сервера в локальной сети
SRV_IP="192.168.${N}.1"

# Внешний IP (NAT в VirtualBox)
EXT_IP="10.0.2.15/24"
EXT_GW="10.0.2.2"

# Файл netplan на сервере
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"

# FQDN почтового сервера
MAIL_FQDN="${SERVER_HOSTNAME}.${DOMAIN}"

# Локальные почтовые пользователи (создаются системными учётками)
MAIL_USER1="user1"
MAIL_USER1_PASS="User1pass!"
MAIL_USER2="user2"
MAIL_USER2_PASS="User2pass!"

# Протоколы Dovecot (imap pop3)
DOVECOT_PROTOCOLS="imap pop3"

# Суффикс резервных копий
BAK_SUFFIX=".bak_lab8"
