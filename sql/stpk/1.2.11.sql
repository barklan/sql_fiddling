SELECT
    title,
    author
FROM
    book
WHERE
    title LIKE '_% _%' AND (author LIKE '% С.%.' OR author LIKE '% %.С.')
ORDER BY
    title
