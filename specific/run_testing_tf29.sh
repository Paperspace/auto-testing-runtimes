#!/bin/bash

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

jupyter nbconvert --to notebook --execute /notebooks/quick_start_beginner.ipynb --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/quick_start_advanced.ipynb --allow-errors --output-dir $resultsdir

echo Testing is done
