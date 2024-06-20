#!/usr/bin/env bash

version="24.06a"

# path to dropbox dotfiles, update this if needed
dbDots=/home/data/Dropbox/common/dotfiles

echo
echo "Linux/MacOS installation script (v$version) by Akhlak Mahmood"
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

        # on mac, .bash_profile is loaded in login shell
        echo "source ~/.bashrc" >> ~/.bash_profile

    elif [ "$(grep -Ei 'debian|buntu|mint' /etc/*release)" ]; then
        # debian
        mv ~/.bashrc ~/.bashrc.backup
        ln -s $CWD/bashrc.sh ~/.bashrc
    else
        # centos
        if [[ -f /etc/profile.d/bashrc.sh ]]; then
            mv /etc/profile.d/bashrc.sh /etc/profile.d/bashrc.sh.backup
            ln -s $CWD/bashrc.sh /etc/profile.d/bashrc.sh
        else
            mv ~/.bashrc ~/.bashrc.backup
            ln -s $CWD/bashrc.sh ~/.bashrc
        fi
    fi

    echo "Symlinked $CWD/bashrc.sh, please restart session to take effect."

    # if [[ -f ~/.bash_aliases ]]; then
    #     read -p "Existing bash_aliases found. Do you want to move it to $dbDots and symlink? (y/[n]) " answer
    #     if [[ $answer == y || $answer == yes ]]; then
    #         read -p "What should be the file name of bash_aliases in $dbDots? " aliasname
    #         mv ~/.bash_aliases $dbDots/$aliasname
    #         ln -s $dbDots/aliasname ~/.bash_aliases
    #         echo "Symlinked bash_aliases"
    #     fi
    # else
    #     echo "No bash_aliases file found. Do you want to create one in $dbDots and symlink?"
    #     read -p "Or, do you have a bash_aliases file in $dbDots that you want to symlink? (y/[n]) " answer
    #     if [[ $answer == y || $answer == yes ]]; then
    #         read -p "What is or should be the file name of bash_aliases in $dbDots? " aliasname
    #         ln -s $dbDots/$aliasname ~/.bash_aliases
    #         echo "Symlinked bash_aliases"
    #     fi
    # fi

    # Wezterm config
    ln -s $CWD/wezterm/wezterm.lua ~/.wezterm.lua
}

gitme() {
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

wezterm() {
    if command -v wezterm; then
        echo "wezterm already installed"
    else
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        sudo apt install curl
        curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
        echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
        sudo apt update
        sudo apt install wezterm
    fi

    [[ -f ~/.wezterm.lua ]] || ln -s $CWD/wezterm/wezterm.lua ~/.wezterm.lua
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

nvidia-docker() {
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

libmamba() {
    conda --version || die 1 "Please install conda first"
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
    rm ~/.cache/matplotlib/* || true
}

matplotlib() {
    echo "$CWD/matplotlib.mplstyle <-- ~/matplotlib.mplstyle"
    ln -s $CWD/matplotlib.mplstyle ~/matplotlib.mplstyle
    echo OK
    echo
    echo "Please run '$0 fonts' to install the required fonts."
}

neovim() {
    if [[ $(uname -s) == "Darwin" ]]; then
        # MacOS
        brew install neovim
    else
        # Linux
        wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
        chmod +x nvim.appimage
        mkdir -p ~/.local/bin
        mv nvim.appimage ~/.local/bin/nvim
    fi

    # configuration
    mkdir -p ~/.config
    [[ -d ~/.config/nvim ]] || ln -s $CWD/neovim ~/.config/nvim
}

tmux() {
    # Install tmux on Mac or Linux.
    if [[ $(uname -s) == "Darwin" ]]; then
        # MacOS
        brew install tmux
    else
        # Linux
        # Update the URL / version number if necessary.
        wget https://github.com/nelsonenzo/tmux-appimage/releases/download/3.3a/tmux.appimage
        chmod +x tmux.appimage
        mkdir -p ~/.local/bin
        mv tmux.appimage ~/.local/bin/tmux
    fi

    # Configuration
    mkdir -p ~/.config
    [[ -d ~/.config/tmux ]] || ln -s $CWD/tmux ~/.config/tmux

    # (TPM) tmux plugin installer
    if [[ ! -d $CWD/tmux/plugins/tpm ]]; then
        mkdir -p $CWD/tmux/plugins/
        cd $CWD/tmux/plugins
        command git clone https://github.com/tmux-plugins/tpm tpm
    else
        cd $CWD/tmux/plugins/tpm && command git pull
        cd $CWD
    fi
}

install-nodejs() {
    # Install nvm
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Install node
    nvm install node
}

update-nodejs() {
    # Load nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Update node
    nvm install node
    nvm alias default node
}


if [[ "$#" -lt 1 ]]; then

    echo -e "USAGE: $0 <command> [options...]\n"

    echo -e "\t bashrc - Install bashrc files."
    echo -e "\t gitme - Setup git username and shell hooks."
    echo -e "\t docker - Install and setup docker and permissions. (SU)"
    echo -e "\t nvidia-docker - Install GPU support for docker. (SU)"
    echo -e "\t swapfile - Setup swapfile. (SU)"
    echo -e "\t vmd - Setup vmdrc file."
    echo -e "\t libmamba - Setup libmamba as conda solver."
    echo -e "\t fonts - Install custom user fonts."
    echo -e "\t matplotlib - Setup matplotlib style file."
    echo -e "\t spotify - Setup spotify-client repo and install. (SU)"
    echo -e "\t neovim - Setup and install neovim (AppImage)."
    echo -e "\t wezterm - Setup and install wezterm. (SU)"
    echo -e "\t tmux - Setup and install tmux (AppImage)."
    echo -e "\t install-nodejs - Setup and install npm and nodejs."
    echo -e "\t update-nodejs - Update npm and nodejs."
    echo

else
    "$@"
fi
