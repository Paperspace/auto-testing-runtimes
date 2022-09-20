#!/bin/bash
#
# Runtime-specific testing for DALL-E Mini
#
# Last updated: Sep 20th 2022

printf "Running Runtime-specific testing for DALL-E Mini ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# May fail because this doesn't mount the Gradient Dataset as the notebook says is required

printf "\nRunning notebook ...\n\n"

jupyter nbconvert --to notebook --execute /notebooks/DALL-E-Mini-inference-pipeline.ipynb --allow-errors --output-dir $resultsdir

printf "\nGetting metrics ...\n\n"

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
