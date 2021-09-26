#!/usr/bin/env bash

# Set an alias r='./run.sh'

set -eo pipefail

DC="${DC:-exec}"

# If we're running in CI we need to disable TTY allocation for docker-compose
# commands that enable it by default, such as exec and run.
TTY=""
if [[ ! -t 1 ]]; then
  TTY="-T"
fi

# -----------------------------------------------------------------------------
# Helper functions start with _ and aren't listed in this script's help menu.
# -----------------------------------------------------------------------------

function _dc {
  export DOCKER_BUILDKIT=1
  docker-compose ${TTY} "${@}"
}

function _dc_quiet {
  docker-compose --log-level ERROR ${TTY} "${@}"
}

function _build_run_down {
  docker-compose build
  docker-compose run ${TTY} "${@}"
  docker-compose down
}

function _use_env {
  sort -u environment/.env | grep -v '^$\|^\s*\#' > './environment/.env.tempfile'
  export $(cat environment/.env.tempfile | xargs)
}

# -----------------------------------------------------------------------------
# * Local functions.

function up {  # Run the stack without extra.
  _dc down --remove-orphans && _dc build --parallel && _dc up "${@}"
}

function up:e {  # Run the stack.
  _dc --profile extra down --remove-orphans && _dc --profile extra build --parallel && _dc --profile extra up "${@}"
}

function up:c {  # Run the stack with clean volumes without extra.
  _dc down -v --remove-orphans && _dc build --parallel && _dc up "${@}"
}

function up:ce {  # Run the stack with clean volumes.
  _dc --profile extra down -v --remove-orphans && _dc --profile extra build --parallel &&	_dc --profile extra up "${@}"
}

function down {  # Stop stack.
  _dc down "${@}"
}

function down:c {  # Stop stack removing docker volumes.
  _dc down -v --remove-orphans
  # _dc -f docker-stack.yml down -v --remove-orphans
}

function db:backup {  # Backup database internally. Beware of -c flag.
  echo "Making database backup..."
  _dc_quiet exec db bash -c "pg_dump -U postgres app > dump_db_app.sql"
  echo "Database backup successful."
}

function db:restore {
  echo "Restoring database backup..."
  _dc_quiet exec db bash -c "dropdb -U postgres app && createdb -U postgres -T template0 app"
  _dc_quiet exec db bash -c "psql -U postgres --quiet --set ON_ERROR_STOP=on app < dump_db_app.sql"
  echo "Database restored successfully."
}

# function test {
#   # Runs tests on running docker containers.
#   # Can add arbitrary arguments to it - they will be passed to pytest
#   # -x for example to exit on first fail
#   db:backup
#   _dc_quiet exec backend bash /app/scripts/test.sh -n4 "${@}" || bash -c "./run.sh db:restore && exit 1"
#   db:restore
# }

function lint {
  bash ./scripts/lint/lint.all.sh
}

function lint:sql {
  bash ./scripts/lint/lint.sql.sh
}

function psql {  # Connect to running database container and enter psql command.
  _dc exec db psql -U postgres -d app
}

function sql {
  cat "./sql/$1.sql" | _dc exec -T db psql -U postgres -d app | tee psql_output.tempfile
}

function sql:csv {
  cat "./sql/$1.sql" | _dc exec -T db psql -U postgres -d app --csv | tee ./data/output/psql_output.csv
}

function s {
  sql "${@}"
}

function ms {
  # todo modify this to connect to remote database
  # -S server, -U user, -P password, -d database name
  _use_env
  _dc exec ms /opt/mssql-tools/bin/sqlcmd -S $MS_SQL_SERVER_HOST -U $MS_SQL_SERVER_USER -P $MS_SQL_SERVER_PASSWORD -d $MS_SQL_SERVER_DB -i "/sql/$1.sql"
}

function ms:wip {
  _dc exec ms /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "yourStrong(!)Password"
}

function db:dump {  # Make database dump.
  _dc_quiet exec db pg_dump -U postgres app > dump.sql
}

function db:dump:r {  # Restore database from dump.
  echo "Restoring database backup..."
  _dc_quiet exec db bash -c "dropdb -U postgres app && createdb -U postgres -T template0 app"
  _dc_quiet exec -T db psql -U postgres --quiet --set ON_ERROR_STOP=on app < dump.sql
  echo "Database restored successfully."
}

function db:makemigrations {
  bash ./scripts/local/makemigrations.sh "${@}"
}

function db:migrate {
  bash ./scripts/local/migrate.sh "${@}"
}

function back {  # Run any command you want in the running backend container.
  _dc exec backend "${@}"
}

function back:bash {  # Start a bash session in the backend container.
  cmd bash "${@}"
}

function clean:tempfiles {
  rm -f tempfile && find . -name "*.tempfile" -type f | xargs rm -f
}

# -----------------------------------------------------------------------------
# * Non-local functions


# -----------------------------------------------------------------------------
# * Staging


# -----------------------------------------------------------------------------
# * Git & GitLab

function git:grep {
  git grep $1 $(git rev-list --all)
}

# -----------------------------------------------------------------------------

function help {
  printf "%s <task> [args]\n\nTasks:\n" "${0}"

  compgen -A function | grep -v "^_" | cat -n

  printf "\nExtended help:\n  letter 'c' in commands stands for clean.\n"
}

TIMEFORMAT=$'\nTask completed in %3lR'
time "${@:-help}"
