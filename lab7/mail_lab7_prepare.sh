#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Электронная почта
#  Подготовка mail-ВМ: hostname, /etc/hosts, netplan,
#  resolv.conf, apt upgrade, загрузка iRedMail
#
#  Запускать: sudo bash mail_lab7_prepare.sh
#  ВМ: mail (192.168.N.5)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
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
echo "[OK] hostname = $(hostname -f)"

# ------------------------------------------------------------------
# ШАГ 2. /etc/hosts
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: обновление /etc/hosts ---"

BAK_HOSTS="/etc/hosts.bak_lab7"
[[ -f /etc/hosts ]] && cp /etc/hosts "${BAK_HOSTS}" && echo "[РЕЗЕРВ] /etc/hosts → ${BAK_HOSTS}"

cat >/etc/hosts <<EOF
127.0.0.1   ${MAIL_FQDN} ${MAIL_HOSTNAME} localhost
${MAIL_IP}  ${MAIL_FQDN} ${MAIL_HOSTNAME}
EOF

echo "[OK] /etc/hosts:"
cat /etc/hosts

# ------------------------------------------------------------------
# ШАГ 3. Статический IP (netplan)
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: настройка статического IP (netplan) ---"

BAK_NET="${NETPLAN_FILE}.bak_lab7"
[[ -f "${NETPLAN_FILE}" ]] && cp "${NETPLAN_FILE}" "${BAK_NET}" && echo "[РЕЗЕРВ] ${NETPLAN_FILE} → ${BAK_NET}"

DEFAULT_NP="/etc/netplan/00-installer-config.yaml"
if [[ -f "${DEFAULT_NP}" ]]; then
  cp "${DEFAULT_NP}" "${DEFAULT_NP}.bak_lab7"
  echo "[РЕЗЕРВ] ${DEFAULT_NP} → ${DEFAULT_NP}.bak_lab7"
fi

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
echo "[OK] netplan применён. IP на ${NET_IF}:"
ip -4 addr show "${NET_IF}" | grep inet || true

# ------------------------------------------------------------------
# ШАГ 4. Отключение systemd-resolved → статический resolv.conf
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: статический resolv.conf ---"

if systemctl is-active systemd-resolved >/dev/null 2>&1 || \
   systemctl is-enabled systemd-resolved >/dev/null 2>&1; then
  echo "[ИНФО] Отключаю systemd-resolved..."
  systemctl disable --now systemd-resolved || true
else
  echo "[ИНФО] systemd-resolved уже не активен."
fi

chattr -i /etc/resolv.conf 2>/dev/null || true
rm -f /etc/resolv.conf
cat >/etc/resolv.conf <<EOF
nameserver ${GW_IP}
search ${DOMAIN}
EOF
chattr +i /etc/resolv.conf
echo "[OK] /etc/resolv.conf закреплён (immutable)."

# ------------------------------------------------------------------
# ШАГ 5. Проверка сети
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: проверка сети ---"

if ping -c2 -W2 "${GW_IP}" >/dev/null 2>&1; then
  echo "[OK] ping до gateway (${GW_IP}) — успешно"
else
  echo "[ОШИБКА] Нет связи с gateway ${GW_IP}." >&2
  exit 1
fi

RESOLVED=$(dig @"${GW_IP}" "${MAIL_FQDN}" A +short 2>/dev/null | grep -oP '\d+\.\d+\.\d+\.\d+' | head -1)
if [[ "${RESOLVED}" == "${MAIL_IP}" ]]; then
  echo "[OK] DNS разрешает ${MAIL_FQDN} → ${RESOLVED}"
else
  echo "[ОШИБКА] DNS не может разрешить ${MAIL_FQDN} (получено: '${RESOLVED}')." >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 6. Обновление пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 6: обновление пакетов ---"

apt-get update -q
apt-get upgrade -y
echo "[OK] apt-get update && upgrade завершён"

# ------------------------------------------------------------------
# ШАГ 7. Загрузка iRedMail
# ------------------------------------------------------------------
echo
echo "--- Шаг 7: загрузка iRedMail ${IREDMAIL_VER} ---"

cd /root

if [[ -f "${IREDMAIL_ARCHIVE}" ]]; then
  echo "[ИНФО] Архив уже скачан: ${IREDMAIL_ARCHIVE}"
else
  echo "[ИНФО] Скачиваю ${IREDMAIL_URL}..."
  wget -q --show-progress "${IREDMAIL_URL}" -O "${IREDMAIL_ARCHIVE}"
  echo "[OK] Скачан: ${IREDMAIL_ARCHIVE}"
fi

if [[ -d "${IREDMAIL_DIR}" ]]; then
  echo "[ИНФО] Каталог ${IREDMAIL_DIR} уже существует — пропускаю распаковку."
else
  tar xf "${IREDMAIL_ARCHIVE}"
  echo "[OK] iRedMail распакован в ${IREDMAIL_DIR}"
