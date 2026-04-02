# Лабораторная работа №4 — LaTeX-отчёт

**Тема:** NAT и DHCP-сервер на VirtualBox (Ubuntu 20.04 Server + Ubuntu Desktop)

## Структура папки

```
latex-report/
├── main.tex              # Главный файл, точка входа для компилятора
├── config.tex            # Номер студента (подставить!), настройки оформления
├── refs.bib              # Список литературы
├── screenshots.sh        # Интерактивный скрипт для сбора скриншотов
├── fonts/                # шрифты Times New Roman (.ttf)
├── img/                  # ← Сюда класть скриншоты (.png)
└── parts/
    ├── titlepage.tex
    ├── intro.tex
    ├── chap2.tex             # Гл. 2: стенд и настройка интерфейсов
    ├── chap3.tex             # Гл. 3: NAT, DHCP, траблшутинг
    └── conclusion.tex
```

---

## Шаг 1 — Установи номер студента

Открой `config.tex` и поменяй число номера студента в журнале (N):

```tex
\newcommand{\cfgLabStudentN}{99}  % <-- здесь
```

Это число подставляется во все места отчёта, где встречается `192.168.N.x`.

---

## Шаг 2 — Сделай скриншоты (screenshots.sh)

Отчёт требует **16 скриншотов** в папке `img/`. Скрипт поведёт по каждому шагу.

### Запуск на ВМ **gateway**:

```bash
# 1. Перейди в папку с файлами отчёта
cd /path/to/lab4/latex-report

# 2. Дай права на исполнение (один раз)
chmod +x screenshots.sh

# 3. Запусти
chmod +x screenshots.sh && sudo bash screenshots.sh
```

### Как работает скрипт:

1. На экране появляется описание скриншота и имя файла
2. Нажимаешь **Enter** → выполняется нужная команда
3. Делаешь скриншот (программа захвата экрана, VirtualBox → Машина → Сделать снимок экрана, или host-инструмент)
4. Нажимаешь **Enter** ещё раз → следующий шаг

### Особые шаги (делаются вручную, скрипт подскажет):

| № | Файл | Что сделать |
|---|---|---|
| 01 | `01_vbox_adapters.png` | VirtualBox → gateway → Настройка → Сеть → Адаптер 1 + Адаптер 2 |
| 06 | `06_desktop_ip_manual.png` | Desktop1: `nm-connection-editor` → вкладка IPv4 |
| 07 | `07_ping_gateway_from_desktop.png` | Desktop1: `ping 192.168.N.1` |
| 09 | `09_iptables_persistent_dialog.png` | Диалог вызовется автоматически |
| 14 | `14_desktop_dhcp_ip.png` | Desktop1: настройки сети или `ip a` |
| 15 | `15_ping_yaru_desktop.png` | Desktop1: `ping ya.ru` |

### Полный список скриншотов:

| № | Файл | Команда / что показать |
|---|---|---|
| 01 | `01_vbox_adapters.png` | Настройка адаптеров ВМ в VirtualBox |
| 02 | `02_ip_a_before.png` | `ip a` до netplan apply |
| 03 | `03_netplan_yaml.png` | `nano /etc/netplan/00-installer-config.yaml` |
| 04 | `04_ip_a_after.png` | `ip a` после netplan apply |
| 05 | `05_ping_yaru_server.png` | `ping -c 5 ya.ru` с gateway |
| 06 | `06_desktop_ip_manual.png` | Статический IP на Desktop1 |
| 07 | `07_ping_gateway_from_desktop.png` | `ping 192.168.N.1` с Desktop1 |
| 08 | `08_sysctl_ipforward.png` | `nano /etc/sysctl.conf` (ip_forward=1) |
| 09 | `09_iptables_persistent_dialog.png` | Диалог при установке |
| 10 | `10_iptables_rules.png` | `iptables -t nat -L -n -v` |
| 11 | `11_dhcp_interfaces.png` | `nano /etc/default/isc-dhcp-server` |
| 12 | `12_dhcpd_conf.png` | `nano /etc/dhcp/dhcpd.conf` |
| 13 | `13_dhcp_status.png` | `service isc-dhcp-server status` |
| 14 | `14_desktop_dhcp_ip.png` | Desktop1 получил IP от DHCP |
| 15 | `15_ping_yaru_desktop.png` | `ping ya.ru` с Desktop1 |
| 16 | `16_syslog_error.png` | `tail -50 /var/log/syslog` |

---

## Шаг 3 — Положи скриншоты в `img/`

Файлы должны называться **точно** как в таблице (без пробелов в именах, расширение `.png`).

Пример как быстро перенести скриншоты из Windows через шаредные папки VirtualBox:

```bash
# На госте (Windows PowerShell / терминал):
scp скриншоты/*.png user@192.168.N.1:/path/to/lab4/latex-report/img/
```

---

## Шаг 4 — Скомпилируй отчёт в Overleaf

1. Зазипуй всю папку `latex-report/` (вместе с `img/`)
2. Зайди на [overleaf.com](https://overleaf.com) → **New Project** → **Upload Project** → загрузи zip
3. В настройках проекта выбери компилятор **XeLaTeX**
4. Главный файл — `main.tex`
5. Нажми **Recompile**

> ⚠️ Без скриншотов PDF не соберётся — Overleaf выдаст ошибку `File not found`.

### Сборка локально (Linux / macOS):

```bash
cd latex-report
xelatex main.tex   # дважды для обновления оглавления
biber main
xelatex main.tex
xelatex main.tex
```

---

## Проблемы и решения

| Ошибка | Причина | Решение |
|---|---|---|
| `File 'img/NN_...' not found` | Отсутствуют скриншоты | Добавь файлы в `img/` |
| `Font not found` | Отсутствуют `.ttf` в `fonts/` | Добавь `times.ttf`, `timesbd.ttf`, `timesi.ttf`, `timesbi.ttf` |
| Неверные адреса `192.168.99.x` | Не изменён `cfgLabStudentN` | Поменяй номер в `config.tex` |
| `Underfull \hbox` в логах | Плохой перенос рядом с `\texttt{}` | Не критично, PDF соберётся |
