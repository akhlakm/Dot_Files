#!/bin/bash

install() {
    # This must be done in the entrypoint, not in the Dockerfile.
    # Because installation of some gpu packages depends on the --gpus flag of docker run.
    micromamba create -p ./.env -f ~/environment.yml --yes
}

execute() {
    # Run a command in the target environment
    micromamba run -p ./.env /bin/bash -c "$@"
}

jupyter() {
    execute "jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --NotebookApp.token='' --NotebookApp.password=''"
}

bash() {
    micromamba run -p ./.env /bin/bash "$@"
}

"$@"
