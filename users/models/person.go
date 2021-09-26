package models

import "database/sql"

type Person struct {
	PersonId  int            `db:"person_id"`
	FirstName string         `db:"first_name"`
	LastName  string         `db:"last_name"`
	Email     string         `db:"email"`
	Mood      sql.NullString `db:"mood"`
}
