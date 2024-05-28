Experiment Tracking Interface Specification
===================================================

.. epigraph::

   "Strava but for training runs."

   -- RLtools contributor

The experiments follow the hierarchical, filesystem-based experiment tracking interface. We follow the `UNIX` philosophy and expose it through the filesystem.
This makes it very easy to sort, filter and analyze the experiments with just unix tools like ``find``, ``sort``, ``grep`` and ``jq``. Additionally it also allows easy monitoring through a static website like https://zoo.rl.tools where experiment results are automatically made accessible by our continuous integration.

Run Identifier
---------------

Each run is characterized by the following path/identifier structure:

.. code-block:: none

    {TIME}/{COMMIT}_{NAME}_{POPULATION}/{CONFIG}/{SEED}


e.g.

.. code-block:: none

    2024-05-26_06-26-52/4f717cb_zoo_algorithm_environment/sac_pendulum-v1/0000

- **{TIME}**: e.g. ``2024-05-26_06-26-52``

  - **TIME**: The time when the experiment was executed. The time is the most significant component to facilitate lexicographical sorting (e.g. ``find . | sort``)

- **{COMMIT}_{NAME}_{POPULATION}**: e.g. ``4f717cb_zoo_algorithm_environment``

  - **COMMIT** (e.g. ``4f717cb``: The first 7 hexadecimal places of the commit hash

  - **NAME** (e.g. ``zoo``): Name of the experiment. The ``return.json`` should be in a consistent per **NAME**

  - **POPULATION** (e.g. ``algorithm_environment``): The variables that are varied/tested in this experiment (separated by underscores)

- **{CONFIG}**: e.g. ``sac_pendulum-v1``

  - **CONFIG**: The values of the previously mentioned **POPULATION** variables for a particular experiment configuration, separated by underscores. In combination with the previous population setup, this yields e.g. ``{"algorithm": "sac", "environment": "pendulum-v1"}``

- **{SEED}**: e.g. ``1337``

  - **SEED**: The seed for a particular run of the previously described configuration

Run Contents
------------

Per Run
~~~~~~~

Each run can contain different files that apply to the whole run, e.g.:

.. code-block:: none

    2024-05-26_06-26-52/4f717cb_zoo_algorithm_environment/sac_pendulum-v1/0000/return.json
    2024-05-26_06-26-52/4f717cb_zoo_algorithm_environment/sac_pendulum-v1/0000/logs.tfevents

- **return.json**: The return value of the experiment. The structure and semantics of this file depend on the **{NAME}**. The existence of this file signals that the experiment is finished.
- **config.json** (`optional`): Additional configuration
- **logs.tfevents** (`optional`): Tensorboard logs
- **ui.js**/**ui.esm.js** (`optional`): Render function for the UI (see https://studio.rl.tools for more info). This allows collected trajectories to be rendered

Per Step
~~~~~~~

Additionally each run can store files at different stages of the run (corresponding to "steps" of the `Loop Interface <https://docs.rl.tools/07-The%20Loop%20Interface.html>`_) e.g.:

.. code-block:: none

    2024-05-26_06-26-52/4f717cb_zoo_algorithm_environment/sac_pendulum-v1/0000/steps/000000000012000/checkpoint.h5
    2024-05-26_06-26-52/4f717cb_zoo_algorithm_environment/sac_pendulum-v1/0000/steps/000000000012000/trajectories.json

- **steps**: Directory to separate the step contents from the full-run contents

  - **{STEP}**: e.g. ``000000000012000``

    - **checkpoint.h** (`optional`): Checkpoint exported as a C++ header file such that it can be compiled into e.g. the firmware of a microcontroller.
    - **checkpoint.h5** (`optional`): Checkpoint exported as an HDF5 file.
    - **trajectories.json**/**trajectories.json.gz** (`optional`): Trajectories from the evaluation loop step. These trajectories contain state, action, reward and termination signal as JSON objects and hence are compatible with the render function from ``ui.js``
    - **evaluation_results.json** (`optional`): Statistics (episode length and return) of the evaluation step
