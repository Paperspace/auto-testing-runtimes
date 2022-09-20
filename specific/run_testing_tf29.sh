#!/bin/bash
#
# Notebook-specific testing for TensorFlow 2.9.1
#
# Last updated: Sep 19th 2022

printf "Running Notebook-specific testing for TensorFlow 2.9.1 ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

printf "\nRunning notebooks ...\n"

jupyter nbconvert --to notebook --execute /notebooks/quick_start_beginner.ipynb --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/quick_start_advanced.ipynb --allow-errors --output-dir $resultsdir

printf "\nGetting metrics ...\n"

# 5 minutes should get both notebooks
# Better would be to get each one's metrics, but metrics per process is not yet supported

apikey=$1
notebook_id=`hostname`
starttime=`date -d "5 minutes ago" "+%Y-%m-%d %H:%M:%S"`
endtime=`date "+%Y-%m-%d %H:%M:%S"`

gradient notebooks metrics get \
  --id $notebook_id \
  --start "$starttime" \
  --end "$endtime" \
  --metric gpuUtilization \
  --metric gpuMemoryUtilization \
  --apiKey $apikey

printf "\nNotebook-specific testing is done\n"
