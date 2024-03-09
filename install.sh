#!/usr/bin/env bash

version="2023.08a"

# path to dropbox dotfiles, update this if needed
dbDots=/home/data/Dropbox/common/dotfiles

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

bashrc(){
    if [[ $(uname -s) == "Darwin" ]]; then
	# mac
	echo "MacOS detected."
	mv ~/.bashrc ~/.bashrc.backup
	ln -s $CWD/bashrc.sh ~/.bashrc
    elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
        # debian
        mv ~/.bashrc ~/.bashrc.backup
        ln -s $CWD/bashrc.sh ~/.bashrc
    else
        # centos
        mv /etc/profile.d/bashrc.sh /etc/profile.d/bashrc.sh.backup
        ln -s $CWD/bashrc.sh /etc/profile.d/bashrc.sh
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
}

git() {
    git config --global user.name 'akhlakm'
    read -p "Git[hub] user.email? " email
	git config --global user.email $email

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
}

docker() {
    sudo apt install -y curl
    sudo curl https://get.docker.com | bash

    # Add current user to the docker group
    sudo groupadd docker || echo OK
    sudo usermod -aG docker $USER
    newgrp docker
    echo "Done!"
    docker ps
}

nvidia_docker() {
    # sudo ./install.sh nvidia_docker
    #
    sudo apt install -y curl
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu22.04/nvidia-docker.list > /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt update
    sudo apt install nvidia-container-toolkit
    sudo systemctl restart docker
    echo "Done!"
}

swapfile() {
    size=40G
    loc=/home/swapfile
    sudo fallocate -l $size $loc
    sudo chmod 600 $loc
    sudo mkswap $loc
    sudo swapon $loc
    # make permanent
    # echo "$loc none swap sw 0 0" | sudo tee -a /etc/fstab
    echo "Done!"
    free
}

miniconda() {
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh
    # /bin/rm Miniconda3-latest-Linux-x86_64.sh
    source ~/.bashrc
    conda --version
    conda update -n base conda
    conda install -n base conda-libmamba-solver
    conda config --set solver libmamba
    echo "Done!"
}

spotify() {
    curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update
    sudo apt install spotify-client
}

vmd(){
    mv ~/.vmdrc ~/.vmdrc.backup &> /dev/null
    ln -s $CWD/vmdrc ~/.vmdrc
}

fonts() {
    USER_FONTS_DIR=~/.fonts
    mkdir -p $USER_FONTS_DIR
    for ffile in fonts/*; do
        echo -e "$(realpath $ffile)   <-- $USER_FONTS_DIR/$(basename $ffile)"
        ln -s $(realpath $ffile) "$USER_FONTS_DIR/$(basename $ffile)"
    done
    fc-cache -f -v
    rm ~/.cache/matplotlib/*
}

matplotlib() {
    echo "$CWD/matplotlib.mplstyle <-- ~/matplotlib.mplstyle"
    ln -s $CWD/matplotlib.mplstyle ~/matplotlib.mplstyle
    echo OK
    echo
    echo "Please run '$0 fonts' to install the required fonts."
}


if [[ "$#" -lt 1 ]]; then

    echo -e "USAGE: $0 <command> [options...]\n"

    echo -e "\t bashrc - Install bashrc files."
    echo -e "\t git - Setup git username and shell hooks."
    echo -e "\t docker - Install docker. (SU)"
    echo -e "\t nvidia_docker - Install GPU support for docker. (SU)"
    echo -e "\t swapfile - Setup swapfile. (SU)"
    echo -e "\t vmd - Setup vmdrc file."
    echo -e "\t fonts - Install custom user fonts."
    echo -e "\t matplotlib - Setup matplotlib style file."
    echo -e "\t spotify - Setup spotify-client repo and install. (SU)"
    echo

else
    "$@"
fi
