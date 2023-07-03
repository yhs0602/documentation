docker run -it --rm --platform linux/amd64 -p 8888:8888 \
-v $(pwd)/../include/backprop_tools/:/include/backprop_tools/:ro \
-v $(pwd):/workspace/:rw \
-w /workspace \
backprop_tools_docs \
jupyter lab --allow-root --ip 0.0.0.0
