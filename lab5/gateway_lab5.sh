#!/usr/bin/env bash
# =============================================================
#  Практическая работа №5 — Часть 1
#  Настройка DNS (Bind9) на сервере gateway
#
#  Запускать: sudo bash gateway_lab5.sh
#  ВМ: gateway (Ubuntu Server)
# =============================================================
set -euo pipefail

# Загружаем параметры варианта из отдельного файла
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №5 — DNS на ${SERVER_HOSTNAME}"
echo " Домен  : ${DOMAIN}"
echo " Сеть   : 192.168.${N}.0/24"
echo " DNS/GW : 192.168.${N}.1"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Hostname
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: настройка hostname ---"
echo "[ИНФО] Текущий hostname: $(hostname)"
hostnamectl set-hostname "${SERVER_HOSTNAME}"

cat >/etc/hosts <<EOF
127.0.0.1   localhost
127.0.1.1   ${SERVER_HOSTNAME}
EOF

echo "[OK] hostname = $(hostname)"

# ------------------------------------------------------------------
# ШАГ 2. Удаление DNAT-правил DNS из iptables (лаб.4)
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: удаление DNAT-правил DNS (лаб.4) ---"
IPTABLES_RULES="/etc/iptables/rules.v4"

if [[ -f "$IPTABLES_RULES" ]]; then
  cp "$IPTABLES_RULES" "${IPTABLES_RULES}.bak_lab4"
  echo "[РЕЗЕРВ] ${IPTABLES_RULES}.bak_lab4"
  sed -i '/--dport 53 -j DNAT --to-destination 8\.8\.8\.8:53/d' "$IPTABLES_RULES"
  echo "[OK] DNAT-строки удалены."
else
  echo "[ПРЕДУПРЕЖДЕНИЕ] ${IPTABLES_RULES} не найден — пропускаю."
fi

# ------------------------------------------------------------------
# ШАГ 3. Установка bind9
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: установка bind9, dnsutils ---"
apt-get update -y
apt-get install -y bind9 dnsutils
echo "[OK] bind9 установлен: $(named -v 2>&1 | head -1)"

# ------------------------------------------------------------------
# ШАГ 4. named.conf.options
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: настройка named.conf.options ---"
NAMED_OPTIONS="/etc/bind/named.conf.options"
cp "$NAMED_OPTIONS" "${NAMED_OPTIONS}.bak_lab5" 2>/dev/null || true

cat >"$NAMED_OPTIONS" <<EOF
options {
    directory "/var/cache/bind";

    forwarders {
        8.8.8.8;
    };

    dnssec-validation auto;

    auth-nxdomain no;    # conform to RFC1035
    listen-on {
        127.0.0.1;
        192.168.${N}.1;
    };
};
EOF

echo "[OK] named.conf.options обновлён."

# ------------------------------------------------------------------
# ШАГ 5. named.conf.local
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: настройка named.conf.local ---"
NAMED_LOCAL="/etc/bind/named.conf.local"
cp "$NAMED_LOCAL" "${NAMED_LOCAL}.bak_lab5" 2>/dev/null || true

cat >"$NAMED_LOCAL" <<EOF
include "/etc/bind/rndc.key";

controls {
    inet 127.0.0.1 allow { localhost; } keys { rndc-key; };
};

zone "${DOMAIN}" IN {
    type master;
    file "${FORWARD_DB}";
    allow-update { key rndc-key; };
};

zone "${N}.168.192.in-addr.arpa" IN {
    type master;
    file "${REVERSE_DB}";
    allow-update { key rndc-key; };
};
EOF

echo "[OK] named.conf.local обновлён."

# ------------------------------------------------------------------
# ШАГ 6. Зона прямого просмотра forward.db
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: создание ${FORWARD_DB} ---"
mkdir -p /var/lib/bind

cat >"$FORWARD_DB" <<EOF
\$TTL    86400
${DOMAIN}.    IN      SOA     ${SERVER_HOSTNAME}.${DOMAIN}. admin.${DOMAIN}. (
                         20110103         ; Serial
                         604800           ; Refresh
                         86400            ; Retry
                         2419200          ; Expire
                         604800 )         ; Negative Cache TTL
