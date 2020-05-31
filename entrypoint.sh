#!/bin/bash

echo "========================"
echo "= Apply black to files ="
echo "========================"

cd /github/workspace/

run_black_on_oldest_files() {
    ignore_files_regex=$(echo "$INPUT_IGNORE_FILES_REGEX" | tr "," "\n" | xargs -I {} echo '":!:{}"' | tr '"' "'")
    filenames=$(
        echo "$ignore_files_regex" | xargs git ls-files '*.py' |
        while read filename; do
            echo "$(git log -1 --format="%ai" -- $filename) $filename";
        done |
        sort |
        cut -d " " -f4
    )

    echo "$filenames" | while read filename; do
        black --check "$filename" --quiet
        if [ $? -eq 1 ]
        then
            counter=$(( counter + 1 ))
            black "$filename" --quiet
            echo "$filename"
            if [ "$counter" -ge "$INPUT_NUMBER_OF_FILES" ]
            then
                break
            fi
        fi
    done
}

modified_files=$(run_black_on_oldest_files)

modified_file_names=$(echo $modified_files | sed $'s/ /, /g')
echo "::set-output name=modified_file_names::$modified_file_names"

echo "Applied black to $modified_file_names"

number_of_modified_files=$(echo $modified_files | wc -w)
echo "::set-output name=number_of_modified_files::$number_of_modified_files"
