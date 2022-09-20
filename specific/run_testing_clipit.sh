#!/bin/bash
#
# Runtime-specific testing for ClipIt-PixelDraw
#
# Last updated: Sep 20th 2022

printf "Running Runtime-specific testing for ClipIt-PixelDraw ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

printf "\nRunning notebook ...\n\n"

jupyter nbconvert --to notebook --execute /notebooks/PixelDraw.ipynb --allow-errors --output-dir $resultsdir

printf "\nGetting metrics ...\n\n"

apikey=$1
notebook_id=`hostname`
starttime=`date -d "5 minutes ago" "+%Y-%m-%d %H:%M:%S"`
endtime=`date "+%Y-%m-%d %H:%M:%S"`

pip install gradient # Image doesn't have it

gradient notebooks metrics get \
  --id $notebook_id \
  --start "$starttime" \
  --end "$endtime" \
  --metric gpuUtilization \
  --metric gpuMemoryUtilization \
  --apiKey $apikey

printf "\nRuntime-specific testing is done\n"
