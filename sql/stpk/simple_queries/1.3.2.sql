SELECT
    author as Автор,
    count(DISTINCT title) as Различных_книг,
    sum(amount) as Количество_экземпляров
FROM book
GROUP BY author
