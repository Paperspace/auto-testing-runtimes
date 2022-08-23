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

# PyTorch on base image
import torch
import torchvision
import torchaudio

torch.__version__
torchvision.__version__
torchaudio.__version__

torch.cuda.is_available() # Should print True on GPU machine

torch.cuda.device_count() # E.g., 1 for 1 GPU
torch.cuda.current_device() # E.g., 0
torch.cuda.get_device_name() # E.g., 'NVIDIA Quadro P4000'

# TensorFlow on base image
import tensorflow as tf

# Working with CPU
# (From https://www.tensorflow.org/install/pip)
print(tf.reduce_sum(tf.random.normal([1000, 1000])))

# Sees GPU(s)
tf.config.list_physical_devices('GPU')
