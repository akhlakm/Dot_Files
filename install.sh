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
        sudo ln -s $CWD/bashrc.sh ~/.bashrc
    else
        # centos
        sudo mv /etc/profile.d/bashrc.sh /etc/profile.d/bashrc.sh.backup
        sudo ln -s $CWD/bashrc.sh /etc/profile.d/bashrc.sh
    fi
    echo "Symlinked $CWD/bashrc.sh, please restart session to take effect."

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


## PostgreSQL
## Check for updates: https://wiki.postgresql.org/wiki/Apt
## ===============================================================
if [[ $task == "postgresql" ]]; then

    # install reqs
    sudo apt install curl ca-certificates gnupg

    # download key
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null

    # add to apt sources list
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

    # update and install
    sudo apt update
    sudo apt install postgresql-14

    echo Done
fi


## pgAdmin
## Check for updates: https://www.pgadmin.org/download/pgadmin-4-apt/
## ===============================================================
if [[ $task == "pgadmin" ]]; then

    # install reqs
    sudo apt install curl ca-certificates gnupg

    # download key
    curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg

    # add to apt sources list
    sudo sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'

    # update and install
    sudo apt update
    sudo apt install pgadmin4

    # update postgres password
    sudo -u postgres psql postgres -c "alter user postgres with password 'postgres';"

    # setup a user role for the current ubuntu user with password as the same name
    # sql="CREATE ROLE ${USER} WITH LOGIN PASSWORD '${USER}';"
    # sudo -u postgres psql postgres -c "$sql"

    echo Done
fi
