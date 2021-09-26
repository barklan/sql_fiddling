#!/usr/bin/env bash

set -e

export MAX_ACCEPTED_LINES="${MAX_ACCEPTED_LINES:-300}"
export FILENAME_EXT_TO_LINT="${FILENAME_EXT_TO_LINT:-go}"


find . -maxdepth 10 -type f -path ./vendor -prune -name "*.${FILENAME_EXT_TO_LINT}" -print0 | while IFS= read -r -d $'\0' file; do
    number_of_lines=`wc --lines < $file`
    if [ "${number_of_lines}" -gt "${MAX_ACCEPTED_LINES}" ]
    then
        echo ".${FILENAME_EXT_TO_LINT} files with more than ${MAX_ACCEPTED_LINES} lines are not accepted."
        echo $file
        echo "Lines: ${number_of_lines}"
        exit 1
    fi
done
