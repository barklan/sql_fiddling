SELECT
    round(avg(price), 2) as Средняя_цена,
    round(sum(price * amount), 2) as Стоимость
FROM book
WHERE amount BETWEEN 5 AND 14;
