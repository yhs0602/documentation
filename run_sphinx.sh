docker run -it --rm --platform linux/amd64 \
-v $(pwd):/workspace/\:rw -w /workspace \
rl_tools_docs_sphinx \
"$@"