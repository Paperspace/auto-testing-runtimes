#!/bin/bash

# May fail because this doesn't mount the Gradient Dataset as the notebook says is required

jupyter nbconvert --to notebook --execute /notebooks/DALL-E-Mini-inference-pipeline.ipynb --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
