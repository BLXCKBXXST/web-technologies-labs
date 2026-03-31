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

# Имя хоста сервера-шлюза
SERVER_HOSTNAME="gateway"

# Имя хоста клиентской машины (для подсказок)
DESKTOP_HOSTNAME="desktop1"

# Сетевые интерфейсы сервера gateway
NET_IF_EXT="enp0s3"   # внешний (NAT / мост)
NET_IF_INT="enp0s8"   # внутренний (Internal Network)

# Внешний IP (NAT в VirtualBox)
EXT_IP="10.0.2.15/24"
EXT_GW="10.0.2.2"

# Файл netplan на сервере
NETPLAN_FILE="/etc/netplan/00-installer-config.yaml"

# Пути к файлам зон bind
FORWARD_DB="/var/lib/bind/forward.db"
REVERSE_DB="/var/lib/bind/reverse.db"
