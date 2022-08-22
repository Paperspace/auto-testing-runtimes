#!/bin/bash

# Avoid clashing outputs from notebooks with same names

mkdir -p /notebooks/auto_testing_results/get-started/Fine-tuning-BERT
mkdir -p /notebooks/auto_testing_results/get-started/PyG-SchNetGNN

mkdir -p /notebooks/auto_testing_results/tutorial-notebooks/basics
mkdir -p /notebooks/auto_testing_results/tutorial-notebooks/efficient_data_loading
mkdir -p /notebooks/auto_testing_results/tutorial-notebooks/mixed_precision
mkdir -p /notebooks/auto_testing_results/tutorial-notebooks/pipelining

# Curated content

jupyter nbconvert --to notebook --execute /notebooks/get-started/Fine-tuning-BERT.ipynb --allow-errors --output-dir /notebooks/auto_testing_results/get-started/Fine-tuning-BERT
jupyter nbconvert --to notebook --execute /notebooks/get-started/PyG-SchNetGNN.ipynb    --allow-errors --output-dir /notebooks/auto_testing_results/get-started/PyG-SchNetGNN

# Can try out the not-yet-curated content also
# observing_tensors/ has no .ipynb

jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/basics/walkthrough.ipynb                 --allow-errors --output-dir /notebooks/auto_testing_results/tutorial-notebooks/basics
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/efficient_data_loading/walkthrough.ipynb --allow-errors --output-dir /notebooks/auto_testing_results/tutorial-notebooks/efficient_data_loading
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/mixed_precision/walkthrough.ipynb        --allow-errors --output-dir /notebooks/auto_testing_results/tutorial-notebooks/mixed_precision
jupyter nbconvert --to notebook --execute /notebooks/tutorial-notebooks/pipelining/walkthrough.ipynb             --allow-errors --output-dir /notebooks/auto_testing_results/tutorial-notebooks/pipelining

echo Testing is done
