#!/bin/bash

git-sync(){
    git add -A :/
    git commit -m "sync"
    current_branch=$(git branch | grep \*)
    current_branch=${current_branch:2} #delete astrisk
    if [[ $current_branch != "master" ]] then;
        git checkout master
        git merge master $current_branch --no-edit
        git checkout $current_branch
    fi
    git push origin master
}

git-show-parent(){
    git show-branch | sed "s/].*//" | grep "\*" | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -n1 | sed "s/^.*\[//"
}
git-merge-sync(){
    git add -A :/
    git commit -m "$1"
    current_branch=$(git branch | grep \*)
    current_branch=${current_branch:2} #delete astrisk
    if [[ $current_branch != "master" ]] then;
        git checkout master
        git merge master $current_branch --no-edit
        git branch -d $current_branch
    fi
    git push origin master
}
git-rm-cached(){
    set -o errexit

    # Author: David Underhill
    # Script to permanently delete files/folders from your git repository.  To use
    # it, cd to your repository's root and then run the script with a list of paths
    # you want to delete, e.g., git-delete-history path1 path2

    if [ $# -eq 0 ]; then
        exit 0
    fi

    # make sure we're at the root of git repo
    if [ ! -d .git ]; then
        echo "Error: must run this script from the root of a git repository"
        exit 1
    fi

    # remove all paths passed as arguments from the history of the repo
    files=$@
    git filter-branch --index-filter "git rm -rf --cached --ignore-unmatch $files" HEAD

    # remove the temporary history git-filter-branch otherwise leaves behind for a long time
    rm -rf .git/refs/original/ && git reflog expire --all &&  git gc --aggressive --prune
}
