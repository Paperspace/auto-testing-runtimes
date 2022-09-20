#!/bin/bash
#
# Runtime-specific testing for PyTorch on IPU
#
# Last updated: Sep 20th 2022

printf "Running Runtime-specific testing for PyTorch on IPU ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# Avoid clashing outputs from notebooks with same names

printf "\nRunning notebooks ...\n\n"

mkdir -p $resultsdir/get-started/Fine-tuning-BERT
mkdir -p $resultsdir/get-started/PyG-SchNetGNN

mkdir -p $resultsdir/tutorial-notebooks/basics
mkdir -p $resultsdir/tutorial-notebooks/efficient_data_loading
mkdir -p $resultsdir/tutorial-notebooks/mixed_precision
mkdir -p $resultsdir/tutorial-notebooks/pipelining

# Curated content

jupyter nbconvert --to notebook --execute /notebooks/get-started/Fine-tuning-BERT.ipynb --allow-errors --output-dir $resultsdir/get-started/Fine-tuning-BERT
jupyter nbconvert --to notebook --execute /notebooks/get-started/PyG-SchNetGNN.ipynb    --allow-errors --output-dir $resultsdir/get-started/PyG-SchNetGNN

# Can try out the not-yet-curated content also
# observing_tensors/ has no .ipynb so is not run

jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/basics/walkthrough.ipynb                 --allow-errors --output-dir $resultsdir/tutorial-notebooks/basics
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/efficient_data_loading/walkthrough.ipynb --allow-errors --output-dir $resultsdir/tutorial-notebooks/efficient_data_loading
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/mixed_precision/walkthrough.ipynb        --allow-errors --output-dir $resultsdir/tutorial-notebooks/mixed_precision
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/pipelining/walkthrough.ipynb             --allow-errors --output-dir $resultsdir/tutorial-notebooks/pipelining

# IPU metrics are not yet supported

printf "\nRuntime-specific testing is done\n"
