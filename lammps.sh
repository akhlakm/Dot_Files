#!/usr/bin/env bash

version="2023.06a"

echo
echo "LAMMPS script (v$version) by Akhlak Mahmood"
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

download() {
    git clone --branch stable --depth 5 https://github.com/lammps/lammps.git lammps_official
}

"$@"

build() {
    module load cpu
    module load gcc cmake
    module load ffmpeg fftw openmpi openblas

    cmake ../cmake/ -C ../cmake/presets/mspin.cmake
    
    echo "please run 'make -j4'"
}