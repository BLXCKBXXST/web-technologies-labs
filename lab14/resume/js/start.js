// start.js — оркестрация лабораторной №14: сборка резюме и навешивание событий.
// Функция start() вызывается из index.html по событию DOMContentLoaded.

function start() {
    // 1. Отрисовать резюме из конфига; снять снимок дефолтных значений
    //    (для кнопки «Сбросить») и наложить сверху сохранённые правки.
    renderResume(window.RESUME_DATA);
    const defaults = collectFields();
    applyFields(loadResumeData());

    // Предупредить, если localStorage недоступен (приватный режим браузера).
    if (!isStorageAvailable()) {
        const warning = document.getElementById('storage-warning');
        if (warning) {
            warning.hidden = false;
        }
    }

    const avatarHost = document.getElementById('avatar-host');
    const avatarImg = document.getElementById('avatar-img');
    const photoInput = document.getElementById('photo-input');

    let dirty = false;

    // Сохранить тексты и фото в localStorage (только если что-то менялось).
    function flushSave() {
        if (!dirty) {
            return;
        }
        saveResumeData({ fields: collectFields(), avatar: collectAvatar() });
        dirty = false;
    }

    // 2. Поведение редактируемых полей: анимация, сохранение, ввод.
    document.querySelectorAll('.editable').forEach(function (field) {
        // Вход в режим правки — анимация-подсветка.
        field.addEventListener('focus', function () {
            triggerAnimation(field, 'is-editing');
        });
        // Любой ввод помечает, что есть несохранённые изменения.
        field.addEventListener('input', function () {
            dirty = true;
            // Убираем служебный <br>, который contenteditable оставляет в
            // опустевшем поле, — иначе не сработает placeholder (:empty).
            if (field.textContent.trim() === '') {
                field.innerHTML = '';
            }
        });
        // Уход из поля — сохранение и анимация «сохранено».
        field.addEventListener('blur', function () {
            flushSave();
            triggerAnimation(field, 'is-saved');
        });
        // В однострочном поле Enter завершает правку, а не вставляет перенос.
        field.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' && !field.classList.contains('editable--multiline')) {
                event.preventDefault();
                field.blur();
            }
        });
        // Вставка — только простым текстом, без чужой разметки и стилей.
        field.addEventListener('paste', function (event) {
            event.preventDefault();
            const text = event.clipboardData.getData('text/plain');
            document.execCommand('insertText', false, text);
        });
    });

    // 3. Material Wave — одно делегированное событие на весь документ.
    document.addEventListener('pointerdown', function (event) {
        const host = event.target.closest ? event.target.closest('.ripple-host') : null;
        if (host) {
            createRipple(event, host);
        }
    });

    // 4. Загрузка фотографии: клик (или Enter/Пробел) по аватару открывает выбор файла.
    avatarHost.addEventListener('click', function () {
        photoInput.click();
    });
    avatarHost.addEventListener('keydown', function (event) {
        if (event.key === 'Enter' || event.key === ' ') {
            event.preventDefault();
            photoInput.click();
        }
    });
    photoInput.addEventListener('change', function () {
        readPhoto(photoInput.files[0], function (dataUrl) {
            avatarImg.src = dataUrl;
            triggerAnimation(avatarHost, 'is-editing');
            dirty = true;
            flushSave();
        });
        photoInput.value = '';
    });

    // 5. Кнопка «Скачать PDF» — печать средствами браузера («Сохранить как PDF»).
    document.getElementById('btn-pdf').addEventListener('click', function () {
        // Зафиксировать правку активного поля и сохранить состояние.
        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            document.activeElement.blur();
        }
        flushSave();
        // Имя из резюме станет именем PDF-файла в диалоге печати.
        const previousTitle = document.title;
        document.title = buildPrintFilename(collectFields().name);
        window.addEventListener('afterprint', function restore() {
            document.title = previousTitle;
            window.removeEventListener('afterprint', restore);
        });
        window.print();
    });

    // 6. Кнопка «Сбросить» — вернуть выдуманный шаблон, стереть правки и фото.
    document.getElementById('btn-reset').addEventListener('click', function () {
        if (!window.confirm('Сбросить все правки и вернуть исходный шаблон?')) {
            return;
        }
        try {
            localStorage.removeItem(STORAGE_KEY);
        } catch (e) {
            // Хранилище недоступно — стирать нечего.
        }
        applyFields({ fields: defaults });
        avatarImg.src = window.RESUME_DATA.avatar;
        dirty = false;
    });

    // 7. Страховка: сохранить правки при закрытии или перезагрузке вкладки.
    window.addEventListener('beforeunload', flushSave);
}
