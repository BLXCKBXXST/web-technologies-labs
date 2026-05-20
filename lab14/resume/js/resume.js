// resume.js — чистые функции лабораторной №14: рендер резюме из RESUME_DATA,
// работа с localStorage, загрузка фотографии, эффект Material Wave, анимации.
// Оркестрация (навешивание событий) вынесена в start.js.

// Ключ, под которым правки пользователя хранятся в localStorage браузера.
const STORAGE_KEY = 'lab14-resume';

// Иконки контактов — статичные SVG, currentColor подхватывает цвет текста.
const CONTACT_ICONS = {
    email: '<svg viewBox="0 0 24 24" focusable="false"><path d="M3 6h18v12H3z" fill="none" stroke="currentColor" stroke-width="2"/><path d="m3 7 9 6 9-6" fill="none" stroke="currentColor" stroke-width="2"/></svg>',
    phone: '<svg viewBox="0 0 24 24" focusable="false"><path d="M6 3h4l2 5-3 2a12 12 0 0 0 6 6l2-3 5 2v4a2 2 0 0 1-2 2A17 17 0 0 1 4 5a2 2 0 0 1 2-2z" fill="currentColor"/></svg>',
    location: '<svg viewBox="0 0 24 24" focusable="false"><path d="M12 2a7 7 0 0 0-7 7c0 5 7 13 7 13s7-8 7-13a7 7 0 0 0-7-7z" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="9" r="2.5" fill="currentColor"/></svg>',
    link: '<svg viewBox="0 0 24 24" focusable="false"><path d="M10 14a4 4 0 0 0 5.66 0l3-3a4 4 0 1 0-5.66-5.66l-1.5 1.5M14 10a4 4 0 0 0-5.66 0l-3 3a4 4 0 1 0 5.66 5.66l1.5-1.5" fill="none" stroke="currentColor" stroke-width="2"/></svg>',
};

// Экранирование значений перед вставкой через innerHTML (защита от XSS).
function escapeHtml(value) {
    return String(value ?? '')
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
}

// ===== localStorage =======================================================

// Доступно ли хранилище (в приватном режиме браузера может быть запрещено).
function isStorageAvailable() {
    try {
        const probe = '__lab14_probe__';
        localStorage.setItem(probe, '1');
        localStorage.removeItem(probe);
        return true;
    } catch (e) {
        return false;
    }
}

// Чтение сохранённых правок. При любой ошибке — пустой объект (вернёмся к конфигу).
function loadResumeData() {
    try {
        const raw = localStorage.getItem(STORAGE_KEY);
        return raw ? JSON.parse(raw) : {};
    } catch (e) {
        return {};
    }
}

// Запись правок. Возвращает true при успехе, не выбрасывает исключений.
function saveResumeData(data) {
    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(data));
        return true;
    } catch (e) {
        return false;
    }
}

// ===== Сбор и применение полей ============================================

// Собрать текущие тексты всех редактируемых полей в объект { data-field: текст }.
function collectFields() {
    const fields = {};
    document.querySelectorAll('[data-field]').forEach(function (el) {
        fields[el.getAttribute('data-field')] = el.innerText.trim();
    });
    return fields;
}

// Вернуть фото как data-URL, если оно загружено пользователем, иначе ''.
function collectAvatar() {
    const img = document.getElementById('avatar-img');
    return img && img.src.indexOf('data:') === 0 ? img.src : '';
}

// Наложить сохранённые правки (тексты + фото) поверх отрисованного резюме.
// Текст пишется через textContent — никакой разметки, stored-XSS невозможен.
function applyFields(stored) {
    if (!stored || typeof stored !== 'object') {
        return;
    }
    const fields = stored.fields || {};
    document.querySelectorAll('[data-field]').forEach(function (el) {
        const key = el.getAttribute('data-field');
        if (Object.prototype.hasOwnProperty.call(fields, key)) {
            el.textContent = fields[key];
        }
    });
    if (stored.avatar) {
        const img = document.getElementById('avatar-img');
        if (img) {
            img.src = stored.avatar;
        }
    }
}

// ===== Загрузка фотографии ================================================

// Прочитать выбранный файл, уменьшить через canvas и вернуть data-URL в callback.
function readPhoto(file, callback) {
    if (!file || file.type.indexOf('image/') !== 0) {
        return;
    }
    const reader = new FileReader();
    reader.onload = function () {
        const img = new Image();
        img.onload = function () {
            // Ужимаем до 400 px по большей стороне — чтобы уложиться в квоту localStorage.
            const maxSide = 400;
            const scale = Math.min(1, maxSide / Math.max(img.width, img.height));
            const canvas = document.createElement('canvas');
            canvas.width = Math.round(img.width * scale);
            canvas.height = Math.round(img.height * scale);
            canvas.getContext('2d').drawImage(img, 0, 0, canvas.width, canvas.height);
            callback(canvas.toDataURL('image/jpeg', 0.85));
        };
        img.src = reader.result;
    };
    reader.readAsDataURL(file);
}

// ===== Анимации и Material Wave ===========================================

// Перезапустить одноразовую CSS-анимацию: снять оба класса-анимации (они
// конкурируют за свойство animation), форс-reflow, навесить нужный заново.
function triggerAnimation(el, className) {
    el.classList.remove('is-editing', 'is-saved');
    void el.offsetWidth;
    el.classList.add(className);
}

