#!/usr/bin/env bash

version="Aug 17, 2020"

echo
echo "Ubuntu installation script by Akhlak Mahmood"
echo "Last update: $version"
echo

# Initialization
shopt -s extglob

args=(); while [ "$1" != "" ]; do case "$1" in
#--------------------------------------------------------
        -s | --step )     step="$2";         shift;;
        -i | --install )  task="$2";         shift;;
#--------------------------------------------------------
* ) args+=("$1");; esac; shift; done; set -- "${args[@]}"

if [[ -z $task && -z $step ]]; then
	echo "You did not specify any option. Use -i or -s to specify a task or step."
	exit 
fi

opts=$1
[[ -z $task ]] || step=-1 # if a task specified, reset step
[[ -z $task ]] || opts=only # if a task specified, set 'only'

havecmd() {
        type "$1" &> /dev/null
}
nocmd() {
        type "$1" &> /dev/null
        ex=$?; [[ $ex -ne 0 ]] || return 1
}
die() {
	echo "ERROR: $1"
	exit 20
}

# Mantain an id of each task, so we can compare with the step
_id=0

if [[ -z $opts ]]; then
	echo "'only' not specified. Running all starting at step $step."
fi

# Basic settings 
let "_id++"
if [[ $step -eq $_id ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Please open Settings and make necessary adjustments."
	echo "Update date time format, display, wifi/password, sound etc."
	read -p "Press Enter to continue ..." input
fi

# update
let "_id++"
if [[ $step -eq $_id ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Checking for latest updates."
	sleep 1
	sudo apt-get update
	sudo apt-get upgrade
	read -p "Press Enter to continue ..." input
fi

# Check if restart needed
let "_id++"
if [[ $step -eq $_id ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Please open Software Updater, check for additional updates."
	echo "reboot if needed. If you are restarting, run this installer script"
	echo "as '$0 $step' after reboot."
	read -p "Press Enter to continue ..." input
fi

# Tilix Terminal
let "_id++"
if [[ $step -eq $_id ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing Tilix"
	sleep 1
	sudo apt-get install tilix
	echo ================================================================
	echo "Running tilix standalone, Please add tilix to favorites."
	echo "Rerun this script as '$0 -s $step' from tilix if you want."
	nohup tilix &
	read -p "Press Enter to continue ..." input
	[[ $opts != only ]] || exit 0
fi

# Vim can come handy time to time
let "_id++"
if [[ $step -eq $_id ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing vim"
	sudo apt-get install vim
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# Google Chrome
let "_id++"
if [[ $step -eq $_id ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Install Chrome"
	firefox https://www.google.com/chrome/ &
	sleep 1
	read -p "Press Enter to continue ..." input
	echo ================================================================
	echo "Running Chrome. Please sign in."
	google-chrome &
	echo "Please add Chrome to favorites. Close Firefox, installer window."
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# Dropbox
let "_id++"
if [[ $step -eq $_id ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Install Dropbox"
	google-chrome "https://www.google.com/search?q=download+dropbox" &
	sleep 1
	read -p "Press Enter to continue ..." input
	echo ================================================================
	echo "Please run Dropbox from Dash, sign in and set it up."
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# Graphics/GPU Driver
let "_id++"
if [[ $step -eq $_id || $task == "nvidia" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing NVIDIA drivers."
	read -p "Do you have any NVIDIA graphics card (y/[n])? " answer
	if [[ $answer == y || $answer == yes ]]; then
		sudo add-apt-repository ppa:graphics-drivers/ppa
		ubuntu-drivers list
		echo "Please enter the lastest driver version NO. from the list above."
		read -p "version number: " input
		sudo apt-get install nvidia-driver-$input
		echo "Please reboot the system NOW for new driver installation."
		echo "You can check loaded graphics cards by running 'nvidia-smi'"
	fi
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# git
let "_id++"
if [[ $step -eq $_id || $task == "git" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing Git"
	sleep 1
	sudo apt-get install git
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# Miniconda
let "_id++"
if [[ $step -eq $_id || $task == "conda" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Install Miniconda"
	google-chrome "https://www.google.com/search?q=miniconda" &> /dev/null &
	sleep 1
	read -p "Press Enter to continue ..." input
	echo ================================================================
	echo "Sourcing bashrc for miniconda ..."
	source ~/.bashrc
	echo "Installing basic conda packages ..."
	conda install numpy scipy matplotlib jupyter jupyterlab
	conda install sympy scikit-learn
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# HDD
let "_id++"
if [[ $step -eq $_id || $task == "hdd" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Mount additional Hard Disk"
	read -p "Do you have any additional HDD you need to mount (y/[n])? " answer
	if [[ $answer == y || $answer == yes ]]; then
		echo ================================================================
		sudo fdisk -l
		echo "Please find the external disk from the list. If you can't find it"
		echo "or this process fails, please try it manually."
		echo "Reference: https://askubuntu.com/a/125277"
		read -p "Press Enter to continue ..." input
		echo ================================================================
		echo "Creating /hdd directory for the mount point ..."
		sudo mkdir /hdd
		echo "Opening /etc/fstab in vim. Please add the following line "
		echo "/dev/<sdax>    /hdd    ext4    defaults    0    0"
		echo "replacing <sdax> with your device id (not disk id)."
		echo "Note: do not keep empty new lines in between."
		echo
		read -p "Press Enter to continue ..." input
		sudo vim /etc/fstab
		read -p "Press Enter to continue ..." input
		echo ================================================================
		echo "mounting /hdd"
		sudo mount /hdd
	fi
		
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# RC/DOT files
# usage ~/.installer.sh -i dotfiles
let "_id++"
if [[ $step -eq $_id  || $task == "dotfiles" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Symlinking RC files."
	sleep 1

	# path to cloud dotfiles, update this if needed
	path=~/Dropbox/common/dotfiles

	echo "Checking dotfiles in $path"
	if [[ -f $path/bashrc ]]; then
		mv ~/.bashrc ~/.bashrc.backup
		sudo ln -s $path/bashrc ~/.bashrc
		echo "Symlinked bashrc"
		echo "Sourcing bashrc will not work within this script."
		echo "Please source new bashrc when this script exits. Example: 'source ~/.bashrc'"
		echo "You may want to run git_prompt, installwd etc."

		mv ~/.installer.sh ~/.installer.sh.backup
		sudo ln -s $path/installer.sh ~/.installer.sh
		echo "Symlinked .installer.sh"

		mv ~/.vmdrc ~/.vmdrc.backup
		ln -s $path/vmdrc ~/.vmdrc
		echo "Symlinked vmdrc"

		mkdir -p ~/.config/matplotlib/
		mv ~/.config/matplotlib/matplotlibrc ~/.config/matplotlib/matplotlibrc.backup
		ln -s $path/matplotlibrc ~/.config/matplotlib/matplotlibrc
		echo "Symlinked matplotlibrc"

		mkdir -p ~/.config/gtk-3.0/
		mv ~/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css.backup
		ln -s $path/gtk.css ~/.config/gtk-3.0/gtk.css
		echo "Symlinked 3.0 gtk.css"

		mkdir -p ~/.config/gtk-4.0/
		mv ~/.config/gtk-4.0/gtk.css ~/.config/gtk-4.0/gtk.css.backup
		ln -s $path/gtk.css ~/.config/gtk-4.0/gtk.css
		echo "Symlinked 4.0 gtk.css"

		if [[ -f ~/.bash_aliases ]]; then
			read -p "Existing bash_aliases found. Do you want to move it to $path and symlink? (y/[n]) " answer
			if [[ $answer == y || $answer == yes ]]; then
				read -p "What should be the file name of bash_aliases in $path? " aliasname
				mv ~/.bash_aliases $path/$aliasname
				sudo ln -s $path/aliasname ~/.bash_aliases
				echo "Symlinked bash_aliases"
			fi
		else
			echo "No bash_aliases file found. Do you want to create one in $path and symlink?"
			read -p "Or, do you have a bash_aliases file in $path that you want to symlink? (y/[n]) " answer
			if [[ $answer == y || $answer == yes ]]; then
				read -p "What is or should be the file name of bash_aliases in $path? " aliasname
				sudo ln -s $path/$aliasname ~/.bash_aliases
				echo "Symlinked bash_aliases"
			fi
		fi
	else
		echo "$path/bashrc not found. Please update this installer script if needed."
		exit 1
	fi

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# LibreOffice and others
let "_id++"
if [[ $step -eq $_id || $task == "essentials" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Updating libreoffice and essentials"
	sudo apt-get install ttf-mscorefonts-installer
	#sudo add-apt-repository ppa:libreoffice/ppa
	#sudo apt-get update
	#sudo apt-get install libreoffice
	read -p "Press Enter to continue ..." input
	echo ================================================================
	sudo apt-get install ffmpeg vlc
	sudo apt-get install ubuntu-restricted-extras
	sudo apt-get install build-essential
	sudo apt-get install cmake
	sudo apt-get install sshfs htop
	echo "gnome-tweak-tool installed. Running tweak tool now."
	read -p "Press Enter to continue ..." input
	echo ================================================================
	gnome-tweaks
	read -p "Press Enter to continue ..." input
	echo ================================================================
	sudo add-apt-repository ppa:inkscape.dev/stable
	sudo apt-get update
	sudo apt-get install inkscape
	sudo apt-get install gimp
	#sudo apt-get install simplescreenrecorder
	sudo apt-get install dvipng
	read -p "Press Enter to continue ..." input
	echo ================================================================
	if nocmd subl; then
		wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
		echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
		sudo apt-get update
		sudo apt install sublime-text
	fi
	#sudo snap install code --classic
	read -p "Press Enter to continue ..." input
	echo ================================================================
	#sudo snap install spotify
	echo "All essentials installed. Cleaning up redundant packages."
	read -p "Press Enter to continue ..." input
	echo ================================================================
	sudo apt autoremove
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi



# Latex
let "_id++"
if [[ $step -eq $_id || $task == "latex" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Attempting to install TexLive. Please update the links if no"
	echo "longer valid. The installation will take some time (3700+ packages)."
	tl_tar_url="http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
	tl_path=/tmp/texlive.tar.gz
	echo "Downloading installer tar file to $tl_path ..."
	sleep 2
	wget -O "$tl_path" "$tl_tar_url"
	echo "Extracting tar archive: $tl_path ..."
	tar -xvzf "$tl_path" -C /tmp
	cd /tmp/install-tl*
	echo "Running installer ..."
	sudo ./install-tl || exit 11
	echo "Installation done. Please make sure /usr/local/texlive/2018/bin/x86_64-linux"
	echo "gets included in the path. Update bash_aliases if needed."
	read -p "Press Enter to continue ..." input
	echo ================================================================
	cd /tmp
	echo "Please add TexLive to PATH now and source rc."
	read -p "Press Enter to continue ..." input
	echo ================================================================
	sudo apt-get install texstudio
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi


# ambertools
let "_id++"
if [[ $step -eq $_id || $task == "ambertools" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing AmberTools"

	if nocmd conda; then
		echo "conda not found. Please install/load conda first."
		echo "you can install using '$0 -i conda'"
		exit 11
	fi
	conda install -c conda-forge ambertools=20
	sudo apt-get install libgfortran5
	conda install mpi4py
	sudo apt-get install openbabel
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# vmd avogadro
let "_id++"
if [[ $step -eq $_id || $task == "vmd" ]]; then
	let "step++"
	echo ================================================================
	if nocmd make; then
		die "make not found. Please install using '$0 -i essentials' first."
	fi

	if nocmd vmd; then
		echo "Installing vmd. Please download the tar archive to /tmp first."
		echo "If you have nvidia GPU card installed, run 'nvidia-smi' and check"
		echo "if it's a RTX card."
		read -p "Press Enter to continue ..." input
		echo ================================================================
		google-chrome "https://www.ks.uiuc.edu/Development/Download/download.cgi?PackageName=VMD" &> /dev/null &
		echo "Extract the archive into /tmp using file manager as well."
		read -p "Press Enter to continue ..." input
		echo ================================================================
		[[ -d /tmp/vmd* ]] || die "/tmp/vmd* not found. Did you extract here?"
		cd /tmp/vmd*
		echo "Attempting installation. Refer to the README file if this fails."
		read -p "Press Enter to continue ..." input
		echo ================================================================
		./configure || exit 11
		cd src
		sudo make install
		read -p "Press Enter to continue ..." input
		echo ================================================================
		echo "Installing povray"
		sudo apt-get install povray
	fi

	if nocmd avogadro; then
		sudo apt-get install avogadro
	fi

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# zotero
let "_id++"
if [[ $step -eq $_id || $task == "zotero" ]]; then
	let "step++"
	echo ================================================================
	cd ~
	install_loc=`find ~/ -name Zotero_*`

	if [[ ! -f ~/.local/share/applications/zotero.desktop ]]; then
		echo "Opening https://www.zotero.org/download/ Please download the tar archive to /tmp first."
		google-chrome "https://www.zotero.org/download/" &> /dev/null &
		echo "Extract the archive into $HOME using file manager as well."
		read -p "Press Enter to continue ..." input
		echo ================================================================
		[[ -d $install_loc ]] || die "$install_loc not found. Did you extract here?"
		cd $install_loc
		./set_launcher_icon
		ln -s $install_loc/zotero.desktop ~/.local/share/applications/zotero.desktop
		echo "Zotero added to Dash. Launch and add to favorites."
	else
		echo "Zotero seems to be already installed."
	fi

	if [[ ! -d ~/Zotero ]]; then
		echo "If you have a local backup of ~/Zotero directory, now is the time to copy it."
		read -p "Press Enter to continue ..." input
		echo ================================================================
	fi

	if nocmd masterpdfeditor5; then
		echo "Install Master PDF Editor 5"
		echo "Opening https://code-industry.net/ Please download the deb file and install."
		google-chrome "https://code-industry.net/get-master-pdf-editor-for-ubuntu/?download" &> /dev/null &
		read -p "Press Enter to continue ..." input
		echo ================================================================
		echo "Please select a PDF file in nautilus, open properties and set "
		echo "Master PDF Editor as the default application."
	fi

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi


# Discovery Studio
# usage ./<this_script> -i dsv19
let "_id++"
if [[ $step -eq $_id || $task == "dsv19" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing DS Visualizer 2019 on Ubuntu 18."
	cd ~/Downloads
	ls
	bin=`find ./ -name *ds*.bin`
	if [[ ! -f $bin ]]; then
		google-chrome "http://www.3dsbiovia.com/products/collaborative-science/biovia-discovery-studio/visualization-download.php" &> /dev/null &
		echo "Please download the installer bin file to ~/Downloads directory."
		read -p "Press Enter to continue ..." input
		echo ================================================================
		ls
		bin=`find ./ -name *ds*.bin`
	fi
	[[ -f $bin ]] || die "$bin file not found. Did you download here?"
	chmod +x $bin
	echo "installing prereqs ..."
	sudo apt-get install lib32ncurses6 lib32z1 tcsh
	ls
	echo ================================================================
	echo "Starting installation. Please accept all the defaults."
	echo "This was tested for biovia_2019.ds2019client.bin. If it fails,"
	echo "try updating this installer script."
	read -p "Press Enter to continue ..." input
	echo ================================================================

	echo "extracting DSV archive ..."
	./$bin --target dsclient
	[[ -d dsclient ]] || die "$bin extration failed. Is it a newer version?"
	cd dsclient
	ls
	echo "converting shell installer into bash script ..."
	installer=install*.sh
	sed -i "s/bin\/sh/bin\/bash\nshopt -s expand_aliases/" $installer
	./$installer

	echo "extracting license archive ..."
	cd ~/BIOVIA/Discovery*
	[[ -d lp_installer ]] || die "No lp_installer directory found. Is it a newer version?"
	cd lp_installer/
	./lp_setup_linux.sh --keep --noexec
	cd lpbuild
	ls
	echo "converting shell installer into bash script ..."
	installer=install*.sh
	sed -i "s/bin\/sh/bin\/bash\nshopt -s expand_aliases/" $installer
	./$installer

	cd ~/BIOVIA/Discovery*
	cd bin
	launcher=DiscoveryStudio*
	echo ================================================================
	echo "Setting up license location ..."
	lic=~/BIOVIA/*LicensePack/
	./config_lp_location $lic

	cd $lic/etc
	echo ================================================================
	echo "running license config ..."
	./lp_config

	cd ~/BIOVIA/Discovery*
	cd lib
	echo ================================================================
	echo "renaming libz files as .bak files ..."
	for i in libz.so libz.so.1 libz.so.1.2.8; do mv $i{,.bak}; done

	echo ================================================================
	shortcut=`find ~/Desktop -name discovery*.desktop`
	if [[ -f $shortcut ]]; then
		chmod +x $shortcut
		cp $shortcut ~/.local/share/applications/
		ex=$?; [[ $ex -ne 0 ]] || echo "DSV added to Ubuntu Dash."
	fi

	cd ../bin
	ls
	echo "All required setup is done. You may want to add DSperl alias to"
	echo "bash_aliases file for commandline execution of DSV perl scripts."
	echo "Launching DSV, cross your fingers."
	read -p "Press Enter to continue ..." input
	echo ================================================================
	./$launcher

	echo "If successful, you may want to delete the .bin file and dsclient/"
	echo "Not doing it automatically, in case this installation failed."

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# Discovery Studio 2020
# usage ./<this_script> -i dsv20
let "_id++"
if [[ $step -eq $_id || $task == "dsv20" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing DS Visualizer 2020 on Ubuntu 18/20."
	cd ~/Downloads
	ls
	bin=`find ./ -name *DS2020Client.bin`
	if [[ ! -f $bin ]]; then
		echo "Installer BIN file NOT found."
		echo "Please place the 2020 installer bin file to ~/Downloads directory."
		echo "The installer file might be obtained from the YY Group Google Drive."
		read -p "Press Enter to continue ..." input
		echo ================================================================
		ls
		bin=`find ./ -name *DS2020Client.bin`
	fi
	[[ -f $bin ]] || die "$bin file not found. Did you download here?"
	chmod +x $bin
	echo "installing prereqs ..."
	sudo apt-get install lib32ncurses6 lib32z1 tcsh libpng-dev
	ls
	echo ================================================================
	echo "Starting installation. Please accept all the defaults."
	echo "This was tested for BIOVIA_2020.DS2020Client.bin. If it fails,"
	echo "try updating this installer script."
	read -p "Press Enter to continue ..." input
	echo ================================================================

	echo "extracting DSV archive ..."
	./$bin --target dsclient
	[[ -d dsclient ]] || die "$bin extration failed. Is it a newer version?"
	cd dsclient
	ls
	echo "converting shell installer into bash script ..."
	installer=install*.sh
	sed -i "s/bin\/sh/bin\/bash\nshopt -s expand_aliases/" $installer
	./$installer

	echo "extracting license archive ..."
	cd ~/BIOVIA/DiscoveryStudio2020/
	[[ -d lp_installer ]] || die "No lp_installer directory found. Is it a newer version?"
	cd lp_installer/
	./lp_setup_linux.sh --keep --noexec
	cd lpbuild
	ls
	echo "converting shell installer into bash script ..."
	installer=install*.sh
	sed -i "s/bin\/sh/bin\/bash\nshopt -s expand_aliases/" $installer
	./$installer

	cd ~/BIOVIA/DiscoveryStudio2020/
	cd bin
	launcher=DiscoveryStudio*
	echo ================================================================
	echo "Setting up license location ..."
	lic=~/BIOVIA/*LicensePack/
	./config_lp_location $lic

	cd $lic/etc
	echo ================================================================
	echo "running license config ..."
	./lp_config

	cd ~/BIOVIA/DiscoveryStudio2020/
	cd lib
	echo ================================================================
	echo "renaming libz files as .bak files ..."
	for i in libz.so libz.so.1 libz.so.1.2.8; do mv $i{,.bak}; done

	echo "Checking libpng ..."
	if [[ ! -f /usr/lib/x86_64-linux-gnu/libpng15.so.15 ]]; then
		echo "libpng15.so.15 not found. Symlinking ..."
		if [[ -f /usr/lib/x86_64-linux-gnu/libpng16.so.16 ]]; then
			sudo ln -s /usr/lib/x86_64-linux-gnu/libpng16.so.16 /usr/lib/x86_64-linux-gnu/libpng15.so.15
		else
			echo "ERROR! libpng16.so.16 also not found. Please update the symlink"
			echo "if there is a new version of libpng."
			exit 12
		fi
	fi

	echo ================================================================
	shortcut=`find ~/Desktop -name discovery*.desktop`
	if [[ -f $shortcut ]]; then
		chmod +x $shortcut
		cp $shortcut ~/.local/share/applications/
		ex=$?; [[ $ex -ne 0 ]] || echo "DSV added to Ubuntu Dash."
	fi

	cd ../bin
	ls
	echo "All required setup is done. You may want to add DSperl alias to"
	echo "bash_aliases file for commandline execution of DSV perl scripts."
	echo "Launching DSV, cross your fingers ..."
	echo ================================================================
	./$launcher

	echo "If successful, you may want to delete the dsclient/ directory."
	echo "Not doing it automatically, in case this installation failed."

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# Discovery Studio 2021
# usage ./<this_script> -i dsv21
let "_id++"
if [[ $step -eq $_id || $task == "dsv21" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing DS Visualizer 2021 on Ubuntu 20."
	cd ~/Downloads
	ls
	bin=`find ./ -name *DS2021Client.bin`
	if [[ ! -f $bin ]]; then
		echo "Installer BIN file NOT found."
		echo "Please place the 2021 installer bin file to ~/Downloads directory."
		echo "The installer file might be obtained from the YY Group Google Drive."
		read -p "Press Enter to continue ..." input
		echo ================================================================
		ls
		bin=`find ./ -name *DS2020Client.bin`
	fi
	[[ -f $bin ]] || die "$bin file not found. Did you download here?"
	chmod +x $bin
	echo "installing prereqs ..."
	sudo apt-get install lib32ncurses6 lib32z1 tcsh libpng-dev
	ls
	echo ================================================================
	echo "Starting installation. Please accept all the defaults."
	echo "This was tested for BIOVIA_2021.DS2021Client.bin. If it fails,"
	echo "try updating this installer script."
	read -p "Press Enter to continue ..." input
	echo ================================================================

	echo "extracting DSV archive ..."
	./$bin --target dsclient
	[[ -d dsclient ]] || die "$bin extration failed. Is it a newer version?"
	cd dsclient
	ls
	echo "converting shell installer into bash script ..."
	installer=install*.sh
	sed -i "s/bin\/sh/bin\/bash\nshopt -s expand_aliases/" $installer
	./$installer

	echo "extracting license archive ..."
	cd ~/BIOVIA/DiscoveryStudio2021/
	[[ -d lp_installer ]] || die "No lp_installer directory found. Is it a newer version?"
	cd lp_installer/
	./lp_setup_linux.sh --keep --noexec
	cd lpbuild
	ls
	echo "converting shell installer into bash script ..."
	installer=install*.sh
	sed -i "s/bin\/sh/bin\/bash\nshopt -s expand_aliases/" $installer
	./$installer

	cd ~/BIOVIA/DiscoveryStudio2021/
	cd bin
	launcher=DiscoveryStudio*
	echo ================================================================
	echo "Setting up license location ..."
	lic=~/BIOVIA/*LicensePack/
	./config_lp_location $lic

	cd $lic/etc
	echo ================================================================
	echo "running license config ..."
	./lp_config

	cd ~/BIOVIA/DiscoveryStudio2021/
	cd lib
	echo ================================================================
	echo "renaming libz files as .bak files ..."
	for i in libz.so libz.so.1 libz.so.1.2.8; do mv $i{,.bak}; done

	echo "Checking libpng ..."
	if [[ ! -f /usr/lib/x86_64-linux-gnu/libpng15.so.15 ]]; then
		echo "libpng15.so.15 not found. Symlinking ..."
		if [[ -f /usr/lib/x86_64-linux-gnu/libpng16.so.16 ]]; then
			sudo ln -s /usr/lib/x86_64-linux-gnu/libpng16.so.16 /usr/lib/x86_64-linux-gnu/libpng15.so.15
		else
			echo "ERROR! libpng16.so.16 also not found. Please update the symlink"
			echo "if there is a new version of libpng."
			exit 12
		fi
	fi

	echo ================================================================
	shortcut=`find ~/Desktop -name discovery*.desktop`
	if [[ -f $shortcut ]]; then
		chmod +x $shortcut
		cp $shortcut ~/.local/share/applications/
		ex=$?; [[ $ex -ne 0 ]] || echo "DSV added to Ubuntu Dash."
	fi

	cd ../bin
	ls
	echo "All required setup is done. You may want to add DSperl alias to"
	echo "bash_aliases file for commandline execution of DSV perl scripts."
	echo "Launching DSV, cross your fingers ..."
	echo ================================================================
	./$launcher

	echo "If successful, you may want to delete the dsclient/ directory."
	echo "Not doing it automatically, in case this installation failed."

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi



# SSH Server
let "_id++"
if [[ $step -eq $_id || $task == "ssh" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing openssh-server"

	if nocmd sshfs; then
		sudo apt-get install sshfs
	fi
	sudo apt-get install openssh-server

	sudo systemctl enable ssh
	sudo systemctl start ssh

	sudo systemctl status ssh 

	echo "Configuring firewall ..."
	sudo ufw allow ssh
	sudo ufw enable
	sudo ufw status

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi


# Cuda
let "_id++"
if [[ $step -eq $_id || $task == "cuda" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing cuda toolkit"

	sudo apt-get install linux-headers-$(uname -r)
	echo "download and run the cuda tookit dev file ..."
	read -p "Press Enter to continue ..." input
	sudo apt-key add /var/cuda-repo-*/7fa2af80.pub
	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

# Tensorflow, taken from official page
let "_id++"
if [[ $step -eq $_id || $task == "tensorflow" ]]; then
	let "step++"
	echo ================================================================
	echo "$_id. Installing cuda supports for tensorflow"

	# Add NVIDIA package repositories
	wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
	sudo dpkg -i cuda-repo-ubuntu1804_10.0.130-1_amd64.deb
	sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
	sudo apt-get update
	wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
	sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
	sudo apt-get update

	# Install NVIDIA driver
	sudo apt-get install --no-install-recommends nvidia-driver-418
	# Reboot. Check that GPUs are visible using the command: nvidia-smi

	# Install development and runtime libraries (~4GB)
	sudo apt-get install --no-install-recommends \
	    cuda-10-0 \
	    libcudnn7=7.6.2.24-1+cuda10.0  \
	    libcudnn7-dev=7.6.2.24-1+cuda10.0


	# Install TensorRT. Requires that libcudnn7 is installed above.
	sudo apt-get install -y --no-install-recommends libnvinfer5=5.1.5-1+cuda10.0 \
	    libnvinfer-dev=5.1.5-1+cuda10.0

	[[ $opts != only ]] || exit 0
	read -p "Press Enter to continue ..." input
fi

echo
echo "Finished post installation. Total $step steps completed."
echo

