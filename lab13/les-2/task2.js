const messages = [
    'Пойдем гулять в парк?',
    'Кажется, дождь собирается. Лучше пойдем в кино!',
    'Давай, сегодня как раз вышел новый фильм.',
    'Встречаемся через час у кинотеатра.',
];

const searchText = 'кино';

console.log('Поиск по слову: "' + searchText + '"');
const found = messages.filter(msg => msg.includes(searchText));

if (found.length === 0) {
    console.log('Совпадений не найдено.');
} else {
    found.forEach(msg => console.log('— ' + msg));
}
