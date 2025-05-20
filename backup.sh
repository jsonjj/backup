#!/usr/bin/env bash

if [ $1 = "init" ]; then
  if [[ -d "${2}/.backups" ]]; then
    exit 0
  fi
  mkdir -p ${2}/.backups 
  cd $2
  ${0} commit main "Init"
  exit 0
fi

getTimestamp() {
    timestamp="$2"
    if [ "$timestamp" = "" ]; then
        desired_branch=`ls -1t ./.backups/${1}_backup_*.tar | head -n1`
        timestamp=`echo "$desired_branch" | grep -o '[0-9]\+'`
    fi
    echo $timestamp
}

if [[ ! -d "./.backups" ]]; then
    echo "AWWWWW thats so sad :(. This is not a repository!"
    exit 1
fi

if [ $1 = "commit" ]; then
    timestamp=$(date +%s)
    tar cf ./.backups/${2}_backup_${timestamp}.tar --exclude=".backups" .
    echo "${2}-${timestamp}: ${3}" >> .backups/status.txt
elif [ $1 = "cb" ]; then
    branch_timestamp="${2}"
    IFS='-' read -r branch timestamp <<< "$branch_timestamp"
    timestamp=$(getTimestamp $branch $timestamp)
    ${0} sb ${branch} ${timestamp} # call sb
    ${0} commit ${3} "Branch from ${branch_timestamp}"
elif [ $1 = "rb" ]; then
    rm -r ./.backups/${2}_backup_*
elif [ $1 = "sb" ]; then
    rm -rf -- *
    timestamp=$(getTimestamp $2 $3)
    tar xf ./.backups/${2}_backup_${timestamp}.tar
elif [ $1 = "log" ]; then
    more .backups/status.txt
elif [ $1 = "extract" ]; then
    branch_timestamp="${2}"
    IFS='-' read -r branch timestamp <<< "$branch_timestamp"
    timestamp=$(getTimestamp $branch $timestamp)
    tar xf ./.backups/${branch}_backup_${timestamp}.tar ${3}
else
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  commit <branch_name> <message>                      Commit the working dir"
    echo "  cb <branch_name>-[timestamp] <new_branch_name>      Creates a new branch from branch-timestamp"
    echo "  rb <branch_name>                                    Remove the branch and all of its commits"
    echo "  sb <branch_name> [timestamp]                        Switching to branch-timestamp"
    echo "  log                                                 History of your commits"
    echo "  extract <branch_name>-[timestamp] <some/path>       Extract a file/dir into working dir"
    exit 1
fi
exit 0