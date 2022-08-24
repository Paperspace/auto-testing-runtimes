# Generic tests for Python
#
# Called by run_testing.sh

# Imports should work without error
import numpy
import scipy
import pandas
import cloudpickle
import skimage # scikit-image
import sklearn # scikit-learn
import matplotlib
import ipykernel
import ipywidgets
import gradient
import cython #Cython
import tqdm
import gdown
import xgboost 
import PIL #pillow
import seaborn
import sqlalchemy # SQLALchemy
import spacy
import nltk
import jsonify
import boto3
import transformers
import sentence_transformers # sentence-transformers
import datasets 
import cv2 # opencv-python

# Should show expected versions
import sys
print(sys.version)
print(sys.executable)
