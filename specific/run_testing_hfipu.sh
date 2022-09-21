#!/bin/bash
#
# Runtime-specific testing for Hugging Face Optimum on IPU
#
# Last updated: Sep 21st 2022

printf "Running Runtime-specific testing for Hugging Face Optimum on IPU ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

printf "\nRunning notebook: get-started/walkthrough.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/get-started/walkthrough.ipynb                              --allow-errors --output-dir $resultsdir

printf "\nRunning notebook: notebook-tutorials/introduction_to_optimum_graphcore.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/notebook-tutorials/introduction_to_optimum_graphcore.ipynb --allow-errors --output-dir $resultsdir

printf "\nRunning notebook: notebook-tutorials/text_classification.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/notebook-tutorials/text_classification.ipynb               --allow-errors --output-dir $resultsdir

# IPU metrics are not yet supported

printf "\nRuntime-specific testing is done\n"
