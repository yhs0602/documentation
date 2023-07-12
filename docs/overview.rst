.. include:: colors.rst
.. |run-on-binder| image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/BackpropTools/documentation/binder?labpath=01-Containers.ipynb

********
Overview
********

Code: `https://github.com/BackpropTools/BackpropTools <https://github.com/BackpropTools/BackpropTools>`_

Paper: `https://arxiv.org/abs/2306.03530 <https://arxiv.org/abs/2306.03530>`_

Live Demo (browser): `https://backprop.tools <https://backprop.tools>`_

Interactive Tutorial: |run-on-binder|

.. _Introduction:

Introduction
############

|BPT| stands for :bpt:`Backprop`\ agation :bpt:`Tools` paying tribute to the `Backpropagation <https://en.wikipedia.org/wiki/Backpropagation>`_ algorithm allowing the efficient calculation of gradients of functions with many inputs (neural network parameters are essentially inputs as well). Hence the Backpropagation algorithm is sitting at the core of the deep learning revolution. **BackpropTools** started out as a library for training and inference for small, fully-connected neural networks that can be tightly integrated with fast simulators running on GPUs to facilitate fast Reinforcement Learning (RL).

GPUs are based on massively parallel architectures consisting of thousands of small processing units which are usually Turing complete  but relatively limited in their general computing capabilities (e.g. usually slow for code that is branching a lot). In the future, deep learning accelerators might not even be Turing complete anymore because they become more specialized for deep learning workloads. For simulations of e.g. fluid or robot dynamics, turing completeness is essential though. Hence, |BPT| is designed to be tightly integrated with simulators on GPUs to run in a `SIMD <https://en.wikipedia.org/wiki/Single_instruction,_multiple_data>`_ fashion. GPU kernels are written in C/C++ and compiled through e.g. Nvidia CUDA with very limited support for existing libraries (not even the `C++ Standard Library <https://en.wikipedia.org/wiki/C%2B%2B_Standard_Library>`_ is fully supported), hence |BPT| is designed to be a dependency-free, header-only, pure C++ library.

|BPT| makes heavy use of the `template metaprogramming <https://en.wikipedia.org/wiki/Template_metaprogramming>`_ capabilities of recent C++ standards (C++17 in particular). This allows the code to be as generic as possible through the static multiple dispatch paradigm described in the accompanying `paper <https://arxiv.org/abs/2306.03530>`_ while allowing for maximum performance (7-13 times faster than other popular RL libraries at the time of writing). The outstanding performance is achieved through template metaprogramming which allows the size of all containers and loops to be known at compile-time and hence allows the compiler to heavily optimize the code through inlining and loop unrolling. We observed the unrolling of loops with up to 100 iterations in the case of **nvcc** (the CUDA compiler). 


.. _Features:

Key features
############

Over time, |BPT| has grown into a complete library for deep supervised and reinforcement learning:

Deep Learning
*************

   |BPT| provides deep learning functionality for fully-connected neural networks. In the future we plan to include further architectures like recurrent neural networks but for now our focus on fully connected architectures is supported by our analysis of the deep reinforcement learning landscape (in the `paper <https://arxiv.org/abs/2306.03530>`_). There we find that in deep RL for continuous control relatively small, fully-connected neural networks are by far the most commonly used architecture.

Simulation
**********

   |BPT| includes a fast dynamics simulator for a pendulum (equivalent to Pendulum-v1 from the `gym/gymnasium <https://gymnasium.farama.org/>`_ suite). The pendulum simulator is an example/template for the integration of other dynamics simulators. Future simulators we are planning on implementing include multirotor drones and racing cars. Furthermore we provide a high-performance, low-level `MuJoCo <https://mujoco.org/>`_ interface (about 25% faster than the state of the art `EnvPool <https://github.com/sail-sg/envpool>`_)

Reinforcement Learning
**********************

   |BPT| tightly integrates the deep learning and simulation components to provide highly performant reinforcement learning routines. We implement state of the art on- and off-policy RL algorithms in the form of `PPO <https://arxiv.org/abs/1707.06347>`_ and `TD3 <https://arxiv.org/abs/1802.09477>`_ and demonstrate that |BPT| enables faster training than other popular RL libraries in case of the pendulum and the MuJoCo Ant-v4 task (learning to walk a quadruped) (see `paper <https://arxiv.org/abs/2306.03530>`_).


.. _About this documentation:

About this documentation
########################

This documentation is structured as a series of interactive Jupyter notebooks using the C/C++ interpreter `Cling <https://github.com/root-project/cling>`_. The notebooks can be run on Binder using the links at the top of each one. Note that starting notebooks on Binder is convenient because all that is needed is a browser but they can take a long time or even fail to start. Alternatively you can also easily run this tutorial on you computer using Docker. Given that you have Docker installed and running you can clone this repository at a location of your choice:

.. code:: none

   git clone https://github.com/BackpropTools/documentation.git

.. code:: none

   cd documentation

Then we can build the Docker image. Note that as a pre-caution we are using `--no-cache` to make sure the clone of **BackpropTools** as well as package indices etc. are up to date. If you know what you are doing you can omit this flag to speed up repeated/incremental builds.

.. code:: none

   docker build . -t backprop_tools_docs --no-cache

Finally we can run the image and start a Jupyter server:

.. code:: none

   docker run -it --rm --platform linux/amd64 -p 8888:8888 backprop_tools_docs jupyter lab --ip 0.0.0.0

Open the link that is displayed in the CLI (``http://127.0.0.1:8888/...``) in your browser and enjoy tinkering with the tutorial! 
