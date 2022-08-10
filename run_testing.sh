#!/bin/bash
#
# Run Notebook tests as on "How to test each runtime" Notion page
#
# Last updated: Aug 10th 2022

# References
#
# https://nbconvert.readthedocs.io/en/latest/usage.html
# https://nbconvert.readthedocs.io/en/latest/install.html

echo "Testing has started"


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

# Jupyter cell with

#import sys
#print(sys.version)
#print(sys.executable)

# Python ecosystem

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

# Gradient commands

gradient
gradient version



# ... TODO


# Run Jupyter notebook
# --------------------

cd /notebooks
mkdir results ### Need unique outdir if same Notebook and same .ipynb but different machines

# This runs the notebook in the notebook
# Default output is <name>.nbconvert.ipynb
jupyter nbconvert --to notebook --execute quick_start_pytorch.ipynb --allow-errors --output-dir results

# PDF output also works and can be saved to a remote location without the need to access the Notebook to inspect the results
# But it requires a slow TeXLive install

#apt-get update
#apt-get install -y pandoc
#apt-get install -y texlive-xetex texlive-fonts-recommended texlive-plain-generic
#jupyter nbconvert --to pdf --execute quick_start_pytorch.ipynb --allow-errors --output-dir pdf

# [jupytext converts it to script then can see output]
# [papermill execute notebook with params to notebook]

echo "Testing is done"

# TODO

# Include notebook rerun on test and rerun+kernel restart
