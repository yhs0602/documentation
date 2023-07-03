## Getting started documentation for BackpropTools

Beware that BackpropTools requires C++17 which is supported starting from Cling v1.0. At this moment the latest stable release is 0.9 hence a recent version of Cling should be cloned from Github and compiled from source. To make this more convenient we provide a Dockerfile to create a Docker image with the appropriate version. On Linux you can create and use it using `./build.sh` and `./run.sh` subsequently. BackpropTools is cloned during the build of the image but can also be mounted at runtime (to allow easy modifications from the host PC) using `./run_mount.sh` instead. 


## Generate Sphinx Doc
```
./run_build_sphinx.sh
```