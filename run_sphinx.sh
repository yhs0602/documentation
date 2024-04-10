docker run -it --rm --platform linux/amd64 \
--user $(id -u):$(id -g) \
-v $(pwd):/workspace/\:rw -w /workspace \
rltools/documentation-builder \
"$@"
