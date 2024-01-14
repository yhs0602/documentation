set -e

IMAGE=rltools/documentation-builder ./run.sh make clean
IMAGE=rltools/documentation-builder ./run.sh make html
