#!/bin/bash

echo "========================"
echo "= Apply black to files ="
echo "========================"

cd /github/workspace/

run_black_on_oldest_files() {
    ignore_files_regex=`echo $INPUT_IGNORE_FILES_REGEX | sed 's/ *, */|/g'`

    git ls-tree -r --name-only HEAD | while read filename; do
        if [ ${filename: -3} == ".py" ] && ! [[ $filename =~ $ignore_files_regex ]]
        then
            black --check $filename --quiet
            if [ $? -eq 1 ]
            then
                let counter++
                black $filename --quiet
                echo $filename
                if [ "$counter" -ge "$INPUT_NUMBER_OF_FILES" ]
                then
                    break
                fi
            fi
        fi
    done
}

modified_files=`run_black_on_oldest_files`

modified_file_names=`echo $modified_files | sed $'s/ /, /g'`
echo "::set-output name=modified_file_names::$modified_file_names"

number_of_modified_files=`echo $modified_files | wc -w`
echo "::set-output name=number_of_modified_files::$number_of_modified_files"
