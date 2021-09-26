#!/usr/bin/env bash

set -e

docker run -v `pwd`/db/migrations:/migrations --network host migrate/migrate \
-database postgres://postgres:postgres@localhost:5432/app?sslmode=disable -path /migrations "${@}"
