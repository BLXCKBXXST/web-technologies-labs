# Скриншоты для лабораторной работы №7

## Запуск скрипта

```bash
sudo bash screenshots/screenshots.sh
```

Скрипт запускается на **ВМ `mail`** (Ubuntu Server). Ряд шагов выполняется
на ВМ `gateway` (DNS) и ВМ `Desktop` (браузер) — скрипт сигнализирует об этом.

---

## Механика работы

Каждый шаг выглядит так:

```
========================================
  [Скриншот NN] Описание
========================================
  Файл: img/NN_название.png

  → Нажми Enter чтобы выполнить команду...

<вывод команды>

  ✔ Сделай скриншот и нажми Enter для продолжения...
```

Для шагов в VirtualBox GUI и браузере скрипт выводит инструкции и ждёт подтверждения.

---

## Таблица скриншотов

| № | Файл | Где снимать | Что показать |
|---|------|-------------|---------------|
| 01 | `01_vbox_mail_settings.png` | Хост (VirtualBox GUI) | Настройки ВМ mail → Сеть, Адаптер 1: Внутренняя сеть intnet |
| 02 | `02_netplan_mail.png` | ВМ mail | Файл `/etc/netplan/01-netcfg.yaml` с статическим IP |
| 03 | `03_hostname_fqdn.png` | ВМ mail | Вывод `hostname -f` = `mail.yazikov.iks531.local` и `cat /etc/hosts` |
| 04 | `04_nslookup_mail.png` | ВМ mail | Вывод `nslookup mail` (успешное разрешение DNS) |
| 05 | `05_ping_internet.png` | ВМ mail | `ping -c3 ya.ru` — пакеты проходят |
| 06 | `06_wget_iredmail.png` | ВМ mail | Завершение `wget` архива iRedMail (100%) |
| 07 | `07_get_all_done.png` | ВМ mail | Завершение `pkgs/get_all.sh` |
| 08 | `08_install_storage.png` | ВМ mail | Экран установщика: Default mail storage path |
| 09 | `09_install_webserver.png` | ВМ mail | Экран установщика: выбор Nginx |
| 10 | `10_install_backend.png` | ВМ mail | Экран установщика: выбор OpenLDAP |
| 11 | `11_install_ldap_suffix.png` | ВМ mail | Экран установщика: LDAP suffix `dc=yazikov,dc=iks531,dc=local` |
| 12 | `12_install_mail_domain.png` | ВМ mail | Экран установщика: первый домен `yazikov.iks531.local` |
| 13 | `13_install_components.png` | ВМ mail | Экран установщика: выбор компонентов (Roundcube, iRedAdmin и др.) |
| 14 | `14_install_done.png` | ВМ mail | Финальный экран установщика: Installation completed |
| 15 | `15_services_status.png` | ВМ mail | `systemctl status postfix` (active running) |
| 16 | `16_iredadmin_login.png` | Desktop (Firefox) | Форма входа iRedAdmin: `https://mail.yazikov.iks531.local/iredadmin` |
| 17 | `17_iredadmin_add_user.png` | Desktop (Firefox) | Форма создания пользователя `user1@yazikov.iks531.local` |
| 18 | `18_iredadmin_user_list.png` | Desktop (Firefox) | Список пользователей: postmaster + user1 |
| 19 | `19_roundcube_inbox.png` | Desktop (Firefox) | Roundcube Inbox postmaster (вход: `https://mail.yazikov.iks531.local/mail`) |
| 20 | `20_roundcube_compose.png` | Desktop (Firefox) | Форма Compose: To: `user1@yazikov.iks531.local`, Subject: Тест ЛР-7 |
| 21 | `21_roundcube_received.png` | Desktop (Firefox) | Inbox user1 с пришедшим письмом |
| 22 | `22_roundcube_open_letter.png` | Desktop (Firefox) | Открытое письмо — тема и текст |
| 23 | `23_mail_log.png` | ВМ mail | `tail -30 /var/log/mail.log` — строка `status=sent` |

---

## Предупреждения

> ⚠️ **Зависимость от лаб.5:** на ВМ `gateway` должен работать BIND9
> и быть добавлена A-запись `mail → 192.168.29.5`.
> Выполни `sudo bash gateway_add_mail_dns.sh` перед скриншотами.

> ⚠️ **Скриншоты 08–13 (установщик):** сделай их в процессе реального запуска
> `./iRedMail.sh`. Повторно пройти установщик не получится без переустановки ВМ.

> ⚠️ **SSL-сертификат:** браузер покажет предупреждение — это ожидаемо.
> Нажми Advanced → Accept the Risk.

---

## Перенос скриншотов на хост

```bash
# С ВМ mail на хост
scp img/*.png user@<HOST_IP>:/path/to/lab-7/latex-report/img/

# Или через общую папку VirtualBox
# Настрой Shared Folders в VirtualBox → скопируй PNG в смонтированную папку
```
