package main

import (
	"fmt"
	"log"

	usermodels "sqlfiddle/users/models"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"

	"github.com/bxcodec/faker/v3"
)

func main() {
	// this Pings the database trying to connect
	// use sqlx.Open() for sql.Open() semantics
	// todo use environment variables here
	db, err := sqlx.Connect("postgres", "user=postgres dbname=app sslmode=disable")
	if err != nil {
		log.Fatalln(err)
	}

	tx := db.MustBegin()
	tx.MustExec("INSERT INTO person (first_name, last_name, email) VALUES ($1, $2, $3)", "Jason", "Moiron", "jmoiron@jmoiron.net")
	tx.MustExec("INSERT INTO person (first_name, last_name, email) VALUES ($1, $2, $3)", "John", "Doe", "johndoeDNE@gmail.net")
	tx.Commit()

	people := []usermodels.Person{}
	db.Select(&people, "select * from person")
	jason, john := people[0], people[1]
	fmt.Printf("%#v\n%#v", jason, john)

	fmt.Println(faker.Email())
}
