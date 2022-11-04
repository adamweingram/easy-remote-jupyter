#!/usr/bin/env bash

# Set variables
CONDA_INSTALL_LOCATION="$(pwd)/software/conda"
export CONDA_INSTALL_LOCATION

CONDA_ENVIRONMENT_NAME="fvc-test"
export CONDA_ENVIRONMENT_NAME

CONDA_ENVIRONMENT_PYVERSION="3.7"
export CONDA_ENVIRONMENT_PYVERSION


# ---[ Anaconda Setup]---

# Install Anaconda
if [ ! -d "${CONDA_INSTALL_LOCATION}" ]; then
    echo "[INFO] Downloading latest Miniconda..."

    # Create the location where Miniconda will be installed
    mkdir -p "${CONDA_INSTALL_LOCATION}"

    # Go to the Miniconda install location
    pushd "${CONDA_INSTALL_LOCATION}" || exit

    # Download the install script
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

    # [TODO] Checksum the install script

    # Run the install script
    bash Miniconda3-latest-Linux-x86_64.sh -b -f -p "${CONDA_INSTALL_LOCATION}"
else
    echo "[INFO] Miniconda appears to have already been installed. Will not re-install."
    pushd "${CONDA_INSTALL_LOCATION}" || exit
fi

# Set up shell to work with conda
echo "[INFO] Setting up shell to work with conda..."
source "${CONDA_INSTALL_LOCATION}/etc/profile.d/conda.sh"

# Update Anaconda
echo "[INFO] Updating conda..."
conda upgrade -y conda

# Create & activate conda environment for benchmarks
echo "[INFO] Creating a new conda environment with the name: ${CONDA_ENVIRONMENT_NAME} and Python version: ${CONDA_ENVIRONMENT_PYVERSION}..."
conda create -y --name "${CONDA_ENVIRONMENT_NAME}" python="${CONDA_ENVIRONMENT_PYVERSION}"
conda activate "${CONDA_ENVIRONMENT_NAME}"

# Install dev packages
echo "[INFO] Installing developer dependencies..."
conda install -c conda-forge jupyterlab

# Exit conda directory
popd || exit


### End Tasks Section ###

echo ""
echo ""

echo "[INFO] To use the installed version of Miniconda in other shells, run this commmand:"
echo "$ source \"${CONDA_INSTALL_LOCATION}/etc/profile.d/conda.sh\""
echo ""

echo "[INFO] Refer to accompanying documentation for instructions on how to start using your new environment!"

echo ""

echo "### Done! ###"
