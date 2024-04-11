# Documentation for RLtools

## C++ Notebooks as Documentation
This repo contains a Docker container that can run C++ notebooks to create a tutorial that can be run on e.g. Binder but also viewed on e.g. readthedocs.

<!-- Beware that RLtools requires C++17 which is supported starting from Cling v1.0. At this moment the latest stable release is 0.9 hence a recent version of Cling should be cloned from Github and compiled from source. To make this more convenient we provide a Dockerfile to create a Docker image with the appropriate version. On Linux you can create and use it using `./build.sh` and `./run.sh` subsequently. RLtools is cloned during the build of the image but can also be mounted at runtime (to allow easy modifications from the host PC) using `./run_mount.sh` instead.  -->
The Docker container to run the C++ notebooks can be built using `./build.sh` and run using `./run_jupyter.sh` the only requirement is a working Docker installation. 
To update the documentation container replace the commit hash in the Dockerfile.

## Sphinx doc
Sphinx uses rst files to create a standard documentation format that can also include jupyter notebooks. Use `./build_sphinx.sh` to build the image and `./run_build_sphinx.sh` to run the container.


## Deploy

```
cp -r _build/html/* static/
```