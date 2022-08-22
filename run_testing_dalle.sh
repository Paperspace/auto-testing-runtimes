#!/bin/bash

jupyter nbconvert --to notebook --execute /notebooks/DALL-E-Mini-inference-pipeline.ipynb --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
