# 📸 Скриншоты — Lab 9

Интерактивный скрипт, который пошагово ведёт по всем 14 скриншотам для отчёта.

---

## ▶️ Запуск

```bash
# Из папки latex-report/ на ВМ gateway:
sudo bash screenshots/screenshots.sh
```

---

## ⚙️ Как работает скрипт

```
════════════════════════════════════════
  [Скриншот 10] ansible clients -m ping
  Файл: img/10_ansible_ping.png
════════════════════════════════════════

  → Нажми Enter чтобы выполнить команду...
  [Enter]

ansible clients -m ping    ← выполняется автоматически
...

  ✔ Сделай скриншот и нажми Enter...
  [Enter]    ← переход к следующему шагу
```

---

## 📝 Все 14 скриншотов

| № | Файл | Что показать |
|:---:|---|---|
| 01 | `01_gateway_ip_a.png` | `ip a` — все интерфейсы gateway |
| 02 | `02_client_ssh_status.png` | desktop1: `systemctl status ssh` |
| 03 | `03_wordpress_ssh_status.png` | wordpress: `systemctl status ssh` |
| 04 | `04_ping_clients.png` | `ping -c 3` до desktop1 и wordpress |
| 05 | `05_ansible_version.png` | `ansible --version` |
| 06 | `06_ssh_keygen.png` | генерация ключа `ed25519` |
| 07 | `07_ssh_copy_desktop.png` | `ssh-copy-id` → desktop1, `Number of key(s) added: 1` |
| 08 | `08_ssh_copy_wordpress.png` | `ssh-copy-id` → wordpress, `Number of key(s) added: 1` |
| 09 | `09_ansible_hosts.png` | `cat /etc/ansible/hosts` |
| 10 | `10_ansible_ping.png` | `ansible clients -m ping` → SUCCESS |
| 11 | `11_playbook_content.png` | `cat monitoring.yml` |
| 12 | `12_playbook_run.png` | `ansible-playbook monitoring.yml` → `failed=0` |
| 13 | `13_info_desktop1.png` | `cat desktop1_info.txt` |
| 14 | `14_info_wordpress.png` | `cat wordpress_info.txt` |

> **⚠️ Шаги 02, 03** — выполняются вручную на ВМ `desktop1` и `wordpress` соответственно, скрипт только напомнит что делать.
>
> **⚠️ Шаги 07, 08** — потребуются пароль пользователя клиентской ВМ.
>
> **⚠️ Шаги 09–14** — требуют завершённых шагов 06–08 (`ssh-copy-id`).

---

## 📂 Куда положить скриншоты

Файлы клади в `../img/` с именами **точно как в таблице** (`.png`, без пробелов).
