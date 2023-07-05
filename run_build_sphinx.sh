set -e

IMAGE=backprop_tools_docs_sphinx ./run.sh make clean
IMAGE=backprop_tools_docs_sphinx ./run.sh make html
