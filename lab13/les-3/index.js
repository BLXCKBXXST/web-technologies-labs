// Marvel API: 19 персонажей, поля id / name (рус.) / nameor (англ.) / description / thumbnail / comics[].
const API_URL = 'https://jsfree-les-3-api.onrender.com/characters';

// Картинки персонажей раздаются по HTTP — на HTTPS-странице получили бы mixed-content.
function toHttps(url) {
    return typeof url === 'string' ? url.replace(/^http:\/\//i, 'https://') : url;
}

function escapeHtml(value) {
    return String(value ?? '')
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
}

function truncate(text, limit) {
    const str = String(text ?? '');
    return str.length > limit ? str.slice(0, limit).trimEnd() + '…' : str;
}

async function fetchCharacters() {
    const response = await fetch(API_URL);
    if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
    }
    return await response.json();
}

function getCharacterCard(character) {
    const modalId = `character-modal-${character.id}`;
    const thumb = escapeHtml(toHttps(character.thumbnail));
    const name = escapeHtml(character.name);
    const nameor = escapeHtml(character.nameor);
    const short = escapeHtml(truncate(character.description, 160));

    return `
<div class="col-12 col-md-6 col-lg-4 mb-4">
    <div class="card h-100 shadow-sm">
        <img src="${thumb}" class="card-img-top" alt="${name}" loading="lazy"
             style="height: 320px; object-fit: cover; object-position: top;">
        <div class="card-body d-flex flex-column">
            <h5 class="card-title mb-1">${name}</h5>
            <p class="text-muted small mb-2">${nameor}</p>
            <p class="card-text flex-grow-1">${short}</p>
            <button type="button" class="btn btn-danger mt-2"
                    data-bs-toggle="modal" data-bs-target="#${modalId}">
                Подробнее
            </button>
        </div>
    </div>
</div>`;
}

function getCharacterCards(characters) {
    return characters.map(getCharacterCard).join('');
}

function getCharacterModal(character) {
    const modalId = `character-modal-${character.id}`;
    const thumb = escapeHtml(toHttps(character.thumbnail));
    const name = escapeHtml(character.name);
    const nameor = escapeHtml(character.nameor);
    const description = escapeHtml(character.description) || '<em>Описание отсутствует.</em>';

    const comics = Array.isArray(character.comics) ? character.comics.slice(0, 10) : [];
    const comicsList = comics.length
        ? `<ul class="mb-0">${comics.map(c => `<li>${escapeHtml(c.name)}</li>`).join('')}</ul>`
        : '<p class="text-muted mb-0">Список комиксов недоступен.</p>';

    return `
<div class="modal fade" id="${modalId}" tabindex="-1" aria-labelledby="${modalId}-label" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="${modalId}-label">${name} <small class="text-muted">${nameor}</small></h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Закрыть"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-4 mb-3 mb-md-0">
                        <img src="${thumb}" alt="${name}" class="img-fluid rounded">
                    </div>
                    <div class="col-md-8">
                        <p>${description}</p>
                        <h6 class="mt-3">Появления в комиксах:</h6>
                        ${comicsList}
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Закрыть</button>
            </div>
        </div>
    </div>
</div>`;
}

function getCharacterModals(characters) {
    return characters.map(getCharacterModal).join('');
}
