#!/usr/bin/env bash

# Exit script on error
set -e 

# Set environment variables
export PYTHON_SRC_LOCATION="$(pwd)/setup/pysrc"
export PYTHON_INSTALL_LOCATION="$(pwd)/software/python"
export PYTHON_FULL_VERSION="3.7.10"


### Set up necessary directories ###
mkdir -p "${PYTHON_INSTALL_LOCATION}"


### Python Section ###

echo "### Preparing Python ###"
echo ""

# Download and unzip if necessary
if [ ! -d "${PYTHON_SRC_LOCATION}" ]; then
	echo "[INFO] Downloading & unarchiving Python source code..."

    # Create the source directory if it doesn't already exist
    mkdir -p "${PYTHON_SRC_LOCATION}"

    # Go to the Python source storage directory
	pushd "${PYTHON_SRC_LOCATION}" || exit

    # Download the specified version of Python source and unarchive
	wget -c "https://www.python.org/ftp/python/${PYTHON_FULL_VERSION}/Python-${PYTHON_FULL_VERSION}.tgz" \
        -O - | tar -xz --directory "${PYTHON_SRC_LOCATION}" --strip-components=1

    # Leave the Python source storage directory
	popd || exit

elif [ -d "${PYTHON_SRC_LOCATION}" ]; then
	echo "[INFO] Python source has already been downloaded; will not re-download."
fi

# Build and install if necessary
if [ ! -f "${PYTHON_INSTALL_LOCATION}/bin/python3" ]; then
	echo "[INFO] Didn't find Python binary, will build and install..."

    # Go to the python source directory
	pushd "${PYTHON_SRC_LOCATION}" || exit
	
    # Configure the build
	echo "[INFO] Configuring Python compile..."
	./configure --prefix="${PYTHON_INSTALL_LOCATION}" --enable-optimizations --with-ensurepip=install
	
    # Build Python from source
	echo "[INFO] Building Python..."
	make -j
	
    # Install Python in the install directory
	echo "[INFO] Installing Python in ${PYTHON_INSTALL_LOCATION}"
	make install

    # Exit the Python source directory
	popd || exit

elif [ -f "${PYTHON_INSTALL_LOCATION}/bin/python3" ]; then
	echo "[INFO] Found Python binary; will not re-build or re-install."
fi

# Update PATH to include installed Python version
echo "[INFO] Updating PATH to include installed Python..."
export PATH="${PYTHON_INSTALL_LOCATION}/bin:${PATH}"

echo ""
echo ""

echo "[INFO] To use the new version of Python in other shells, update your PATH with this commmand:"
echo "$ export PATH=${PYTHON_INSTALL_LOCATION}/bin:\$PATH"

echo ""

### End Tasks Section ###
echo ""

echo "### Done! ###"
