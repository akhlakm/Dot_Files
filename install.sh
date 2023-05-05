#!/usr/bin/env bash

version="2023.05a"

# path to dropbox dotfiles, update this if needed
dbDots=~/Dropbox/common/dotfiles

echo
echo "Linux installation script (v$version) by Akhlak Mahmood"
echo

## INITIALIZATION
## ===============================================================
shopt -s extglob

CWD=$(echo $(cd $(dirname $0); pwd))

havecmd() {
        type "$1" &> /dev/null
}
nocmd() {
        type "$1" &> /dev/null
        ex=$?; [[ $ex -ne 0 ]] || return 1
}
die() {
	echo "ERROR - $2"
	exit $1
}

task=$1; [[ -n $task ]] || die 1 "Please specify a task: $0 <task>"

## BASHRC
## ===============================================================
if [[ $task == "bashrc" ]]; then

    if [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
        # debian
        sudo mv ~/.bashrc ~/.bashrc.backup
        sudo ln -s $CWD/bashrc ~/.bashrc
    else
        # centos
        sudo mv /etc/profile.d/bashrc.sh /etc/profile.d/bashrc.sh.backup
        sudo ln -s $CWD/bashrc /etc/profile.d/bashrc.sh
    fi
    echo "Symlinked $CWD/bashrc, please restart session to take effect."

    if [[ -f ~/.bash_aliases ]]; then
        read -p "Existing bash_aliases found. Do you want to move it to $dbDots and symlink? (y/[n]) " answer
        if [[ $answer == y || $answer == yes ]]; then
            read -p "What should be the file name of bash_aliases in $dbDots? " aliasname
            mv ~/.bash_aliases $dbDots/$aliasname
            ln -s $dbDots/aliasname ~/.bash_aliases
            echo "Symlinked bash_aliases"
        fi
    else
        echo "No bash_aliases file found. Do you want to create one in $dbDots and symlink?"
        read -p "Or, do you have a bash_aliases file in $dbDots that you want to symlink? (y/[n]) " answer
        if [[ $answer == y || $answer == yes ]]; then
            read -p "What is or should be the file name of bash_aliases in $dbDots? " aliasname
            ln -s $dbDots/$aliasname ~/.bash_aliases
            echo "Symlinked bash_aliases"
        fi
    fi
fi 

## git
## ===============================================================
if [[ $task == "git" ]]; then
    git config user.name 'akhlakm'
    read -p "Git[hub] user.email? " email
	git config user.email $email

    if [[ ! -f ~/.git-prompt.sh ]]; then
		# download and use the official one
		echo "Downloading git-prompt ..."
		if havecmd wget; then
			wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt.sh
		elif havecmd curl; then
			curl "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh" > ~/.git-prompt.sh
		fi
	fi
	source ~/.git-prompt.sh && echo "git-prompt loaded."
fi

