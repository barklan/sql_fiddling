SELECT
    author,
    round(sum(price * amount), 2) as Стоимость,
    round(sum(price * amount * 0.18 / 1.18), 2) as НДС,
    round(sum(price * amount / 1.18), 2) as Стоимость_без_НДС
FROM book
GROUP BY author;
