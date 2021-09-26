package models

import (
	"testing"

	_ "github.com/lib/pq"
)

func TestPerson(t *testing.T) {
	tx := dbx.MustBegin()
	tx.MustExec("INSERT INTO person (first_name, last_name, email) VALUES ($1, $2, $3)", "Jason", "Moiron", "jmoiron@jmoiron.net")
	tx.MustExec("INSERT INTO person (first_name, last_name, email) VALUES ($1, $2, $3)", "John", "Doe", "johndoeDNE@gmail.net")
	tx.Commit()

	people := []Person{}
	dbx.Select(&people, "select * from person")
	jason, _ := people[0], people[1]
	if jason.FirstName != "Jason" {
		t.Errorf("Got %v want %v", jason.FirstName, "Jason")
	}
}
