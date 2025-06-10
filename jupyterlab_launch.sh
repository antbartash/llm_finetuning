#!/bin/bash
set -euo pipefail  # Exit on error, undefined var, or pipe failure

# Update package index
echo "Updating package list..."
sudo apt-get update -y

# Install python3-venv if not already installed
echo "Checking for python3-venv..."
if ! dpkg -s python3-venv >/dev/null 2>&1; then
    echo "Installing python3-venv..."
    sudo apt-get install python3-venv -y
else
    echo "python3-venv is already installed."
fi

# Install python3-pip (provides pip3) if not already installed
echo "Checking for python3-pip..."
if ! dpkg -s python3-pip >/dev/null 2>&1; then
    echo "Installing python3-pip..."
    sudo apt-get install python3-pip -y
else
    echo "python3-pip is already installed."
fi

# Verify pip3 is available
if ! command -v pip3 >/dev/null 2>&1; then
    echo "ERROR: pip3 not found after installation. Exiting."
    exit 1
fi
echo "pip3 is installed."

# Create the virtual environment 'myenv' if it doesn't exist
if [ ! -d "myenv" ]; then
    echo "Creating Python virtual environment 'myenv'..."
    python3 -m venv myenv
else
    echo "Virtual environment 'myenv' already exists."
fi

# Activate the virtual environment
echo "Activating virtual environment..."
# shellcheck disable=SC1091
source myenv/bin/activate

# Upgrade pip inside the venv (optional but recommended)
echo "Upgrading pip in virtual environment..."
pip install --upgrade pip

# Install Jupyter-related Python packages
echo "Installing Jupyter packages (notebook, jupyterlab, ipykernel)..."
pip install notebook jupyterlab ipykernel

# Register this virtual environment as a Jupyter kernel
echo "Registering 'myenv' as a Jupyter kernel..."
python -m ipykernel install --user --name=myenv --display-name="Python (myenv)"

# Launch Jupyter Lab (no browser, accessible on all interfaces)
echo "Launching Jupyter Lab on port 8888..."
jupyter lab --allow-root --ip=0.0.0.0 --no-browser --port=8888