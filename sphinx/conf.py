# Configuration file for the Sphinx documentation builder.

project     = 'SphinxNotes'
copyright   = '2024, Akhlak Mahmood'
author      = 'Akhlak Mahmood'
release     = '0.1'

# -- General configuration ---------------------------------------------------

extensions = [
    'sphinx.ext.napoleon',
    'sphinx.ext.githubpages',
    'sphinx.ext.autosummary',
    'myst_parser',              # pip install myst_parser
]

templates_path = ['_templates']
exclude_patterns = ['build', 'Thumbs.db', '.DS_Store']

# -- Options for HTML output -------------------------------------------------

html_theme = 'alabaster'
# html_show_sphinx = False
# html_static_path = ['_static']

html_theme_options = {
    'github_user': 'akhlakm',
    'github_repo': 'akhlakm',
    'page_width': '1080px',
}
