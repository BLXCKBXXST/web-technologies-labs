#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Электронная почта
#  Подготовка mail-ВМ: сеть, hostname, /etc/hosts, загрузка iRedMail
#
#  Запускать: sudo bash mail_lab7_prepare.sh
#  ВМ: mail (192.168.N.5)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — Подготовка ВМ mail"
echo " Hostname : ${MAIL_FQDN}"
echo " IP       : ${MAIL_IP}"
echo " Домен    : ${DOMAIN}"
echo " Gateway  : ${GW_IP}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Hostname
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: установка hostname ---"

echo "[ИНФО] Старый hostname: $(hostname)"
hostnamectl set-hostname "${MAIL_FQDN}"

BAK_HOSTS="/etc/hosts.bak_lab7"
[[ -f /etc/hosts ]] && cp /etc/hosts "${BAK_HOSTS}" && echo "[РЕЗЕРВ] /etc/hosts → ${BAK_HOSTS}"

cat >/etc/hosts <<EOF
127.0.0.1   ${MAIL_FQDN} ${MAIL_HOSTNAME} localhost
${MAIL_IP}  ${MAIL_FQDN} ${MAIL_HOSTNAME}
EOF

echo "[OK] hostname = $(hostname -f)"

# ------------------------------------------------------------------
# ШАГ 2. Статический IP (netplan)
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: настройка статического IP ---"

BAK_NET="${NETPLAN_FILE}.bak_lab7"
[[ -f "${NETPLAN_FILE}" ]] && cp "${NETPLAN_FILE}" "${BAK_NET}" && echo "[РЕЗЕРВ] ${NETPLAN_FILE} → ${BAK_NET}"

mkdir -p "$(dirname "${NETPLAN_FILE}")"
cat >"${NETPLAN_FILE}" <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    ${NET_IF}:
      dhcp4: no
      addresses: [${MAIL_IP}/24]
      gateway4: ${GW_IP}
      nameservers:
        addresses: [${GW_IP}]
        search: [${DOMAIN}]
EOF

netplan apply
sleep 2
echo "[OK] netplan применён"

# ------------------------------------------------------------------
# ШАГ 3. Проверка сети
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: проверка сети ---"

if ping -c2 -W2 "${GW_IP}" >/dev/null 2>&1; then
  echo "[OK] ping до gateway (${GW_IP}) — успешно"
else
  echo "[ОШИБКА] Нет связи с gateway ${GW_IP}. Проверь интерфейс ${NET_IF}." >&2
  exit 1
fi

if host "${MAIL_FQDN}" "${GW_IP}" >/dev/null 2>&1; then
  echo "[OK] DNS разрешает ${MAIL_FQDN}"
else
  echo "[ОШИБКА] DNS не может разрешить ${MAIL_FQDN}." >&2
  echo "[ИНФО]   Убедись, что на gateway уже запущен gateway_lab7_dns.sh" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 4. Обновление пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: обновление списка пакетов ---"

apt-get update -q
echo "[OK] apt-get update завершён"

# ------------------------------------------------------------------
# ШАГ 5. Загрузка iRedMail
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: загрузка iRedMail ${IREDMAIL_VER} ---"

cd /root

if [[ -d "${IREDMAIL_DIR}" ]]; then
  echo "[ИНФО] Директория ${IREDMAIL_DIR} уже существует. Пропускаю загрузку."
else
  echo "[ИНФО] Скачиваю ${IREDMAIL_URL}..."
  wget -q --show-progress "${IREDMAIL_URL}" -O "${IREDMAIL_ARCHIVE}"
  tar xvf "${IREDMAIL_ARCHIVE}"
  echo "[OK] iRedMail распакован в ${IREDMAIL_DIR}"
fi

# ------------------------------------------------------------------
# ШАГ 6. Загрузка зависимостей iRedMail
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: загрузка пакетов iRedMail (get_all.sh) ---"

cd "${IREDMAIL_DIR}/pkgs"
chmod +x get_all.sh
./get_all.sh
echo "[OK] Пакеты iRedMail загружены"

# ------------------------------------------------------------------
# ПОДСКАЗКА: интерактивная установка
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " [СЛЕДУЮЩИЙ ШАГ] Запустите установщик iRedMail:"
echo
echo "   cd ${IREDMAIL_DIR}"
echo "   chmod +x iRedMail.sh"
echo "   ./iRedMail.sh"
echo
echo " В установщике выбери:"
echo "   1) Mail storage path     : /var/vmail (по умолчанию)"
echo "   2) Веб-сервер            : Nginx"
echo "   3) База данных           : OpenLDAP"
echo "   4) LDAP suffix           : dc=${STUDENT},dc=${GROUP},dc=local"
echo "   5) Пароль admin БД       : <придумай надёжный пароль>"
echo "   6) Почтовый домен        : ${MAIL_DOMAIN}"
echo "      (НЕ совпадает с FQDN: ${MAIL_FQDN})"
echo "   7) Пароль postmaster     : <придумай надёжный пароль>"
echo "   8) Доп. компоненты       : Roundcubemail, iRedAdmin, Fail2ban — YES"
echo "   9) Остальные вопросы     : YES"
echo "  10) Перезагрузи сервер    : reboot"
echo
echo " После перезагрузки: sudo bash mail_lab7_post.sh"
echo "================================================================"
