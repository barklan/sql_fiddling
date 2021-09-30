package models_test

import (
	"os"
	"testing"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
	log "github.com/sirupsen/logrus"

	"github.com/barklan/sql_fiddling/core"
)

var dbx *sqlx.DB // nolint:gochecknoglobals

func TestMain(m *testing.M) {
	db, pool, resource := core.PrepareTestDB()
	dbx = sqlx.NewDb(db, "postgres")

	// Run tests
	code := m.Run()

	// You can't defer this because os.Exit doesn't care for defer
	if err := pool.Purge(resource); err != nil {
		log.Fatalf("Could not purge resource: %s", err)
	}

	os.Exit(code)
}
