# FROM --platform=linux/amd64 continuumio/miniconda3:23.3.1-0-alpine
FROM --platform=linux/amd64 continuumio/miniconda3:23.3.1-0
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y sudo git

RUN conda create -n bptenv
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

ARG NB_USER=bpt_user
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

WORKDIR /
RUN git clone https://github.com/BackpropTools/BackpropTools
RUN mkdir -p /usr/local/include
RUN ln -s /BackpropTools/include/backprop_tools /usr/local/include/


# RUN apt-get update && apt-get install -y libhdf5-dev
# WORKDIR /BackpropTools
# RUN git submodule update --init --recursive -- external/highfive
# RUN mkdir /data
# WORKDIR /data
# RUN pip3 install numpy==1.22.4 datasets==2.11.0 h5py==3.7.0 Pillow==9.4.0
# RUN python3 /BackpropTools/examples/docker/00_basic_mnist/fetch_and_convert_mnist.py

RUN useradd -md ${HOME} -s /bin/bash -c "Default User" -u ${NB_UID} -U ${NB_USER} 
RUN echo "${NB_USER} ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
RUN usermod -aG sudo ${NB_USER}
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}

RUN chown -R ${NB_UID} /BackpropTools

# RUN apt-get update && apt-get install -y software-properties-common
# RUN add-apt-repository ppa:ppa-verse/xeus-cling
# RUN apt-get update && apt-get install -y cling


USER ${NB_USER}
WORKDIR /home/${NB_USER}



ENTRYPOINT ["/opt/conda/bin/conda", "run", "-n", "bptenv", "--no-capture-output", "--live-stream"]
