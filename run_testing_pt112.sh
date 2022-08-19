#!/bin/bash

jupyter nbconvert --to notebook --execute /notebooks/quick_start_pytorch.ipynb --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
