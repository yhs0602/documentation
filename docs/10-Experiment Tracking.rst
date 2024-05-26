RLtools Experiment Tracking Interface Specification
===================================================

The experiments follow the hierarchical, filesystem-based RLtools experiment tracking API.

Run Identifier
--------------

Each run is characterized by the following path/identifier structure:

.. code-block:: python

{TIME}/{COMMIT}_{NAME}_{POPULATION}/{CONFIG}/{SEED}**


e.g.

    ./2024-05-26_06-26-52/4f717cb_zoo_algorithm_environment/sac_pendulum-v1/0000

This makes it very easy to sort, filter and analyze the experiments with just unix tools like "find", "sort", "grep" and "jq".

- **{TIME}**: e.g. "2024-05-26_06-26-52"
  - **TIME**: The time when the experiment was executed. The time is the most significant component to facilitate lexicographical sorting (e.g. "find . | sort")
- **{COMMIT}_{NAME}_{POPULATION}**: e.g. "4f717cb_zoo_algorithm_environment"
  - **COMMIT**: The first 7 hexadecimal places of the commit hash
  - **NAME**: Name of the experiment. The "return.json" should be in a consistent per **EXPERIMENT_NAME**
  - **POPULATION**: The variables that are tested in this experiment (separated by an underscore)
- **{CONFIG}**: e.g. "sac_pendulum-v1"
  - **CONFIG**: The values of the previously mentioned **POPULATION** variables for a particular experiment configuration
- **{SEED}**: e.g. "1337"
  - **SEED**: The seed for a particular run of the previously described configuration

Run Contents
------------

Per run
~~~~~~~

Each run can contain different files that apply to the whole run, e.g.:

- **return.json**: The return value of the experiment. The structure and semantics of this file depend on the **{NAME}**. The existence of this file signals that the experiment is finished.
- **config.json**: Optional. Additional configuration
- **logs.tfevents**: Optional. Tensorboard logs
- **ui.js**/**ui.esm.js**: Optional. Render function for the UI (see https://studio.rl.tools for more info). This allows collected trajectories to be rendered

Per run
~~~~~~~

Additionally each run can store files at different stages of the run (corresponding to "steps" of the `Loop Interface <https://docs.rl.tools/07-The%20Loop%20Interface.html>`_)

- **steps**: Directory to separate the step contents from the full-run contents
  - **{STEP}**: e.g. "000000000012000"
    - **checkpoint.h**: Checkpoint exported as a C++ header file such that it can be compiled into e.g. the firmware of a microcontroller.
    - **checkpoint.h5**: Checkpoint exported as an HDF5 file.
    - **trajectories.json**/**trajectories.json.gz**: Trajectories from the evaluation loop step. These trajectories contain state, action, reward and termination signal as JSON objects and hence are compatible with the render function from "ui.js"
    - **evaluation_results.json**: Statistics (episode length and return) of the evaluation step
