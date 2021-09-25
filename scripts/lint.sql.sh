#!/usr/bin/env bash

set -e

docker inspect "sqlfluff" > /dev/null 2>&1 || docker build -t sqlfluff -f dockerfiles/sqlfluff.dockerfile dockerfiles

docker run --rm -it -v `pwd`:/workdir -w /workdir sqlfluff sqlfluff lint