fi

# ------------------------------------------------------------------
# ШАГ 7.5: загрузка недоступных пакетов вручную
#
# mlmmjadmin-3.1.9 и netdata выдают 404 на dl.iredmail.org для версии 1.6.8.
# Скачиваем их напрямую с GitHub/Netdata и пересчитываем sha256 в pkgs.sha256.
# ------------------------------------------------------------------
echo
echo "--- Шаг 7.5: загрузка недоступных пакетов ---"

MISC_DIR="${IREDMAIL_DIR}/pkgs/misc"
mkdir -p "${MISC_DIR}"

# mlmmjadmin-3.1.9: берём с GitHub (iredmail/mlmmjadmin tag 3.1.9)
MLMMJ_FILE="${MISC_DIR}/mlmmjadmin-3.1.9.tar.gz"
if [[ ! -f "${MLMMJ_FILE}" ]]; then
  echo "[ИНФО] Скачиваю mlmmjadmin-3.1.9 с GitHub..."
  wget -q --show-progress \
    "https://github.com/iredmail/mlmmjadmin/archive/refs/tags/3.1.9.tar.gz" \
    -O "${MLMMJ_FILE}"
  echo "[OK] mlmmjadmin-3.1.9.tar.gz"
else
  echo "[ИНФО] mlmmjadmin-3.1.9.tar.gz уже есть"
fi

# netdata-v1.44.1: берём с GitHub Releases
NETDATA_FILE="${MISC_DIR}/netdata-v1.44.1.gz.run"
if [[ ! -f "${NETDATA_FILE}" ]]; then
  echo "[ИНФО] Скачиваю netdata-v1.44.1 с GitHub..."
  wget -q --show-progress \
    "https://github.com/netdata/netdata/releases/download/v1.44.1/netdata-v1.44.1.gz.run" \
    -O "${NETDATA_FILE}"
  echo "[OK] netdata-v1.44.1.gz.run"
else
  echo "[ИНФО] netdata-v1.44.1.gz.run уже есть"
fi

# Пересчитываем sha256 для скачанных файлов и обновляем pkgs.sha256
echo "[ИНФО] Обновляю pkgs.sha256..."
SHA256_FILE="${IREDMAIL_DIR}/pkgs/pkgs.sha256"

MLMMJ_SHA=$(sha256sum "${MLMMJ_FILE}" | awk '{print $1}')
NETDATA_SHA=$(sha256sum "${NETDATA_FILE}" | awk '{print $1}')

# Заменяем строку с mlmmjadmin
sed -i "s|.*misc/mlmmjadmin-3.1.9.tar.gz.*|${MLMMJ_SHA}  misc/mlmmjadmin-3.1.9.tar.gz|" "${SHA256_FILE}"
# Заменяем строку с netdata
sed -i "s|.*misc/netdata-v1.44.1.gz.run.*|${NETDATA_SHA}  misc/netdata-v1.44.1.gz.run|" "${SHA256_FILE}"

echo "[OK] pkgs.sha256 обновлён"

# ------------------------------------------------------------------
# ШАГ 8. Загрузка остальных зависимостей (pkgs/get_all.sh)
# CHECK_NEW_IREDMAIL=NO отключает серверную проверку версии
# ------------------------------------------------------------------
echo
echo "--- Шаг 8: загрузка пакетов iRedMail (get_all.sh) ---"

cd "${IREDMAIL_DIR}/pkgs"
chmod +x get_all.sh
export CHECK_NEW_IREDMAIL=NO
./get_all.sh
echo "[OK] Пакеты iRedMail загружены"

# ------------------------------------------------------------------
# ПОДСКАЗКА: интерактивная установка iRedMail
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " [СЛЕДУЮЩИЙ ШАГ] Запуск установщика iRedMail"
echo
echo "   cd ${IREDMAIL_DIR}"
echo "   chmod +x iRedMail.sh"
echo "   ./iRedMail.sh"
echo
echo " Отвечай на вопросы установщика ТАК:"
echo
echo "   1. Mail storage path     → /var/vmail (Enter)"
echo "   2. Web server             → Nginx"
echo "   3. Database backend       → OpenLDAP"
echo "   4. LDAP suffix            → dc=${STUDENT},dc=${GROUP},dc=local"
echo "   5. Пароль LDAP rootdn     → придумай надёжный (без $ # @)"
echo "   6. Mail domain            → ${MAIL_DOMAIN}"
echo "      (НЕ совпадает с FQDN: ${MAIL_FQDN})"
echo "   7. Пароль postmaster      → придумай надёжный"
echo "   8. Компоненты             → Roundcubemail, iRedAdmin, Fail2ban — YES"
echo "   9. Confirm Installation   → y"
echo "  10. Firewall               → y"
echo
echo " После установки — ПЕРЕЗАГРУЗИ: reboot"
echo " Затем запусти: sudo bash mail_lab7_post.sh"
echo "================================================================"
