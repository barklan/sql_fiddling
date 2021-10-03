SELECT
    round(min(price), 2) as Минимальная_цена,
    round(max(price), 2) as Максимальная_цена,
    round(avg(price), 2) as Средняя_цена
FROM book;
