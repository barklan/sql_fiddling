#!/usr/bin/env bash

# set -x
set -e

export LINT_IN_CI_CD="${LINT_IN_CI_CD:-false}"

# to rebuild linter just run
# docker image rm linter
export DOCKER_BUILDKIT=1
docker inspect "linter" > /dev/null 2>&1 || docker build -t linter -f dockerfiles/linter.dockerfile .


if grep -Er '\bfixme\b' --exclude-dir=.venv *; then
    exit 1
fi

# * Git

if [ "${LINT_IN_CI_CD}" == 'true' ]; then
    BRANCH_NAME="${CI_COMMIT_REF_NAME}"
else
    BRANCH_NAME="$(git branch --show-current)"
fi

# if echo $BRANCH_NAME | grep -Eq "^ch[1-9]{1}[0-9]*$"; then
    # echo "Branch name matches clubhouse story format."
# else
    # echo "Branch name does not match clubhouse story format."
    # exit 1
# fi

# https://www.conventionalcommits.org/en/v1.0.0/
if [ "${LINT_IN_CI_CD}" == 'true' ]; then
    git fetch
    # todo
    # cz check --rev-range origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME..origin/$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME
else
    if [ "${BRANCH_NAME}" == 'main' ]; then
        echo "Warning! You are working on main branch!"
    else
        docker run --rm -v `pwd`:/workdir -w /workdir linter cz check --rev-range main..$BRANCH_NAME
    fi
fi

git diff --check

# * Generic checks

docker run --rm -v `pwd`:/workdir -w /workdir linter codespell . -I ./scripts/lint/codespell_allow.txt --skip="
.mypy_cache,.git,.venv,.hypothesis,vendor,.cache"

# Run `pre-commit autoupdate` to update hooks
mkdir -p ./.cache/pre-commit
docker run --rm -v `pwd`:/workdir -v `pwd`/.cache/pre-commit:/.cache/pre-commit \
-w /workdir -e PRE_COMMIT_HOME=/.cache/pre-commit linter pre-commit run --all-files --config /workdir/scripts/lint/.pre-commit-config.yaml

if [ "${LINT_IN_CI_CD}" == 'true' ]; then
    curl -sSfL https://raw.githubusercontent.com/dotenv-linter/dotenv-linter/master/install.sh | sh -s
    ./bin/dotenv-linter --recursive
else
    docker run --rm -v `pwd`:/app -w /app dotenvlinter/dotenv-linter fix --recursive
    docker run --rm -v `pwd`:/app -w /app dotenvlinter/dotenv-linter --recursive
fi


if [ "${LINT_IN_CI_CD}" == 'true' ]; then
    jscpd --threshold 2 --ignore "**/.venv/**" .
else
    # use --format "go" to lint only golang files
    docker run --rm -v `pwd`:/workdir -w /workdir linter jscpd --threshold 2 --ignore "
    **/.venv/**,**/vendor/**,**/.cache/**" .
fi

bash ./scripts/lint/lint_support_files.sh

# * App specific checks
# cd backend/app/app
# bash -c "cd .. && poetry check"
# if [ ! -f "../poetry.lock" ]; then
    # echo "No poetry.lock file found, please restore it from previous revision or create a new one."
    # exit 1
# fi

# MAX_LINE_LENGTH=120 bash ../../../scripts/lint.sh
# bash ../../../scripts/files_length.sh
# python ../../../scripts/validate_filenames.py
# bandit --configfile ../../../scripts/bandit.yaml -r .
# mypy --config-file="../../../mypy.ini" .
# cd ../../..

# * Go app specific checks
# MAX_ACCEPTED_LINES=300 FILENAME_EXT_TO_LINT=go bash ./scripts/lint/files_length.sh

# * SQL
bash ./scripts/lint/lint.sql.sh
MAX_ACCEPTED_LINES=150 FILENAME_EXT_TO_LINT=sql bash ./scripts/lint/files_length.sh

C='\033[1;32m' # Color
NC='\033[0m' # No Color
echo -e "${C}Linting done. All good.${NC}"
