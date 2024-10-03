.. include:: colors.rst

Getting Started
===================================================
This guide gets you started on multiple platforms.

- **Step 1**: :ref:`Clone the Repository <clone-repository>`
- **Step 2**: :ref:`Run Container (Docker only) <run-docker-container>`
- **Step 3**: Install Dependencies
    - :ref:`Docker & Ubuntu & WSL <install-dependencies-docker-ubuntu-wsl>`
    - :ref:`macOS <install-dependencies-macos>`
- **Step 4**: :ref:`Configure and Build the Targets (all platforms) <configure-and-build>`
- **Step 5**: :ref:`Run an Experiment <run-experiment>`
- **Step 6**: :ref:`Visualize the Results <visualize>`

.. _clone-repository:

Step 1: Clone the Repository
-----------------------------

.. code-block:: bash

    git clone https://github.com/rl-tools/rl-tools.git

**Note**:
    We don't encourage using the ``--recursive`` flag because we are maintaining |RLT| as a monorepo and some of the submodules contain large files (e.g. data for unit tests or redistributable binaries for releases). |RLT| is designed as a header-only and dependency-free library but for some convenience features like Tensorboard logging, or gzipped checkpointing, additional dependencies are required. We prefer to vendor them as versioned submodules in ``./external`` and they can be instantiated selectively using ``git submodule update --init --recursive -- external/<submodule>``.


.. _run-docker-container:

**Step 2: Run Container (Docker only)**
----------------------------------------

Run a Docker container from the cloned directory:

.. code-block:: bash

    cd rl-tools
    docker run -it --rm -p 8000:8000 --mount type=bind,source=$(pwd),target=/rl_tools,readonly ubuntu:24.04

- ``-p 8000:8000``: **Optional**. Exposes port ``8000`` such that you can use the :doc:`Experiment Tracking <10-Experiment Tracking>` facilities. This exposes a static web server that gives access to a browser-based interface to watch environment rollouts.
- ``--mount type=bind,source=$(pwd),target=/rl_tools,readonly``: We mount the current directory (checked out repository) to ``/rl_tools`` in the container. We use the ``readonly`` flag to ensure a clean, out-of-tree build. The files can still be edited on the host machine using your editor or IDE of choice.
- ``ubuntu:24.04``: We use Ubuntu for this demonstration because of its wide-spread use and familiarity. Due to the minimal requirements of |RLT| (basically only a C++ compiler and CMake and possibly a BLAS library to speed up matrix multiplications) it can also be used on virtually any other system (Windows, macOS and other Linux distros)

Step 3: Install Dependencies
-----------------------------

.. _install-dependencies-docker-ubuntu-wsl:

Docker & Ubuntu & WSL
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

    apt update
    DEBIAN_FRONTEND=noninteractive
    apt install -y build-essential cmake libopenblas-dev python3

- ``DEBIAN_FRONTEND=noninteractive``: Suppresses interactive prompts during package installation (for convenience)

- ``apt install -y``: Installs several dependencies

    - ``build-essential``: Installs the C++ compiler

    - ``cmake``: CMake to configure the different example targets and call the compiler

    - ``libopenblas-dev``: **Optional**. Lightweight BLAS library that provides fast matrix multiplication implementations. Required for the ``-DRL_TOOLS_BACKEND_ENABLE_OPENBLAS=ON`` option. About 10x faster than with the generic implementations that are used by default (when the option is absent). By using a more tailored BLAS library like Intel MKL you might be able to get another ~2x speed improvement

    - ``python3``: **Optional**. Python is used in ``serve.sh`` to host a simple static HTTP server that visualizes the environments during and after training.


.. _install-dependencies-macos:

macOS
~~~~~~~~~~~~~

Install the Xcode command line tools:

.. code-block:: bash

    xcode-select --install
    brew install cmake

.. _configure-and-build:

Step 4: Configure and Build the Targets
-----------------------------------------

**Note**:
    For macOS, replace ``-DRL_TOOLS_BACKEND_ENABLE_OPENBLAS=ON`` with ``-DRL_TOOLS_BACKEND_ENABLE_ACCELERATE=ON``

.. code-block:: bash

   mkdir build && cd build
   cmake /rl_tools -DCMAKE_BUILD_TYPE=Release -DRL_TOOLS_ENABLE_TARGETS=ON -DRL_TOOLS_BACKEND_ENABLE_OPENBLAS=ON
   cmake --build .


- ``cmake /rl_tools``: Using CMake to configure the examples contained in the |RLT| project. The main suit of (tuned) environment configurations we are using is the |RLT| zoo (see `https://zoo.rl.tools <https://zoo.rl.tools>`_ for trained agents and learning curves).

- ``-DCMAKE_BUILD_TYPE=Release``: Sets the build type to ``Release`` to optimize the build for performance (expect a large difference compared to without it).
- ``-DRL_TOOLS_ENABLE_TARGETS=ON``: Enables the building of the example targets. These are turned off by default such that they don't clutter projects that just include |RLT| as a library and do not want to build the examples.
- ``-DRL_TOOLS_BACKEND_ENABLE_OPENBLAS=ON``: Enables the OpenBLAS backend, allowing RL_Tools to utilize OpenBLAS for matrix multiplications (~10x faster than using the generic implementations that are automatically used in the absence of this flag).
- ``cmake --build .``: Builds the targets. You can use an additional e.g. ``-j4`` to speed up the build using 4 parallel threads.

.. _run-experiment:

Step 5: Run an Experiment
---------------------------

Execute e.g. the |RLT| Zoo example using SAC to train the Learning to Fly (l2f) environment.

.. code-block:: bash

   ./src/rl/zoo/rl_zoo_sac_l2f

You can use ``cmake --build . --target help`` to list the available targets.

.. _visualize:

Step 6: Visualize the Results
------------------------------

During the experiment the training loop emits checkpoints and recorded trajectories a s well as Javscript rendering instructions in the experiment folder following the :doc:`Experiment Tracking <10-Experiment Tracking>` conventions. You can browse the ``experiments`` folder which contains the runs to inspect the checkpoints and other data. |RLT| includes a simple web-based UI to visualize these results. To expose the experiment data through the forwarded port of the docker container we copy the files that constitute the web interface into the docker container such that a simple, static HTTP server can expose them together with the experiment data.

.. code-block:: bash

   cp -r /rl_tools/static .
   /rl_tools/serve.sh

After copying the UI files we run ``serve.sh`` which periodically builds an index file containing a list of all experiment files such that the web UI can find them. It also starts a simple Python-based HTTP server on port ``8000``. Now you should be able to navigate to `http://localhost:8000 <http://localhost:8000>`_ and view the visualizations of the training runs.