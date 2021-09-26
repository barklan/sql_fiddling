#!/usr/bin/env bash

set -e

export MAX_LINE_LENGTH="${MAX_LINE_LENGTH:-90}"
export FILENAME_EXT_TO_LINT="${FILENAME_EXT_TO_LINT:-go}"


find . -maxdepth 10 -type f -path ./vendor -prune -name "*.${FILENAME_EXT_TO_LINT}" -print0 | while IFS= read -r -d $'\0' file; do
    report="$(wc -L < $file)"
    longest_line=$(wc -L < $file | awk '{print $1;}')

    if [ "${longest_line}" -gt "${MAX_LINE_LENGTH}" ]
    then
        echo ".${FILENAME_EXT_TO_LINT} files with lines longer than ${MAX_LINE_LENGTH} characters are not accepted."
        echo $file
        echo "Longest line: ${longest_line}"
        exit 1
    fi
done
