package main

import (
	"fmt"
	"log"

	usermodels "github.com/barklan/sql_fiddling/users/models"

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

	people := []usermodels.Person{}
	db.Select(&people, "select * from person")
	jason, john := people[0], people[1]
	fmt.Printf("%#v\n%#v", jason, john)

	fmt.Println(faker.Email())
}
