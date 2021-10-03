SELECT
    author,
    sum(price * amount) as Стоимость
FROM
    book
WHERE title NOT IN ('Идиот', 'Белая гвардия')
GROUP BY author
HAVING sum(price * amount) > 5000
ORDER by Стоимость desc;
