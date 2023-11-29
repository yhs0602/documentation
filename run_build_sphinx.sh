set -e

IMAGE=rltools/documentation_builder ./run.sh make clean
IMAGE=rltools/documentation_builder ./run.sh make html
