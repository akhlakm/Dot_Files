#!/bin/bash
version="Sep 19, 2022"
DOTREPO="https://github.com/akhlakm/Dot_Files.git"
BRANCH="master"

### RUN
### ---------------------------------------------------------------------------
echo
echo "Linux bootstrap script by Akhlak Mahmood"
echo "Last update: $version"
echo "Repository: ($BRANCH) $DOTREPO"
echo

shopt -s extglob
havecmd() {
    type "$1" &> /dev/null
}
nocmd() {
    type "$1" &> /dev/null
    ex=$?; [[ $ex -ne 0 ]] || return 1
}
die() {
    echo "ERROR: $@" && exit $1
}

if havecmd apt; then
    sudo apt update
    sudo apt install -y git ansible openssh-server
elif havecmd dnf; then
    sudo dnf update
    sudo dnf install git ansible
else
    die 1 "apt and dnf not found :("
fi

sudo ansible-pull -o -U $DOTREPO -C $BRANCH main.yml
