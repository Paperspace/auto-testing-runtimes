#!/bin/bash
#
# This script runs generic tests applicable to all our runtimes
# It is part of the repo https://github.com/Paperspace/test-updated-runtimes
#
# Called by: do_run_testing.sh
# Calls: run_testing.py, run_testing.ipynb
#
# It runs the tests on the Gradient Notebook for the given runtime+machine combination passed in by do_run_testing.sh
# Tests should correspond to the runtimes project page at https://www.notion.so/paperspace/How-to-test-each-runtime-QA-f460aa4513554ae9b5d81ef513044fdf
# Currently it not quite all of them: there are some things that can be added, e.g., tests specific to multi-GPU
#
# Last updated: Aug 22nd 2022

echo "Testing has started"

# Global settings

runtime=$1
resultsdir=/notebooks/auto_testing_results
repodir=/notebooks/test-updated-runtimes

#mkdir $resultsdir # Assumes there isn't a directory with this name already
cd $repodir


# CLI
# ---

# Terminal commands

commands=( aws cmake curl cython dialog emacs git joe jq man nano ping rsync ssh sudo unrar zip unzip vi wget )

for cmd in ${commands[@]}; do
    which $cmd
done

# Python

which python
which python3

python -c 'import sys; print(sys.version); print(sys.executable)'
python3 -c 'import sys; print(sys.version); print(sys.executable)'

# Gradient CLI

which gradient
gradient version

# GPU

nvidia-smi

# Multi-GPU

# TODO: Add this, e.g., nvidia-smi topo --matrix: V100 should show NVLink


# Python ecosystem
# ----------------

python run_testing.py > $resultsdir/run_testing_python.log


# Jupyter
# -------

# Runtime-specific content is called separately by do_run_testing.sh
# These are generic tests, e.g., is the notebook using the same Python as the terminal

jupyter nbconvert --to notebook --execute run_testing.ipynb --allow-errors --output-dir $resultsdir


# Improvements
# ************

# Include notebook rerun on test and rerun+kernel restart

# PDF output also works and could be saved to a remote location without the need to access the Notebook to inspect the results
# But it requires a slow TeXLive install, and our Notebooks can be viewed offline

#apt-get update
#apt-get install -y pandoc
#apt-get install -y texlive-xetex texlive-fonts-recommended texlive-plain-generic
#jupyter nbconvert --to pdf --execute quick_start_pytorch.ipynb --allow-errors --output-dir pdf

# jupytext converts it to script then can see output
# Papermill has execute notebook with params to notebook
