# FROM --platform=linux/amd64 continuumio/miniconda3:23.3.1-0-alpine
# FROM --platform=linux/amd64 continuumio/miniconda3:23.3.1-0
FROM --platform=linux/amd64 mambaorg/micromamba:1.4.6-jammy
ENV DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update && apt-get install -y sudo git
USER mambauser

# RUN micromamba create -n bptenv
# RUN micromamba install -n base -c conda-forge xeus-cling 
# RUN micromamba install -n base -c conda-forge jupyterlab notebook

# freezing env:
# ./run_bash.sh
# micromamba env export -n base > environment.yml
# comment out the above
# comment in the below

COPY environment.yml .
RUN micromamba install -y -f environment.yml -n base


# RUN git clone https://github.com/jupyter-xeus/xeus-cling.git
# WORKDIR xeus-cling
# RUN git checkout 0.15.1
# RUN mkdir build
# WORKDIR build
# ENV CONDA_PREFIX=/opt/conda/envs/bptenv/
# RUN conda run -n bptenv cmake -D CMAKE_INSTALL_PREFIX=${CONDA_PREFIX} -D CMAKE_INSTALL_LIBDIR=${CONDA_PREFIX}/lib ..
# RUN conda run -n bptenv make -j$(nproc) && make install
# WORKDIR /

# ARG NB_USER=bpt_user
# ARG NB_UID=1000
# ENV USER ${NB_USER}
# ENV NB_UID ${NB_UID}
# ENV HOME /home/${NB_USER}

USER root
WORKDIR /
RUN git clone https://github.com/BackpropTools/BackpropTools
RUN mkdir -p /usr/local/include
RUN ln -s /BackpropTools/include/backprop_tools /usr/local/include/
USER mambauser


# RUN apt-get update && apt-get install -y libhdf5-dev
# WORKDIR /BackpropTools
# RUN git submodule update --init --recursive -- external/highfive
# RUN mkdir /data
# WORKDIR /data
# RUN pip3 install numpy==1.22.4 datasets==2.11.0 h5py==3.7.0 Pillow==9.4.0
# RUN python3 /BackpropTools/examples/docker/00_basic_mnist/fetch_and_convert_mnist.py

# RUN useradd -md ${HOME} -s /bin/bash -c "Default User" -u ${NB_UID} -U ${NB_USER} 
# RUN echo "${NB_USER} ALL=(ALL) NOPASSWD:ALL" | tee -a /etc/sudoers
# RUN usermod -aG sudo ${NB_USER}
# COPY . ${HOME}
# USER root
# RUN chown -R ${NB_UID} ${HOME}

# RUN chown -R ${NB_UID} /BackpropTools

# RUN apt-get update && apt-get install -y software-properties-common
# RUN add-apt-repository ppa:ppa-verse/xeus-cling
# RUN apt-get update && apt-get install -y cling


# USER ${NB_USER}
# WORKDIR /home/${NB_USER}



# ENTRYPOINT ["/opt/conda/bin/conda", "run", "-n", "bptenv", "--no-capture-output", "--live-stream"]
