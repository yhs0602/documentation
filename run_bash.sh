if [ -z "$IMAGE" ]; then
    IMAGE=backprop_tools_docs
fi
docker run -it --rm --platform linux/amd64 -p 8888:8888 \
-v $(pwd)/../include/backprop_tools/:/usr/local/include/backprop_tools/:ro \
-v $(pwd):/workspace/:rw \
-w /workspace \
--entrypoint bash \
$IMAGE
