select
    author,
    min(price) as Минимальная_цена,
    max(price) as Максимальная_цена,
    avg(price) as Средняя_цена
from book
group by author;
