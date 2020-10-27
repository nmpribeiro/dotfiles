#!/bin/bash
# STOP! Before going any further, think: are you going to regret the decision
# to write this script?
#     Deciding to write this in bash was not one of my better decisions.
#     -- https://twitter.com/alex_gaynor/status/369892494114164736

IFS="`printf "\n\t"`"
set -eu

remotes=""
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        -r|--remotes)
            remotes="$1"
            ;;
        *)
            echo "Usage: $0 [-r|--remotes]"
            echo "Deletes all merged branches."
            echo "Options:"
            echo "  -r, --remotes   Delete merged remote branches."
            exit 1
    esac
    shift
done

branches=( $(git branch $remotes --merged | egrep -v '(\*|master|develop)' | sed -e 's/  *//g') )

if [[ ${#branches[@]} -eq 0 ]]; then
    echo "No un-merged branches; nothing to do."
    exit 0
fi

git show -s --oneline "${branches[@]}"

echo
read -p "Delete these branches? " res
if [[ "$res" =~ "y" ]]; then
    git branch $remotes -D "${branches[@]}"

else
    echo "Aborting."
fi

