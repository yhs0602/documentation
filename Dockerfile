# This builder downloads and converts the MNIST dataset to HDF5
FROM --platform=linux/amd64 mambaorg/micromamba:1.4.6-jammy AS builder

# RUN micromamba install -y -n base -c conda-forge numpy datasets h5py Pillow
# RUN micromamba env export -n base > /home/mambauser/environment_builder.yml

COPY environment_builder.yml /home/mambauser/environment_builder.yml
RUN micromamba install -y -f /home/mambauser/environment_builder.yml -n base

USER root
RUN apt-get update && apt-get install -y git
RUN echo "c2202fb73de7a92c12a81a1087047e2df021e1bb" > /rl_tools_commit # because ARG does not invalidate the build cache
WORKDIR /
RUN git clone https://github.com/rl-tools/rl-tools rl_tools
WORKDIR /rl_tools
RUN git checkout $(cat /rl_tools_commit)
ARG MAMBA_DOCKERFILE_ACTIVATE=1
WORKDIR /
RUN python3 /rl_tools/examples/docker/00_basic_mnist/fetch_and_convert_mnist.py
USER mambauser

FROM --platform=linux/amd64 mambaorg/micromamba:1.4.6-jammy
ENV DEBIAN_FRONTEND=noninteractive
COPY --from=builder /home/mambauser/environment_builder.yml /environment_builder.yml

USER root
RUN apt-get update && apt-get install -y git
USER mambauser

# RUN micromamba install -y -n base -c conda-forge xeus-cling \
# xcanvas \
# hdf5 openblas \
# jupyterlab notebook jupyterlab_vim
# USER root
# RUN micromamba env export -n base > /environment.yml
# USER mambauser

# freezing env:
# ./run_bash.sh
# cp /environment.yml . && cp /environment_builder.yml .
# comment out the above
# comment in the below

COPY environment.yml /
RUN micromamba install -y -f /environment.yml -n base

USER root
COPY --from=builder /rl_tools_commit /rl_tools_commit
WORKDIR /
RUN git clone https://github.com/rl-tools/rl-tools rl_tools
RUN mkdir -p /usr/local/include
RUN ln -s /rl_tools/include/rl_tools /usr/local/include/
WORKDIR /rl_tools
RUN git checkout $(cat /rl_tools_commit)
RUN git submodule update --init --recursive -- external/highfive
COPY --from=builder /mnist.hdf5 /data/mnist.hdf5
USER mambauser

WORKDIR /home/mambauser
RUN mkdir docs
COPY docs/*.ipynb ./docs/
COPY docs/images/ ./docs/images
WORKDIR docs

ENV LD_LIBRARY_PATH=/opt/conda/lib
ENV C_INCLUDE_PATH="/usr/local/include:/opt/conda/include:/rl_tools/external/highfive/include"
ENV CPLUS_INCLUDE_PATH="/usr/local/include:/opt/conda/include:/rl_tools/external/highfive/include"