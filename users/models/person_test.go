package models_test

import (
	"testing"

	"github.com/barklan/sql_fiddling/users/models"

	sq "github.com/Masterminds/squirrel"
	_ "github.com/lib/pq"
)

func TestPerson(t *testing.T) {
	tx := dbx.MustBegin()
	tx.MustExec("INSERT INTO person (first_name, last_name, email)"+
		"VALUES ($1, $2, $3)", "Jason", "Moiron", "jmoiron@jmoiron.net")
	tx.MustExec("INSERT INTO person (first_name, last_name, email)"+
		"VALUES ($1, $2, $3)", "John", "Doe", "johndoeDNE@gmail.net")

	err := tx.Commit()
	if err != nil {
		panic("failed to commit transaction")
	}

	people := []models.Person{}

	statement, _, err := sq.Select("*").From("person").ToSql()
	if err != nil {
		panic("sql generation failed")
	}

	err = dbx.Select(&people, statement)
	if err != nil {
		panic("failed")
	}

	jason, _ := people[0], people[1]
	if jason.FirstName != "Jason" {
		t.Errorf("Got %v want %v", jason.FirstName, "Jason")
	}
}
