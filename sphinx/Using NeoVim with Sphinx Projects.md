[...](<./Using NeoVim with Sphinx Projects.md>)
NeoVim can be used to edit Sphinx projects. The treesitter plugin has
builtin support for RST and MYST (markdown) files for syntax highlighting.

To build the Sphinx project, run `make html` in a new terminal window.
To view the built static webpages, run a `python -m http.server` inside
the `_build/html` directory, which can be accessed at port 8000.

Using this approach _LoT_ notes can be written as a Sphinx project.
Similarly, it is possible to use this method to write documentations.

---
# Details

For usage, setup a Sphinx project, open nvim in the directory, and
use the Telescope plugin to search and edit the files. 

