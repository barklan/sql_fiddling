BEGIN;

CREATE TABLE IF NOT EXISTS person(
    person_id serial PRIMARY KEY,
    first_name VARCHAR (50) NOT NULL,
    last_name VARCHAR (50) NOT NULL,
    email VARCHAR (300) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS place (
    country varchar (50),
    city varchar (50) NULL,
    telcode integer
);

COMMIT;
