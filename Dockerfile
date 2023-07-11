FROM --platform=linux/amd64 mambaorg/micromamba:1.4.6-jammy
ENV DEBIAN_FRONTEND=noninteractive

USER root
RUN apt-get update && apt-get install -y git
USER mambauser

RUN micromamba install -y -n base -c conda-forge xeus-cling \
numpy datasets h5py Pillow openblas \
jupyterlab notebook jupyterlab_vim


# freezing env:
# ./run_bash.sh
# micromamba env export -n base > environment.yml
# comment out the above
# comment in the below

# COPY environment.yml .
# RUN micromamba install -y -f environment.yml -n base

USER root
RUN echo "8ef762e7fea267c2a7a5a1c0b024dc56b3a93eb5" > /backprop_tools_commit # because ARG does not invalidate the build cache
WORKDIR /
RUN git clone https://github.com/BackpropTools/BackpropTools
RUN mkdir -p /usr/local/include
RUN ln -s /BackpropTools/include/backprop_tools /usr/local/include/
WORKDIR /BackpropTools
RUN git checkout $(cat /backprop_tools_commit)
RUN git submodule update --init --recursive -- external/highfive
RUN mkdir /data
WORKDIR /data
ARG MAMBA_DOCKERFILE_ACTIVATE=1
RUN python3 /BackpropTools/examples/docker/00_basic_mnist/fetch_and_convert_mnist.py
USER mambauser

WORKDIR /home/mambauser
RUN mkdir docs
COPY docs/*.ipynb ./docs/
COPY docs/images/ ./docs/images
WORKDIR docs

ENV LD_LIBRARY_PATH=/opt/conda/lib
ENV C_INCLUDE_PATH="/usr/local/include:/opt/conda/include:/BackpropTools/external/highfive/include"
ENV CPLUS_INCLUDE_PATH="/usr/local/include:/opt/conda/include:/BackpropTools/external/highfive/include"