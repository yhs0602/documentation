docker run -it --rm --platform linux/amd64 -p 8888\:8888 \
--user $(id -u):$(id -g) \
-v $(pwd)/../include/rl_tools/\:/usr/local/include/rl_tools/\:ro \
-v $(pwd):/workspace/\:rw -w /workspace \
$IMAGE \
"$@"
