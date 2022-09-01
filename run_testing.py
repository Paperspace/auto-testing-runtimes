# Generic tests for Python
#
# Called by run_testing.sh
#
# Last updated: Sep 01st 2022

print('Running generic tests for Python ...' + '\n')

# Should show expected versions

print('Python is expected versions ...' + '\n')

import sys
print('sys.version:', sys.version)
print('sys.executable:', sys.executable)

# Imports should work without error

print('\n' + 'Checking module imports ...' + '\n')

print('numpy')
import numpy

print('scipy')
import scipy

print('pandas')
import pandas

print('cloudpickle')
import cloudpickle

print('skimage')
import skimage # scikit-image

print('sklearn')
import sklearn # scikit-learn

print('matplotlib')
import matplotlib

print('ipykernel')
import ipykernel

print('ipywidgets')
import ipywidgets

print('cython')
import cython #Cython

print('tqdm')
import tqdm

print('gdown')
import gdown

print('xgboost')
import xgboost 

print('PIL')
import PIL #pillow

print('seaborn')
import seaborn

print('sqlalchemy')
import sqlalchemy # SQLALchemy

print('spacy')
import spacy

print('nltk')
import nltk

print('jsonify')
import jsonify

print('boto3')
import boto3

print('transformers')
import transformers

print('sentence_transformers')
import sentence_transformers # sentence-transformers

print('datasets')
import datasets 

print('cv2')
import cv2 # opencv-python

print('gradient')
import gradient # Gradient will fail on partner containers that don't have it
