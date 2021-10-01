SELECT
    title,
    author,
    amount,
    round(price * 0.70, 2) AS new_price FROM book;
