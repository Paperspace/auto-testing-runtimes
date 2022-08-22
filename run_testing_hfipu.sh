#!/bin/bash

### Not yet tested, due to PLA-1582 ###

jupyter nbconvert --to notebook --execute /notebooks/get-started/walkthrough.ipynb                              --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/notebook-tutorials/introduction_to_optimum_graphcore.ipynb --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/notebook-tutorials/text_classification.ipynb               --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
