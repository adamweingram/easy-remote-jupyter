# Project Environment Setup

This document will explain how to set up a JupyterLab-enabled Python environment on a remote server (like Pinto) that you can access from your local machine. Eventually, we will probably have some kind of environment set up specifically for our project. This is a more general guide.

## On the Server

1. SSH into the server (nothing special here).

    ```bash
    ssh your_username@example_server.edu
    ```

2. Navigate to the location you wish to install software at:

    ```bash
    cd /my/location
    ```

3. Clone this repository:

    ```bash
    git clone [TODO] project-environment
    ```

4. Navigate to the freshly-cloned repository

    ```bash
    cd project-environment
    ```

### (Option 1) Use Standard Python

If you want to avoid the chaos that is Ana/Miniconda, in most cases you can probably just use standard Python + `pip`. The steps to do so are given below:

1. Build Python from source using the provided script (Note: This can take a while as Python needs to run some tests on your system to properly optimize your install). You can edit the environment variables defined in `build-python.sh` to customize your installation.

    - If on a standard system:

        ```bash
        ./build-python.sh
        ```

    - If on a [SLURM](https://slurm.schedmd.com/documentation.html)-enabled system (you will have to adjust the parameters to work with your cluster):

        ```bash
        sbatch \
            --partition "main" \
            --nodes 1 \
            --ntasks=1 \
            --cpus-per-task=16 \
            --mem=65536 \
            --job-name="build_python" \
            --output="python_build.out" \
            --time="05:00:00" \
            ./build-python.sh
        ```

2. Add the correct version of Python to your PATH:

    **NOTE:** Replace `<your Python install path>` with the [absolute path](https://docs.oracle.com/javase/tutorial/essential/io/path.html) of your Python install. The `/bin` appended to the end is very important! Don't leave that off.

    You should be able to copy/paste this from the output of the Python install script (it will tell you exactly which command to run).

    ```bash
    export PATH=<your Python install path>/bin:$PATH
    ```

3. Verify you can access the correct version of Python:

    ```bash
    which python3
    ```

    If you just installed Python, `python3` should point to that install! If it points to the default system interpreter, there may have been an issue when you modified your `PATH`.

4. Navigate to your project location:

    ```bash
    cd /my/project/location
    ```

5. Create a new Python virtual environment titled 'venv':

    ```bash
    python3 -m venv venv
    ```

6. Activate the virtual environment:

    ```bash
    source ./venv/bin/activate
    ```

7. Update pip:

    ```bash
    python3 -m pip install --upgrade pip
    ```

8. Install project dependencies using the `requirements.txt` file:

    ```bash
    pip3 install -r requirements.txt
    ```

### (Option 2) Use Miniconda

1. Install Miniconda using the provided script (Note: this can take a while). You can edit the environment variables defined in `build-python.sh` to customize your installation.

    - If on a standard system:

        ```bash
        ./build-conda.sh
        ```

    - If on a [SLURM](https://slurm.schedmd.com/documentation.html)-enabled system (you will have to adjust the parameters to work with your cluster):

        ```bash
        sbatch \
            --partition "main" \
            --nodes 1 \
            --ntasks=1 \
            --cpus-per-task=8 \
            --mem=16384 \
            --job-name="build_conda" \
            --output="conda_install.out" \
            --time="05:00:00" \
            ./build-conda.sh
        ```

2. Run conda shell integration:

    **NOTE:** Replace `<your conda install path>` with the path with the [absolute path](https://docs.oracle.com/javase/tutorial/essential/io/path.html) of your conda install. The `/etc/profile.d/conda.sh` appended to the end is very important! Don't leave that off.

    You should be able to copy/paste this from the output of the Miniconda install script (it will tell you exactly which command to run).

    ```bash
    source "<your conda install path>/etc/profile.d/conda.sh"
    ```

3. Navigate to your project location:

    ```bash
    cd /my/project/location
    ```

4. Activate the virtual environment created by the conda build script:

    **NOTE:** Replace `<your conda environment name>` with the environment name defined at the top of the `build-conda.sh` script.

    ```bash
    conda activate <your conda environment name>
    ```

5. Install project dependencies using the `requirements.txt` file:

    ```bash
    conda install --file requirements.txt
    ```

### Start Jupyter Lab

Now that your environment is set up, we can start the Jupyter Lab server so that you can access and run notebooks remotely.

1. Make sure you have Jupyter Lab installed:
    - **If you used standard Python:**

        ```bash
        pip3 install jupyterlab
        ```

    - **If you used Miniconda:**

        ```bash
        conda install -c conda-forge jupyterlab
        ```

2. Start Jupyter Lab. Make to choose a port number that nobody else is using (and replace `<your port number>` with your choice). Usually, this is a **4-digit** number such as `4273`.

    ```bash
    jupyter lab --ip=0.0.0.0 --port=<your port number>
    ```

3. Jupyter will output a bunch of information. **You will need to take note of the "token" as you'll need it to sign into your Jupyter Lab environment!** For example, if my output looks like this:

    ```log
    ...

    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=f29d7ffe0a0726cba964436e0f63b01699e41e9efec67924
     or http://127.0.0.1:8888/lab?token=f29d7ffe0a0726cba964436e0f63b01699e41e9efec67924
    ```

    I know that my token is:

    ```log
    f29d7ffe0a0726cba964436e0f63b01699e41e9efec67924
    ```

## On Your Machine

1. Use SSH to forward requests from your local machine to Jupyter running on the server. Replace `<your port number>` with the port number you chose in Step 2 of the ["Start Jupyter Lab"](#start-jupyter-lab) section.

    ```bash
    ssh -R <your port number>:localhost:<your port number> <username>@<server hostname>
    ```

2. **(Option 1)** Connect to your Jupyter Lab instance through your browser by navigating to the following URL. Make sure to replace `<your port number>` and `<your token>` with the appropriate values.

    ```text
    http://localhost:<your port number>/lab?token=<your token>
    ```

    You should see the Jupyter Lab interface!

3. **(Option 2)** Connect to your Jupyter Lab instance with Visual Studio Code. Refer to the [VS Code documentation](https://code.visualstudio.com/docs/datascience/jupyter-notebooks#_connect-to-a-remote-jupyter-server).
