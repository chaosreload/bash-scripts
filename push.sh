#!/bin/bash

if [ $# -ne 1 ]
then
    echo "Usage: $0 COMMIT_MESSAGE"
    exit 1
fi

curr_dir=`dirname $0`
cd ${curr_dir}

echo "Changed file list:"
git status -s
git add . --all
git commit -m "$1"
echo "Push to origin(YES/no)"
read answer
if [ -z $answer ]; then
    answer="yes"
fi
case $answer in
    [Yy]|[Yy][Ee][Ss])
        ;;
    *)
        echo "Skip push."
        exit 0
        ;;
esac

git push origin
