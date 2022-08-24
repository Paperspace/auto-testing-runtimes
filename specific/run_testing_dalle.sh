#!/bin/bash

# May fail because this doesn't mount the Gradient Dataset as the notebook says is required

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

jupyter nbconvert --to notebook --execute /notebooks/DALL-E-Mini-inference-pipeline.ipynb --allow-errors --output-dir $resultsdir

echo Testing is done
