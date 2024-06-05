.. include:: colors.rst
.. |run-on-binder| image:: https://mybinder.org/badge_logo.svg
   :target: https://mybinder.org/v2/gh/rl-tools/documentation/binder?labpath=01-Containers.ipynb

.. |run-on-colab| image:: https://colab.research.google.com/assets/colab-badge.svg
   :target: https://colab.research.google.com/github/rl-tools/documentation/blob/master/docs/09-Python%20Interface.ipynb

********
Overview
********

Code: `https://github.com/rl-tools/rl-tools <https://github.com/rl-tools/rl-tools>`_

Paper: `https://arxiv.org/abs/2306.03530 <https://arxiv.org/abs/2306.03530>`_

Live Demo (browser): `https://rl.tools <https://rl.tools>`_

Interactive Tutorial: |run-on-binder| |run-on-colab|

.. _Introduction:

Introduction
############

|RLT| stands for :rlt:`R`\ einforcement :rlt:`L`\ earning :rlt:`tools` and is a highly optimized C++ deep reinforcement learning library for continuous control. 
|RLT| started out as a library for training and inference for small, fully-connected neural networks that can be tightly integrated with fast simulators running on GPUs to facilitate fast Reinforcement Learning (RL) but has grown to become a full-featured library for applying RL to continuous control problems. The goal of |RLT| is now to become the `acados <https://github.com/acados/acados>`_ equivalent for deep reinforcement learning. Acados is a library for Model Predictive Control (MPC) and makes contains robust, established optimization algorithms and transcription methods available to a broad userbase in e.g. robotics, automotive, aerospace and other fields. Similarly, |RLT| provides state-of-the-art deep RL algorithms as well as highly optimized deep learning components and simulation (interfaces) ready for application to a diverse set of continuous control problems. In contrast to other RL libraries |RLT| aims at fast iteration in the problem space, while other RL libraries often focus on modularity and abstractions to facilitate research in the space of algorithms. We believe deep RL methods can overcome long-standing issues with classical and optimization based control methods but acknowledge that there are major issues preventing broad adoption. A major problem are the long training times, especially considering the amount of hyperparameter tuning and reward function design that is required to train good policies. Hence |RLT| aims at drastically reducing the training times by heavily optimizing the implementations and also taking advantage of accelerated hardware like GPUs.

GPUs are based on massively parallel architectures consisting of thousands of small processing units which are usually Turing complete  but relatively limited in their general computing capabilities (e.g. usually slow for code that is branching a lot). In the future, deep learning accelerators might not even be Turing complete anymore because they become more specialized for deep learning workloads. For simulations of e.g. fluid or robot dynamics, turing completeness is essential though. Hence, |RLT| is designed to be tightly integrated with simulators on GPUs to run in a `SIMD <https://en.wikipedia.org/wiki/Single_instruction,_multiple_data>`_ fashion. GPU kernels are written in C/C++ and compiled through e.g. Nvidia CUDA with very limited support for existing libraries (not even the `C++ Standard Library <https://en.wikipedia.org/wiki/C%2B%2B_Standard_Library>`_ is fully supported), hence |RLT| is designed to be a dependency-free, header-only, pure C++ library.

|RLT| makes heavy use of the `template metaprogramming <https://en.wikipedia.org/wiki/Template_metaprogramming>`_ capabilities of recent C++ standards (C++17 in particular). This allows the code to be as generic as possible through the static multiple dispatch paradigm described in the accompanying `paper <https://arxiv.org/abs/2306.03530>`_ while allowing for maximum performance (7-13 times faster than other popular RL libraries at the time of writing). The outstanding performance is achieved through template metaprogramming which allows the size of all containers and loops to be known at compile-time and hence allows the compiler to heavily optimize the code through inlining and loop unrolling. We observed the unrolling of loops with up to 100 iterations in the case of **nvcc** (the CUDA compiler). 


.. _Features:

Key features
############

Over time, |RLT| has grown into a complete library for deep supervised and reinforcement learning:

Deep Learning
*************

   |RLT| provides deep learning functionality for fully-connected neural networks. In the future we plan to include further architectures like recurrent neural networks but for now our focus on fully connected architectures is supported by our analysis of the deep reinforcement learning landscape (in the `paper <https://arxiv.org/abs/2306.03530>`_). There we find that in deep RL for continuous control relatively small, fully-connected neural networks are by far the most commonly used architecture.

Simulation
**********

   |RLT| includes a fast dynamics simulator for a pendulum (equivalent to Pendulum-v1 from the `gym/gymnasium <https://gymnasium.farama.org/>`_ suite). The pendulum simulator is an example/template for the integration of other dynamics simulators. Future simulators we are planning on implementing include multirotor drones and racing cars. Furthermore we provide a high-performance, low-level `MuJoCo <https://mujoco.org/>`_ interface (about 25% faster than the state of the art `EnvPool <https://github.com/sail-sg/envpool>`_)

Reinforcement Learning
**********************

   |RLT| tightly integrates the deep learning and simulation components to provide highly performant reinforcement learning routines. We implement state of the art on- and off-policy RL algorithms in the form of `PPO <https://arxiv.org/abs/1707.06347>`_ and `TD3 <https://arxiv.org/abs/1802.09477>`_ and demonstrate that |RLT| enables faster training than other popular RL libraries in case of the pendulum and the MuJoCo Ant-v4 task (learning to walk a quadruped) (see `paper <https://arxiv.org/abs/2306.03530>`_).

Deployment
**********************
   The design of |RLT| allows easy deployment of trained policies directly onto microcontrollers. |RLT| also contains highly optimized inference routines for a broad class of microcontrollers. Furthermore, |RLT| has been used to demonstrate the first ever training of a deep RL algorithm directly on a microcontroller. The latter proof of concept could be the spark igniting the field of tinyRL where deep RL agents are directly trained on limited edge hardware. 

.. _About this documentation:

About this documentation
########################

This documentation is structured as a series of interactive Jupyter notebooks using the C/C++ interpreter `Cling <https://github.com/root-project/cling>`_. The notebooks can be run on Binder using the links at the top of each one. Note that starting notebooks on Binder is convenient because all that is needed is a browser but they can take a long time or even fail to start. Alternatively you can also easily run this tutorial on you computer using Docker. Given that you have `Docker installed <https://docs.docker.com/engine/install/>`_ and running you can run our pre-built container by:

.. code:: none

   docker run -p 8888:8888 rltools/documentation 

Open the link that is displayed in the CLI (``http://127.0.0.1:8888/...``) in your browser and enjoy tinkering with the tutorial! 