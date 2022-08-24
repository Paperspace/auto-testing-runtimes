#!/bin/bash

### Not yet tested, due to PLA-1582 ###

# Avoid clashing outputs from notebooks with same names

mkdir -p /notebooks/auto_testing_results/get-started/run_cluster_gcn_notebook

mkdir -p /notebooks/auto_testing_results/tutorial-notebooks/keras
mkdir -p /notebooks/auto_testing_results/tutorial-notebooks/mnist/mnist
mkdir -p /notebooks/auto_testing_results/tutorial-notebooks/tensorboard

# Curated content

jupyter nbconvert --to notebook --execute /notebooks/get-started/run_cluster_gcn_notebook.ipynb.ipynb --allow-errors --output-dir /notebooks/auto_testing_results/get-started/run_cluster_gcn_notebook

# Can try out the not-yet-curated content also
# observing_tensors/ has no .ipynb

jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/keras/demo.ipynb        --allow-errors --output-dir /notebooks/auto_testing_results/tutorial-notebooks/keras
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/mnist/mnist/mnist.ipynb --allow-errors --output-dir /notebooks/auto_testing_results/tutorial-notebooks/mnist/mnist
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/tensorboard/demo.ipynb  --allow-errors --output-dir /notebooks/auto_testing_results/tutorial-notebooks/tensorboard

echo Testing is done
