#!/usr/bin/env bash
# USAGE: ./main.sh  build | run | nvidia_docker

nvidia_docker() {
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt-get update && sudo apt-get install nvidia-container-toolkit
    sudo systemctl restart docker
}

build() {
    sudo docker build -t cuda -f docker/Dockerfile .
}

# USAGE:
# ./main.sh run install
# ./main.sh run jupyter | bash
run() {
    # Use a persistent pkgs directory for micromamba across all containers
    mkdir -p ~/pkgs

    # Mount the pkgs and src directory with GPUs on
    sudo docker run --gpus all \
        -it \
        -p 8888:8888 \
        -v ~/pkgs:/home/user/micromamba/pkgs \
        -v ./src:/home/user/src \
        cuda "$@"
}

"$@"
