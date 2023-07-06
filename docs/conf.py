# Configuration file for the Sphinx documentation builder.
#
# For the full list of built-in configuration values, see the documentation:
# https://www.sphinx-doc.org/en/master/usage/configuration.html

# -- Project information -----------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#project-information

project = 'BackpropTools'
copyright = '2023'
author = 'Jonas Eschmann'

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

extensions = [
    'nbsphinx',
    'sphinx_reredirects'
]

templates_path = ['_templates']
exclude_patterns = ['_build', 'Thumbs.db', '.DS_Store']

redirects = {
    'index': 'overview.html',
}


# -- Options for HTML output -------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output

html_theme = 'furo'
html_static_path = ['_static']
html_title = 'BackpropTools Documentation'
html_logo = 'images/banner.svg'
html_css_files = [
    'overrides.css',
]

# color_primary = "#7DB9B6"
# color_secondary = "#b8b8b8"
# color_error = "#b97d7d"
# \definecolor{primary_color}{HTML}{7DB9B6}
# \definecolor{primary_color_readable}{HTML}{639694}


html_theme_options = {
    "light_css_variables": {
        "color-brand-primary": "#639694",
        "color-brand-content": "#639694",
        "color-admonition-background": "orange",
        "sidebar_hide_name": True,
    },
}