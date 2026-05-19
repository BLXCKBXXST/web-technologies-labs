# Практическая работа №13
**Погружение в разработку на JavaScript**

JS-практика по методичке: четыре последовательных урока — от базовых конструкций языка до публикации SPA-сайта на собственном хостинге. Главный артефакт — одностраничный сайт-каталог супергероев Marvel, который грузит данные с публичного API и рендерит карточки и модалки на Bootstrap 5.

---

## 🛠️ Среда

| Что | Где |
|---|---|
| Node.js 18+ | [nodejs.org](https://nodejs.org) — запуск консольных задач [les-1/](les-1/) и [les-2/](les-2/) |
| Браузер | Chrome/Firefox/Safari — запуск сайта [les-3/](les-3/) |
| CSS-фреймворк | [Bootstrap 5.0.1](https://getbootstrap.com/) (подключён через jsDelivr CDN) |
| API персонажей | `https://jsfree-les-3-api.onrender.com/characters` — 19 персонажей Marvel, JSON |
| Хостинг | домашний сервер `server34.netcraze.club` + reverse-proxy [Caddy](https://caddyserver.com/) |
| Локальный HTTP-сервер | `python3 -m http.server` (для проверки `fetch` в обход CORS на `file://`) |

---

## 📋 Задания

Согласно [методичке](Методичка%20(lab13).pdf), четыре урока:

1. **les-1. Базовые понятия.** Переменные, вывод в консоль. Две задачи: имя+бонусный баланс пользователя; начисление и «сгорание» баллов за 7 дней.
2. **les-2. Основы JavaScript.** Массивы и циклы. Две задачи: вывод переписки в чате; поиск по тексту сообщений через `String.prototype.includes`.
3. **les-3. Разработка сайта.** Сайт-каталог героев Marvel. Реализованы функции `fetchCharacters()`, `getCharacterCards()`, `getCharacterModals()`, `getCharacterCard()`, `getCharacterModal()` в [les-3/index.js](les-3/index.js); оркестрация в [les-3/start.js](les-3/start.js); вёрстка-каркас в [les-3/index.html](les-3/index.html).
4. **les-4. Доработка проекта.** Публикация сайта на публичном хостинге. Деплой автоматизирован bash-скриптом в репозитории `home-server` — добавляет в общий `docker-compose.yml` контейнер `nginx:alpine` с примонтированной директорией `les-3/`, дописывает поддомен в `Caddyfile` и перезагружает Caddy. Caddy сам выпускает TLS-сертификат Let's~Encrypt при первом запросе.

---

## 📁 Структура папки

```
lab13/
├── README.md                       ← этот файл
├── Методичка (lab13).pdf           ← задание преподавателя
│
├── les-1/                          ← консольные задачи (Node.js)
│   ├── task1.js                    ← пользователь + бонусный баланс
│   └── task2.js                    ← баланс через 7 дней
│
├── les-2/                          ← консольные задачи (Node.js)
│   ├── task1.js                    ← вывод переписки
│   └── task2.js                    ← поиск по includes
│
├── les-3/                          ← сайт «Персонажи Marvel»
│   ├── index.html                  ← каркас с Bootstrap и спиннером-плейсхолдером
│   ├── index.js                    ← fetch + рендер карточек и модалок
│   └── start.js                    ← start(): запрос API, заполнение DOM
│
└── latex-report/                   ← LaTeX-отчёт для Overleaf
    ├── main.tex, config.tex, parts/, fonts/, screenshots/, img/
    └── lab13_latex_report.pdf      ← скомпилированный отчёт (появится после компиляции)
```

---

## 🚀 Запуск

### Консольные задачи (les-1, les-2)

```bash
cd les-1 && node task1.js && node task2.js
cd ../les-2 && node task1.js && node task2.js
```

Ожидаемый вывод (фрагмент):

```
Пользователь my name
Баланс 1000
Баланс через 7 дней: 1179
Друг: Пойдем гулять в парк?
Вы: Кажется, дождь собирается. Лучше пойдем в кино!
…
Поиск по слову: "кино"
— Кажется, дождь собирается. Лучше пойдем в кино!
— Встречаемся через час у кинотеатра.
```

### Сайт «Персонажи Marvel» (les-3)

Открыть `index.html` напрямую в браузере **нельзя**: при загрузке по `file://` браузер блокирует `fetch` к стороннему API. Нужен локальный HTTP-сервер:

```bash
cd les-3 && python3 -m http.server 8000
# открыть http://localhost:8000
```

API на бесплатном тарифе Render может «холодно» стартовать до 30 секунд — при первом запросе ожидаемо появляется спиннер.

---

## 🌐 Хостинг

Развёрнутая версия: **<https://marvel.server34.netcraze.club>**

Деплой делается скриптом в соседнем репозитории `home-server`:

```bash
# на самом домашнем сервере, после первичной установки Caddy
bash ~/home-server/scripts/51-deploy-marvel-site.sh
```

Скрипт идемпотентный: rsync исходников в `/opt/stack/marvel/site`, добавляет (если ещё нет) сервис `marvel: nginx:alpine` в общий `/opt/stack/docker-compose.yml`, дописывает блок поддомена в `/opt/stack/caddy/Caddyfile` и перезагружает контейнер Caddy. TLS-сертификат выпускается автоматически Let's~Encrypt при первом обращении.

---

## 📤 Формат сдачи

PDF-отчёт (скомпилированный из `latex-report/`) + ссылка на развёрнутый сайт — загружаются в курс.

---

## 📦 LaTeX-отчёт

- **[📦 Скачать latex-report.zip](https://github.com/BLXCKBXXST/web-technologies-labs/releases/download/overleaf-zips/lab13_overleaf.zip)** — каркас для импорта в Overleaf
- **[📄 Скачать готовый PDF](https://github.com/BLXCKBXXST/web-technologies-labs/raw/main/lab13/latex-report/lab13_latex_report.pdf)** *(появится после первой компиляции)*
