#!/bin/bash
#
# This script runs generic tests applicable to all our runtimes
# It is part of the repo https://github.com/Paperspace/test-updated-runtimes
#
# Called by: do_run_testing.sh
# Calls: ...
#
# It runs the tests on the Gradient Notebook for the given runtime+machine combination passed in by do_run_testing.sh
#
# - CLI
# - .ipynb notebook content
#
# Tests should correspond to the runtimes project page at https://www.notion.so/paperspace/How-to-test-each-runtime-QA-f460aa4513554ae9b5d81ef513044fdf
#
# Last updated: Aug 22nd 2022

echo "Testing has started"

# Global settings

runtime=$1

cd /notebooks
mkdir auto_testing_results # Assumes there isn't a directory with this name already



### TODO: Fill out any remaining tests from the Notion page on testing ###



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


# Python ecosystem
# ----------------

python /notebooks/test-updated-runtimes/run_testing.py


# Jupyter
# -------

# Runtime-specific content is called separately by do_run_testing.sh
# These are generic tests, e.g., is the notebook using the same Python as the terminal

jupyter nbconvert --to notebook --execute /notebooks/test-updated-runtimes/run_testing.ipynb --allow-errors --output-dir /notebooks/auto_testing_results


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
