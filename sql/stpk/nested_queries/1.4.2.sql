SELECT
    author,
    title,
    price
FROM book
WHERE
    price - (SELECT min(price) FROM book) <= 150
ORDER BY price;
