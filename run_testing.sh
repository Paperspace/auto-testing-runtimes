#!/bin/bash
#
# This is part of the repo https://github.com/Paperspace/test-updated-runtimes
#
# Called by: do_run_testing.sh
# Calls: ...
#
# Run tests on Notebook for its runtime+machine combination passed in by do_run_testing.sh
#
# - CLI
# - .ipynb notebook content
#
# Tests should correspond to the runtimes project page at https://www.notion.so/paperspace/How-to-test-each-runtime-QA-f460aa4513554ae9b5d81ef513044fdf
#
# Last updated: Aug 18th 2022

echo "Testing has started"

# Global settings

runtime=$1
resultsdir="auto_testing_results"

cd /notebooks
mkdir $resultsdir # Assumes there isn't a directory with this name already


# CLI tests
# ---------

# --- Generic tests ---

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

# Jupyter

# TODO: Call notebook with tests, e.g., print(sys.version) checks it's using same Python as shell

#import sys
#print(sys.version)
#print(sys.executable)

# Python ecosystem

# TODO: Call .py with Python modules, etc.

#import numpy
#import scipy
#import pandas
#import cloudpickle
#import skimage # scikit-image
#import sklearn # scikit-learn
#import matplotlib
#import ipykernel
#import ipywidgets
#import gradient
#import cython #Cython
#import tqdm
#import gdown
#import xgboost 
#import PIL #pillow
#import seaborn
#import sqlalchemy # SQLALchemy
#import spacy
#import nltk
#import jsonify
#import boto3
#import transformers
#import sentence_transformers # sentence-transformers
#import datasets 
#import cv2 # opencv-python

# Gradient CLI

which gradient
gradient version

# ... TODO: Add rest of tests


# Run Jupyter .ipynb notebooks
# ----------------------------

# Each runtime has own content, so use if/then

# The nbconvert form given runs the notebook in the notebook
# Default output is <name>.nbconvert.ipynb
# https://nbconvert.readthedocs.io/en/latest/usage.html
# https://nbconvert.readthedocs.io/en/latest/install.html

#if [ "$runtime" = "PyTorch 1.12" ]; then
#
#  echo Running notebooks for $runtime
#  jupyter nbconvert --to notebook --execute quick_start_pytorch.ipynb --allow-errors --output-dir results
#
#fi


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
