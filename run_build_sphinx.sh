set -e

IMAGE=rl_tools_docs_sphinx ./run.sh make clean
IMAGE=rl_tools_docs_sphinx ./run.sh make html
