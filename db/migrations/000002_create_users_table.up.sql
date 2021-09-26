CREATE TABLE IF NOT EXISTS users(
    user_id serial PRIMARY KEY,
    username VARCHAR (50) UNIQUE NOT NULL,
    password_text VARCHAR (50) NOT NULL,
    email VARCHAR (300) UNIQUE NOT NULL
);
