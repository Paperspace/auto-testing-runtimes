#!/bin/bash
#
# Runtime-specific testing for TensorFlow 2.9.1
#
# Last updated: Sep 21st 2022

printf "Running Runtime-specific testing for TensorFlow 2.9.1 ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

printf "\nRunning notebook: quick_start_beginner.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/quick_start_beginner.ipynb --allow-errors --output-dir $resultsdir

printf "\nRunning notebook: quick_start_advanced.ipynb ...\n\n"
jupyter nbconvert --to notebook --execute /notebooks/quick_start_advanced.ipynb --allow-errors --output-dir $resultsdir

printf "\nGetting metrics ...\n\n"

# Better would be to get each notebook's metrics, but metrics per process is not yet supported

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

printf "\nRuntime-specific testing is done\n"
