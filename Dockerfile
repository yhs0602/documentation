# FROM --platform=linux/amd64 continuumio/miniconda3
FROM --platform=linux/amd64 condaforge/mambaforge:23.1.0-3
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y build-essential

# RUN mamba env create -n bptenv
# Dependencies for xeus-cling
# RUN mamba install -n bptenv -y -c conda-forge cmake xeus-zmq cling nlohmann_json cppzmq xtl pugixml doctest cpp-argparse jupyterlab
# Dependencies for the documentation
# RUN mamba install -n bptenv -y -c conda-forge notebook pandoc sphinx nbsphinx jinja2
COPY environment.yml .
RUN ls
RUN mamba env create -n bptenv -f environment.yml

RUN git clone https://github.com/jupyter-xeus/xeus-cling.git
WORKDIR xeus-cling
RUN mkdir build
WORKDIR build
ENV CONDA_PREFIX=/opt/conda/envs/bptenv/
RUN conda run -n bptenv cmake -D CMAKE_INSTALL_PREFIX=${CONDA_PREFIX} -D CMAKE_INSTALL_LIBDIR=${CONDA_PREFIX}/lib ..
RUN conda run -n bptenv make -j$(nproc) && make install
WORKDIR /

ARG NB_USER=bpt_user
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/BackpropTools/BackpropTools
RUN ln -s /BackpropTools/include/backprop_tools /usr/local/include/

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
WORKDIR /home/${NB_USER}


ENTRYPOINT ["/opt/conda/bin/conda", "run", "-n", "bptenv", "--no-capture-output", "--live-stream"]
