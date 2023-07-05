# FROM --platform=linux/amd64 continuumio/miniconda3
FROM --platform=linux/amd64 continuumio/miniconda3:23.3.1-0-alpine
ENV DEBIAN_FRONTEND=noninteractive

# RUN apt-get update && apt-get install -y build-essential

RUN conda create -n bptenv
# Dependencies for xeus-cling
# RUN mamba install -n bptenv -y -c conda-forge cmake xeus-zmq cling nlohmann_json cppzmq xtl pugixml doctest cpp-argparse jupyterlab
# Dependencies for Binder
# RUN mamba install -n bptenv -y -c conda-forge notebook
# Dependencies for the documentation
# RUN mamba install -n bptenv -y -c conda-forge pandoc sphinx nbsphinx jinja2 sphinx-reredirects furo
RUN conda install -n bptenv -c conda-forge xeus-cling 
RUN conda install -n bptenv -c conda-forge jupyterlab notebook

# COPY environment.yml .
# RUN ls
# RUN mamba env create -n bptenv -f environment.yml

# RUN git clone https://github.com/jupyter-xeus/xeus-cling.git
# WORKDIR xeus-cling
# RUN git checkout 0.15.1
# RUN mkdir build
# WORKDIR build
# ENV CONDA_PREFIX=/opt/conda/envs/bptenv/
# RUN conda run -n bptenv cmake -D CMAKE_INSTALL_PREFIX=${CONDA_PREFIX} -D CMAKE_INSTALL_LIBDIR=${CONDA_PREFIX}/lib ..
# RUN conda run -n bptenv make -j$(nproc) && make install
# WORKDIR /

# RUN apt-get update && apt-get install -y libhdf5-dev

# RUN apt-get update && apt-get install -y sudo
ARG NB_USER=bpt_user
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# RUN apt-get update && apt-get install -y git
RUN apk update && apk add git
WORKDIR /
RUN git clone https://github.com/BackpropTools/BackpropTools
# WORKDIR /BackpropTools
# RUN git submodule update --init --recursive -- external/highfive
RUN mkdir -p /usr/local/include
RUN ln -s /BackpropTools/include/backprop_tools /usr/local/include/
# RUN mkdir /data
# WORKDIR /data
# RUN pip3 install numpy==1.22.4 datasets==2.11.0 h5py==3.7.0 Pillow==9.4.0
# RUN python3 /BackpropTools/examples/docker/00_basic_mnist/fetch_and_convert_mnist.py

# # RUN adduser --disabled-password \
# #     --gecos "Default user" \
# #     --uid ${NB_UID} \
# #     ${NB_USER}
# RUN useradd -md ${HOME} -s /bin/bash -c "Default User" -u ${NB_UID} -U ${NB_USER} 
RUN addgroup -g ${NB_UID} ${NB_USER} && adduser -h ${HOME} -s /bin/ash -G ${NB_USER} -u ${NB_UID} -D -g "Default User" ${NB_USER}
RUN echo "${NB_USER} ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# RUN usermod -aG sudo ${NB_USER}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

RUN chown -R ${NB_UID} /BackpropTools

# # RUN apt-get update && apt-get install -y software-properties-common
# # RUN add-apt-repository ppa:ppa-verse/xeus-cling
# # RUN apt-get update && apt-get install -y cling


USER ${NB_USER}
WORKDIR /home/${NB_USER}



ENTRYPOINT ["/opt/conda/bin/conda", "run", "-n", "bptenv", "--no-capture-output", "--live-stream"]