// Создать «волну» (ripple) в точке клика внутри элемента-хоста.
function createRipple(event, host) {
    const rect = host.getBoundingClientRect();
    const size = Math.max(rect.width, rect.height);
    const radius = size / 2;
    const x = event.clientX - rect.left - radius;
    const y = event.clientY - rect.top - radius;

    // Убираем предыдущую волну этого хоста, чтобы быстрые клики не копили спаны.
    const previous = host.querySelector(':scope > .ripple');
    if (previous) {
        previous.remove();
    }

    const ripple = document.createElement('span');
    ripple.className = 'ripple';
    ripple.style.width = size + 'px';
    ripple.style.height = size + 'px';
    ripple.style.left = x + 'px';
    ripple.style.top = y + 'px';
    ripple.addEventListener('animationend', function () {
        ripple.remove();
    }, { once: true });
    host.appendChild(ripple);
}

// ===== Печать =============================================================

// Имя файла для диалога «Сохранить как PDF» — берётся из текущего имени в резюме.
function buildPrintFilename(name) {
    const clean = String(name || '').trim();
    return 'Резюме — ' + (clean || 'без имени');
}

// ===== Рендер резюме ======================================================

// Собрать вёрстку резюме из объекта данных и вставить её в #resume-root.
function renderResume(data) {
    const root = document.getElementById('resume-root');

    const contactsHtml = data.contacts.map(function (contact, i) {
        const icon = CONTACT_ICONS[contact.type] || CONTACT_ICONS.link;
        return `
            <li class="contacts__item">
                <span class="contacts__icon" aria-hidden="true">${icon}</span>
                <span class="contacts__value editable" contenteditable="true"
                      data-field="contact-${i}" data-placeholder="—">${escapeHtml(contact.value)}</span>
            </li>`;
    }).join('');

    const skillsHtml = data.skills.map(function (skill, i) {
        return `
            <li class="skill editable" contenteditable="true"
                data-field="skill-${i}" data-placeholder="навык">${escapeHtml(skill)}</li>`;
    }).join('');

    const langsHtml = data.languages.map(function (lang, i) {
        return `
            <li class="lang">
                <span class="lang__name editable" contenteditable="true"
                      data-field="lang-${i}-name" data-placeholder="язык">${escapeHtml(lang.name)}</span>
                <span class="lang__level editable" contenteditable="true"
                      data-field="lang-${i}-level" data-placeholder="уровень">${escapeHtml(lang.level)}</span>
            </li>`;
    }).join('');

    const expHtml = data.experience.map(function (item, i) {
        return `
            <li class="entry ripple-host">
                <div class="entry__top">
                    <h3 class="entry__role editable" contenteditable="true"
                        data-field="exp-${i}-role" data-placeholder="должность">${escapeHtml(item.role)}</h3>
                    <span class="entry__period editable" contenteditable="true"
                          data-field="exp-${i}-period" data-placeholder="период">${escapeHtml(item.period)}</span>
                </div>
                <p class="entry__company editable" contenteditable="true"
                   data-field="exp-${i}-company" data-placeholder="компания">${escapeHtml(item.company)}</p>
                <p class="entry__details editable editable--multiline" contenteditable="true"
                   data-field="exp-${i}-details" data-placeholder="описание обязанностей">${escapeHtml(item.details)}</p>
            </li>`;
    }).join('');

    const eduHtml = data.education.map(function (item, i) {
        return `
            <li class="entry ripple-host">
                <div class="entry__top">
                    <h3 class="entry__role editable" contenteditable="true"
                        data-field="edu-${i}-degree" data-placeholder="квалификация">${escapeHtml(item.degree)}</h3>
                    <span class="entry__period editable" contenteditable="true"
                          data-field="edu-${i}-period" data-placeholder="период">${escapeHtml(item.period)}</span>
                </div>
                <p class="entry__company editable" contenteditable="true"
                   data-field="edu-${i}-place" data-placeholder="учебное заведение">${escapeHtml(item.place)}</p>
            </li>`;
    }).join('');

    root.innerHTML = `
<article class="resume" id="resume">
    <div class="resume__main">
        <header class="resume__head ripple-host">
            <h1 class="resume__name editable" contenteditable="true"
                data-field="name" data-placeholder="Имя Фамилия">${escapeHtml(data.name)}</h1>
            <p class="resume__title editable" contenteditable="true"
               data-field="title" data-placeholder="должность">${escapeHtml(data.title)}</p>
        </header>

        <section class="main-block ripple-host">
            <h2 class="block-title">Обо мне</h2>
            <p class="about editable editable--multiline" contenteditable="true"
               data-field="about" data-placeholder="Несколько слов о себе">${escapeHtml(data.about)}</p>
        </section>

        <section class="main-block ripple-host">
            <h2 class="block-title">Опыт работы</h2>
            <ul class="timeline">${expHtml}
            </ul>
        </section>

        <section class="main-block ripple-host">
            <h2 class="block-title">Образование</h2>
            <ul class="timeline">${eduHtml}
            </ul>
        </section>
    </div>

    <aside class="resume__side">
        <div class="resume__photo ripple-host" id="avatar-host"
             role="button" tabindex="0" aria-label="Загрузить фотографию">
            <img class="resume__photo-img" id="avatar-img"
                 src="${escapeHtml(data.avatar)}" alt="Фотография в резюме">
            <span class="resume__photo-overlay" aria-hidden="true">Загрузить фото</span>
        </div>

        <section class="side-block ripple-host">
            <h2 class="block-title block-title--light">Контакты</h2>
            <ul class="contacts">${contactsHtml}
            </ul>
        </section>

        <section class="side-block ripple-host">
            <h2 class="block-title block-title--light">Навыки</h2>
            <ul class="skills">${skillsHtml}
            </ul>
        </section>

        <section class="side-block ripple-host">
            <h2 class="block-title block-title--light">Языки</h2>
            <ul class="langs">${langsHtml}
            </ul>
        </section>
    </aside>
</article>`;
}
