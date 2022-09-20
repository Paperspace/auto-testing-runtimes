#!/bin/bash
#
# Runtime-specific testing for NVIDIA RAPIDS
#
# Last updated: Sep 20th 2022

printf "Running Runtime-specific testing for NVIDIA RAPIDS ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# This is only a subset of all the .ipynbs in the RAPIDS repo

printf "\nRunning notebooks ...\n\n"

jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/arima_demo.ipynb             --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/forest_inference_demo.ipynb  --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/kmeans_demo.ipynb            --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/linear_regression_demo.ipynb --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/nearest_neighbors_demo.ipynb --allow-errors --output-dir $resultsdir
jupyter nbconvert --to notebook --execute /notebooks/rapids/cuml/random_forest_demo.ipynb     --allow-errors --output-dir $resultsdir

jupyter nbconvert --to notebook --execute /notebooks/rapids/xgboost/XGBoost_Demo.ipynb        --allow-errors --output-dir $resultsdir

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
