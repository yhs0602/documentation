docker run -it --rm --platform linux/amd64 -p 8888:8888 \
-v $(pwd):/workspace/:rw \
-w /workspace \
rltools/documentation \
jupyter lab --ip 0.0.0.0
