#!/bin/bash
#
# Runtime-specific testing for TensorFlow 2 on IPU
#
# Last updated: Sep 21st 2022

printf "Running Runtime-specific testing for TensorFlow 2 on IPU ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# Avoid clashing outputs from notebooks with same names

mkdir -p $resultsdir/get-started/run_cluster_gcn_notebook

mkdir -p $resultsdir/tutorial-notebooks/keras
mkdir -p $resultsdir/tutorial-notebooks/mnist/mnist
mkdir -p $resultsdir/tutorial-notebooks/tensorboard

# Curated content

printf "\nRunning notebook: get-started/run_cluster_gcn_notebook.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/get-started/run_cluster_gcn_notebook.ipynb --allow-errors --output-dir $resultsdir/get-started/run_cluster_gcn_notebook

# Can try out the not-yet-curated content also

printf "\nRunning notebook: tutorial-notebooks/keras/demo.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/keras/demo.ipynb        --allow-errors --output-dir $resultsdir/tutorial-notebooks/keras

printf "\nRunning notebook: tutorial-notebooks/mnist/mnist/mnist.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/mnist/mnist/mnist.ipynb --allow-errors --output-dir $resultsdir/tutorial-notebooks/mnist/mnist

printf "\nRunning notebook: tutorial-notebooks/tensorboard/demo.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/tensorboard/demo.ipynb  --allow-errors --output-dir $resultsdir/tutorial-notebooks/tensorboard

# IPU metrics are not yet supported

printf "\nRuntime-specific testing is done\n"