;
            IN      NS      ${SERVER_HOSTNAME}.${DOMAIN}.
            IN      A       192.168.${N}.1
localhost    IN      A       127.0.0.1
${SERVER_HOSTNAME}    IN      A       192.168.${N}.1
EOF

chown root:bind "$FORWARD_DB" 2>/dev/null || true
echo "[OK] forward.db создан."

# ------------------------------------------------------------------
# ШАГ 7. Зона обратного просмотра reverse.db
# ------------------------------------------------------------------
echo
echo "--- Шаг 7: создание ${REVERSE_DB} ---"

cat >"$REVERSE_DB" <<EOF
\$TTL  86400        ; 1 day
${N}.168.192.in-addr.arpa. IN SOA ${DOMAIN}. ${DOMAIN}. (
                                        20110104      ; Serial
                                        10800         ; Refresh
                                        3600          ; Retry
                                        604800        ; Expire
                                        3600  )       ; Minimum
                IN      NS      ${SERVER_HOSTNAME}.${DOMAIN}.
1               IN      PTR     ${DOMAIN}.
1               IN      PTR     ${SERVER_HOSTNAME}.${DOMAIN}.
EOF

chown root:bind "$REVERSE_DB" 2>/dev/null || true
echo "[OK] reverse.db создан."

# ------------------------------------------------------------------
# ШАГ 8. netplan
# ------------------------------------------------------------------
echo
echo "--- Шаг 8: обновление ${NETPLAN_FILE} ---"

if [[ -f "$NETPLAN_FILE" ]]; then
  cp "$NETPLAN_FILE" "${NETPLAN_FILE}.bak_lab5"
  echo "[РЕЗЕРВ] ${NETPLAN_FILE}.bak_lab5"

  cat >"$NETPLAN_FILE" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${NET_IF_EXT}:
      dhcp4: no
      addresses:
        - ${EXT_IP}
      gateway4: ${EXT_GW}
    ${NET_IF_INT}:
      dhcp4: no
      addresses:
        - 192.168.${N}.1/24
      nameservers:
        addresses: [192.168.${N}.1]
        search: [${DOMAIN}]
EOF

  netplan apply
  echo "[OK] netplan применён."
else
  echo "[ПРЕДУПРЕЖДЕНИЕ] ${NETPLAN_FILE} не найден — пропускаю."
fi

# ------------------------------------------------------------------
# ШАГ 9. Отключение systemd-resolved → фиксированный resolv.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 9: отключение systemd-resolved ---"

if systemctl is-enabled systemd-resolved >/dev/null 2>&1 || \
   systemctl is-active  systemd-resolved >/dev/null 2>&1; then
  echo "[ИНФО] Отключаю systemd-resolved..."
  systemctl disable --now systemd-resolved || true
else
  echo "[ИНФО] systemd-resolved уже отключен."
fi

rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver 192.168.${N}.1
search ${DOMAIN}
EOF

echo "[OK] /etc/resolv.conf → nameserver 192.168.${N}.1"

# ------------------------------------------------------------------
# ШАГ 10. Перезапуск bind9 + проверка
# ------------------------------------------------------------------
echo
echo "--- Шаг 10: перезапуск bind9 + проверка ---"
systemctl restart bind9
sleep 2

echo "[ИНФО] Статус bind9:"
systemctl --no-pager --full status bind9 || true

echo
echo "[ИНФО] nslookup ${SERVER_HOSTNAME}:"
nslookup "${SERVER_HOSTNAME}" || echo "[ОШИБКА] nslookup провалился. Смотри: tail -40 /var/log/syslog"

echo
echo "[ИНФО] nslookup 192.168.${N}.1 (обратная зона):"
nslookup "192.168.${N}.1" || echo "[ОШИБКА] Обратный nslookup провалился."

echo
echo "================================================================"
echo " Шаг 10 готов. Рекомендуется: reboot"
echo " После перезагрузки запусти gateway_lab5_dhcp_ddns.sh"
echo "================================================================"
