#!/usr/bin/env bash

set -e

docker run -v `pwd`/db/migrations:/migrations --network host migrate/migrate \
create -ext sql -dir /migrations -seq "${@}"
