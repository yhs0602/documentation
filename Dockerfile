# FROM --platform=linux/amd64 continuumio/miniconda3
FROM --platform=linux/amd64 condaforge/mambaforge
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential
RUN mamba install -y -c conda-forge cmake xeus-zmq cling nlohmann_json cppzmq xtl pugixml doctest cpp-argparse jupyterlab
RUN git clone https://github.com/jupyter-xeus/xeus-cling.git
WORKDIR xeus-cling
RUN mkdir build
WORKDIR build
ENV CONDA_PREFIX=/opt/conda
RUN conda run cmake -D CMAKE_INSTALL_PREFIX=${CONDA_PREFIX} -D CMAKE_INSTALL_LIBDIR=${CONDA_PREFIX}/lib ..
RUN conda run make -j$(nproc) && make install
