echo "Installing DS Visualizer 2020 on Ubuntu 18/20."
cd ~/Downloads
ls
bin=`find ./ -name *DS2021Client.bin`
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
exit 0
