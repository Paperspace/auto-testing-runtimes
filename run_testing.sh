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
# Last updated: Sep 16th 2022

printf "***\nRunning generic runtime testing\n***\n"

# Global settings

runtime=$1
repodir=/notebooks/test-updated-runtimes
resultsdir=$repodir/auto_testing_results

cd $repodir


# CLI
# ---

# Terminal commands

printf "\n---\nTerminal commands\n---\n\n"

commands=( aws cmake curl cython dialog emacs git joe jq man nano ping rsync ssh sudo unrar zip unzip vi wget )

for cmd in ${commands[@]}; do
    echo Testing command $cmd ...
    which $cmd
done

# Python

printf "\n---\nPython\n---\n\n"

which python
which python3

python -c 'import sys; print(sys.version); print(sys.executable)'
python3 -c 'import sys; print(sys.version); print(sys.executable)'

# Gradient CLI

printf "\n---\nGradient CLI\n---\n\n"

which gradient
gradient version

# GPU

printf "\n---\nGPU\n---\n\n"

nvidia-smi

# Multi-GPU

# TODO: Add this, e.g., nvidia-smi topo --matrix: V100 should show NVLink
# But only works if machine is multi-GPU so need to check for that using truth table

# CUDA

# Shows locations of files called "cuda", case-insensitive
# Might be better formulations of this

printf "\n---\nCUDA\n---\n\n"

find / -type d -iname cuda

# Manual pages

# Check present for built-ins (man) and POSIX (ls)
# Truncate output

printf "\n---\nManual pages (truncated)\n---\n\n"

man man | head -50
printf "...\n\n"

man ls | head -50
printf "...\n"

# Environment variables

# Filter any not useful
# Sort alphabetically for easier reading

printf "\n---\nEnvironment variables\n---\n\n"

printenv | sort | grep -v 'LS_COLORS'


# Python ecosystem
# ----------------

printf "\n---\nPython ecosystem\n---\n\n"

python run_testing.py > $resultsdir/run_testing_python.log


# Jupyter
# -------

# Runtime-specific content is called separately by do_run_testing.sh
# These are generic tests, e.g., is the notebook using the same Python as the terminal

printf "\n---\nJupyter\n---\n\n"

jupyter nbconvert --to notebook --execute run_testing.ipynb --allow-errors --output-dir $resultsdir

printf "\n***\nGeneric runtime testing is done\n***"
