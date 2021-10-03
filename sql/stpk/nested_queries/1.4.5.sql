SELECT
    title,
    author,
    amount,
    ((SELECT max(amount) FROM book) - amount) as Заказ
FROM book
WHERE amount <> (
    SELECT max(amount) FROM book
);
