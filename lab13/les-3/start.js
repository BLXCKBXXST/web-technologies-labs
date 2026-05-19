async function start() {
    const cardBox = document.getElementById('character-card-box');
    const modalBox = document.getElementById('character-modal-box');

    try {
        const characters = await fetchCharacters();
        cardBox.innerHTML = getCharacterCards(characters);
        modalBox.innerHTML = getCharacterModals(characters);
    } catch (err) {
        cardBox.innerHTML = `
<div class="col-12">
    <div class="alert alert-danger" role="alert">
        Не удалось загрузить персонажей: ${err.message}.
        Попробуйте обновить страницу — API на бесплатном хостинге Render может холодно стартовать до 30 секунд.
    </div>
</div>`;
    }
}
