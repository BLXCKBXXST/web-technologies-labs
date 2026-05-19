let bonusBalance = 1000;
const purchaseBonus = 50;
const dailyBurn = 3;
const days = 7;

// Первая покупка во вторник, дальше раз в два дня: вт, чт, сб, пн — 4 покупки за 7 дней.
const purchases = 4;

bonusBalance = bonusBalance + purchases * purchaseBonus - days * dailyBurn;

console.log('Баланс через ' + days + ' дней: ' + bonusBalance);
