# Generic tests for Python
#
# Called by run_testing.sh
#
# Last updated: Sep 22nd 2022

print('Running generic tests for Python ...' + '\n')

# Should show expected versions

print('Python is expected versions ...' + '\n')

import sys
print('sys.version:', sys.version)
print('sys.executable:', sys.executable)

# Imports should work without error
# Use try/except so remainder run if any fail
# Use importlib so can pass moduke name as string
# Assumes importlib is importing module same way as regular import

import importlib

def try_import(module):
    
    print(module)
    
    try:
        importlib.import_module(module)
    except:
        print(module + " not found")
        
print('\n' + 'Checking module imports ...' + '\n')

try_import('numpy')
try_import('scipy')
try_import('pandas')
try_import('cloudpickle')
try_import('skimage') # scikit-image
try_import('sklearn') # scikit-learn
try_import('matplotlib')
try_import('ipykernel')
try_import('ipywidgets')
try_import('cython') #Cython
try_import('tqdm')
try_import('gdown')
try_import('xgboost') 
try_import('PIL') #pillow
try_import('seaborn')
try_import('sqlalchemy') # SQLALchemy
try_import('spacy')
try_import('nltk')
try_import('jsonify')
try_import('boto3')
try_import('transformers')
try_import('sentence_transformers') # sentence-transformers
try_import('datasets')
try_import('cv2') # opencv-python
try_import('jax') # JAX
try_import('gradient') # Gradient will fail on partner containers that don't have it

print('\n' + 'Python generic testing done')
