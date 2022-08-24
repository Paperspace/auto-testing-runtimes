#!/bin/bash

jupyter nbconvert --to notebook --execute /notebooks/quick_start_beginner.ipynb --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/quick_start_advanced.ipynb --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
