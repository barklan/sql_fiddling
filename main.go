package main

import (
	"log"

	usermodels "github.com/barklan/sql_fiddling/users/models"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

func main() {
	// this Pings the database trying to connect
	// use sqlx.Open() for sql.Open() semantics
	db, err := sqlx.Connect("postgres", "user=postgres dbname=app sslmode=disable")
	// todo use environment variables here
	if err != nil {
		log.Fatalln(err)
	}

	people := []usermodels.Person{}

	err = db.Select(&people, "select * from person")
	if err != nil {
		panic(err)
	}
}
