#!/bin/bash

version="2024.05a"

echo
echo "EC2 setup script (v$version) by Akhlak Mahmood"
echo

# To copy files between S3
export SYNC="rsync -vihr --inplace --progress"

setup() {
	sudo yum install git
}

login() {
	echo "Please copy paste the AWS access and secret keys ..."
	reap -p "Press enter to continue ..."
	aws configure
}

mounts3() {
	S3BUCKET=$1

	[[ -n $S3BUCKET ]] || {
		echo "Usage: $0 <S3 bucket name>"
		exit 1
	}

	if ! command -v mount-s3; then
		echo "Installing mount-s3 ..."
		wget https://s3.amazonaws.com/mountpoint-s3-release/latest/x86_64/mount-s3.rpm
		sudo yum install ./mount-s3.rpm && rm ./mount-s3.rpm
	fi

	# Mount S3 bucket
	mkdir -p $HOME/s3
	mkdir -p /tmp/s3cache
	mount-s3 --cache /tmp/s3cache --allow-delete --allow-overwrite $S3BUCKET $HOME/s3
}

miniforge() {
	export CONDA_DIR=$HOME/miniforge
	export CONDA_ENV=$HOME/conda_env
	export PYTHON_VERSION=3.11

	if ! command -v mamba; then
		# Install Miniforge
		curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
		bash Miniforge3-$(uname)-$(uname -m).sh -b -p ${CONDA_DIR}
	else
		source ${CONDA_DIR}/etc/profile.d/conda.sh
	fi

	if ! conda activate $CONDA_ENV; then
		mamba create --prefix $CONDA_ENV -y python==${PYTHON_VERSION} numpy
		conda activate $CONDA_ENV
	fi
}

github() {
	echo "Please copy paste the GH private key contents ..."
	reap -p "Press enter to continue with vim ..."
	vim $HOME/.ssh/id_ed25519
	chmod 0600 $HOME/.ssh/id_ed25519
}

if [[ "$#" -lt 1 ]]; then
    echo -e "USAGE: $0 <command> [options...]\n"

	echo -e "\t setup - Setup and install required packages. (SU)"
    echo -e "\t github - Setup github SSH key."
    echo -e "\t miniforge - Install and setup conda using miniforge."
	echo -e "\t login - Setup AWS CLI credentials."
	echo -e "\t mounts3 - Setup and mount a given s3 bucket. (SU)"
    echo

else
    "$@"
fi

