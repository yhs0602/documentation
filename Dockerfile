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
WORKDIR /
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/BackpropTools/BackpropTools
RUN mkdir /include
RUN ln -s /BackpropTools/include/backprop_tools /usr/local/include/
RUN conda install -c conda-forge notebook

ARG NB_USER=bpt_user
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}

ENTRYPOINT ["/opt/conda/bin/conda", "run", "--no-capture-output", "--live-stream"]
