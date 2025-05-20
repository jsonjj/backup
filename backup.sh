#!/usr/bin/env bash

if [[ ! -d "./backups" ]]; then
    echo "AWWWWW thats so sad :(. This is not a repository!"
    exit 1
fi

if [ $1 = "cb" ]; then
    tar cvf ./backups/${3}_backup_$(date +%s).tar $2
elif [ $1 = "rb" ]; then
    rm -r ./backups/${2}_backup_*
elif [ $1 = "sb" ]; then
    rm 
else
    echo "Unknown command"
    exit 1
fi
exit 0
    
# git status
# git commit
# switch branch
# create branch /
# remove branch
# git push
# git checkout <ref> -- <path/to/file>