#!/bin/bash

### Not yet tested, due to PLA-1582 ###

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# Avoid clashing outputs from notebooks with same names

mkdir -p $resultsdir/get-started/run_cluster_gcn_notebook

mkdir -p $resultsdir/tutorial-notebooks/keras
mkdir -p $resultsdir/tutorial-notebooks/mnist/mnist
mkdir -p $resultsdir/tutorial-notebooks/tensorboard

# Curated content

jupyter nbconvert --to notebook --execute /notebooks/get-started/run_cluster_gcn_notebook.ipynb --allow-errors --output-dir $resultsdir/get-started/run_cluster_gcn_notebook

# Can try out the not-yet-curated content also
# observing_tensors/ has no .ipynb

jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/keras/demo.ipynb        --allow-errors --output-dir $resultsdir/tutorial-notebooks/keras
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/mnist/mnist/mnist.ipynb --allow-errors --output-dir $resultsdir/tutorial-notebooks/mnist/mnist
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/tensorboard/demo.ipynb  --allow-errors --output-dir $resultsdir/tutorial-notebooks/tensorboard

echo Testing is done
