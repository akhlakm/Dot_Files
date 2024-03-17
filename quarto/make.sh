#/bin/bash
#
# Source this from global make.sh

if [[ $PATH != *".local/bin"* ]]; then
    export PATH=$PATH:~/.local/bin
fi

install-docs() {
    # Install quarto to .local/bin

    version=v1.4.551
    echo "Installing Quarto $version. Please check for updates manually."

    wget https://github.com/quarto-dev/quarto-cli/releases/download/${version}/quarto-${version}-linux-amd64.tar.gz || exit 31
    mkdir ~/.loca/bin
    tar -C ~/.local/bin -xvzf quarto-${version}-linux-amd64.tar.gz
    quarto check || exit 32
}

docs() {
    # Run quarto preview.
    cd docs || echo "Continuing anyway ..."

    if curl localhost:8088 &> /dev/null; then
	echo "Already serving on http://localhost:8088/"
    else
        quarto preview &> ~/quarto-preview.log &
        cat ~/quarto-preview.log
    fi
}

docs-logs() {
    # Print the output of quarto preview.

    cat ~/quarto-preview.log
}

docs-setup() {
    # Render the setup page as PDF.
    # You may need to run `quarto install tinytex`.
    #
    outfile=Project-Setup.pdf

    quarto render project/setup.qmd --to pdf --toc || exit 34
    cp _site/project/setup.pdf $outfile
    echo "Saved OK: $outfile"

    open $outfile
}

"$@"
