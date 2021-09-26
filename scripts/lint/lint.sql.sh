#!/usr/bin/env bash

set -e

docker run --rm -it -v `pwd`:/workdir -w /workdir linter bash -c "
sqlfluff fix --force --rules L003,L009,L010 && sqlfluff lint --ignore parsing"
