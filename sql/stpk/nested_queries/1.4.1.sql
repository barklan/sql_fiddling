SELECT
    author,
    title,
    price
FROM book
WHERE price <= (
    SELECT avg(price) FROM book
)
ORDER BY price DESC;
