#!/bin/bash

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

jupyter nbconvert --to notebook --execute /notebooks/PixelDraw.ipynb --allow-errors --output-dir $resultsdir

echo Testing is done
