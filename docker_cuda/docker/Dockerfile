# Available versions: https://hub.docker.com/r/nvidia/cuda/tags
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         gfortran \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng-dev \
         wget &&\
     rm -rf /var/lib/apt/lists/*

# setup user
RUN useradd -u 1000 user
RUN mkdir -p /home/user
RUN chown user /home/user
USER user

WORKDIR /home/user
ENV PATH="${PATH}:/home/user/.local/bin"

# Install mamba
RUN curl micro.mamba.pm/install.sh | bash

RUN mkdir -p /home/user/src
RUN mkdir -p /home/user/env

WORKDIR /home/user/src

COPY environment.yml            /home/user/environment.yml
COPY docker/entrypoint.sh       /home/user/entrypoint.sh

ENTRYPOINT ["/bin/bash", "/home/user/entrypoint.sh"]

# While running, make sure to
#   - Install nvidia-docker using apt/dnf
#   - Use the '--gpus all' flag in docker run
#   - Mount the src directory from host to /home/user/src
#   - Expose any appropriate port
