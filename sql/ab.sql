create table if not EXISTS a (
    id INT,
    name VARCHAR(100)
);

create table if not EXISTS b (
    id INT,
    name varchar(100)
);

insert into a(id, name) values
(1, 'Avery-un1'),
(1, 'Audrey-un1'),
(1, 'Bill-un1'),
(1, 'John-un1');

insert into b(id, name) values
(1, 'Aaaaa-un2'),
(1, 'Bernard-un2'),
(0, 'Kenneth-un2');
