#! /usr/bin/env bash

set -e

C='\033[1;33m' # Color
NC='\033[0m' # No Color


find . -type f -name "*.dockerfile" -print0 | while IFS= read -r -d $'\0' file; do
    echo -e "${C}Linting ${file}${NC}"
    docker run --rm -i -v `pwd`/scripts/lint:/lint -w /lint hadolint/hadolint < "${file}"
done


# todo
# find . -type f -name "*.sh" -print0 | while IFS= read -r -d $'\0' file; do
    # echo -e "${C}Linting ${file}${NC}"
    # docker run --rm -v "$PWD:/mnt" koalaman/shellcheck:stable "${file}"
# done
