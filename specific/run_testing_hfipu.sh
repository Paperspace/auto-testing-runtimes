#!/bin/bash

### Not yet tested, due to PLA-1582 ###

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

jupyter nbconvert --to notebook --execute /notebooks/get-started/walkthrough.ipynb                              --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/notebook-tutorials/introduction_to_optimum_graphcore.ipynb --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/notebook-tutorials/text_classification.ipynb               --allow-errors --output-dir $resultsdir

echo Testing is done
