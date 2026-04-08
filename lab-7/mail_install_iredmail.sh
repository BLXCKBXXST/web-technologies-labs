#!/usr/bin/env bash
# =============================================================
#  Практическая работа №7 — Установка iRedMail
#  Скачивает iRedMail, устанавливает зависимости,
#  запускает автоматические части и выводит подсказки
#  по интерактивному установщику.
#
#  Запускать: sudo bash mail_install_iredmail.sh
#  ВМ: mail (Ubuntu Server 22.04)
# =============================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=config.sh
source "${SCRIPT_DIR}/config.sh"

echo "================================================================"
echo " Лабораторная №7 — Установка iRedMail ${IREDMAIL_VER}"
echo " FQDN    : ${MAIL_FQDN}"
echo " Домен   : ${DOMAIN}"
echo " Admin   : ${MAIL_ADMIN}"
echo "================================================================"

if [[ $EUID -ne 0 ]]; then
  echo "[ОШИБКА] Запустите от root: sudo bash $0" >&2
  exit 1
fi

# ------------------------------------------------------------------
# ШАГ 1. Обновление пакетов
# ------------------------------------------------------------------
echo
echo "--- Шаг 1: обновление пакетов ---"
apt-get update -y
apt-get upgrade -y
echo "[OK] Пакеты обновлены."

# ------------------------------------------------------------------
# ШАГ 2. Проверка hostname
# ------------------------------------------------------------------
echo
echo "--- Шаг 2: проверка FQDN ---"
CURRENT_FQDN="$(hostname -f 2>/dev/null || hostname)"
if [[ "${CURRENT_FQDN}" != "${MAIL_FQDN}" ]]; then
  echo "[ПРЕДУПРЕЖДЕНИЕ] Ожидается hostname '${MAIL_FQDN}', текущий: '${CURRENT_FQDN}'"
  echo "[ИНФО] Устанавливаю hostname принудительно..."
  hostnamectl set-hostname "${MAIL_FQDN}"
  cat >/etc/hosts <<EOF
127.0.0.1   ${MAIL_FQDN} ${MAIL_HOSTNAME} localhost
${MAIL_IP}   ${MAIL_FQDN} ${MAIL_HOSTNAME}
EOF
  echo "[OK] hostname = $(hostname -f)"
else
  echo "[OK] hostname = ${CURRENT_FQDN}"
fi

# ------------------------------------------------------------------
# ШАГ 3. Скачивание iRedMail
# ------------------------------------------------------------------
echo
echo "--- Шаг 3: скачивание iRedMail ${IREDMAIL_VER} ---"

ARCHIVE="/root/${IREDMAIL_VER}.tar.gz"
DIR="/root/iRedMail-${IREDMAIL_VER}"

if [[ -f "${ARCHIVE}" ]]; then
  echo "[ИНФО] Архив уже скачан: ${ARCHIVE}"
else
  wget -O "${ARCHIVE}" "${IREDMAIL_URL}"
  echo "[OK] Скачан: ${ARCHIVE}"
fi

# ------------------------------------------------------------------
# ШАГ 4. Распаковка
# ------------------------------------------------------------------
echo
echo "--- Шаг 4: распаковка архива ---"

if [[ -d "${DIR}" ]]; then
  echo "[ИНФО] Каталог ${DIR} уже существует — пропускаю распаковку."
else
  cd /root
  tar xvf "${ARCHIVE}"
  echo "[OK] Распаковано в ${DIR}"
fi

# ------------------------------------------------------------------
# ШАГ 5. Скачивание пакетов (get_all.sh)
# ------------------------------------------------------------------
echo
echo "--- Шаг 5: скачивание пакетов iRedMail (pkgs/get_all.sh) ---"

cd "${DIR}/pkgs"
chmod +x get_all.sh
./get_all.sh
echo "[OK] Пакеты скачаны."

# ------------------------------------------------------------------
# ШАГ 6. Интерактивный установщик iRedMail
# ------------------------------------------------------------------
echo
echo "================================================================"
echo " [ИНТЕРАКТИВНЫЙ ШАГ] Запуск установщика iRedMail"
echo
echo " Отвечай на вопросы установщика ТАК:"
echo
echo " 1. Default mail storage path:"
echo "      → Enter (оставь /var/vmail)"
echo
echo " 2. Web server:"
echo "      → Nginx (пробел для выбора, Enter для подтверждения)"
echo
echo " 3. Backend used to store mail accounts:"
echo "      → OpenLDAP"
echo
echo " 4. LDAP suffix (root dn):"
echo "      → dc=${STUDENT},dc=${GROUP},dc=local"
echo "      (пример: dc=yazikov,dc=iks531,dc=local)"
echo
echo " 5. Password for LDAP rootdn:"
echo "      → Придумай и запомни!"
echo
echo " 6. Your first mail domain name:"
echo "      → ${DOMAIN}"
echo "      (НЕ должен совпадать с hostname: ${MAIL_FQDN})"
echo
echo " 7. Password for mail domain administrator:"
echo "      → Придумай и запомни! (без \$, #, @)"
echo
echo " 8. Optional components:"
echo "      → Выбери: Roundcubemail, netdata, iRedAdmin, Fail2ban"
echo "      → SOGo оставь невыбранным (необязательно)"
echo
echo " 9. Confirm Installation:"
echo "      → y (подтвердить)"
echo
echo " 10. Firewall:"
echo "      → y (рекомендуется)"
echo
echo " После завершения установщик попросит REBOOT — нажми y."
echo "================================================================"
echo
read -r -p "Нажми Enter, чтобы запустить установщик iRedMail..."

cd "${DIR}"
chmod +x iRedMail.sh
./iRedMail.sh

echo
echo "================================================================"
echo " Установщик завершён."
echo " После перезагрузки открой веб-интерфейс с ВМ Desktop:"
echo
echo "   Веб-почта  : https://${MAIL_FQDN}/mail"
echo "   Панель адм : https://${MAIL_FQDN}/iredadmin"
echo "   Логин      : ${MAIL_ADMIN}"
echo "   Пароль     : <указанный при установке>"
echo "================================================================"
