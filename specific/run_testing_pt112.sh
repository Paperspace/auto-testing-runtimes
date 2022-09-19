#!/bin/bash
#
# Notebook-specific testing for PyTorch 1.12
#
# Last updated: Sep 19th 2022

echo Running Notebook-specific testing for PyTorch 1.12 ...

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

echo Running quick_start_pytorch.ipynb ...

jupyter nbconvert --to notebook --execute /notebooks/quick_start_pytorch.ipynb --allow-errors --output-dir $resultsdir

echo Getting metrics ...

notebook_id=`hostname`
startime=`date -d '2 minutes ago' "+%Y-%m-%d %H:%M:%S"`
endtime=`date "+%Y-%m-%d %H:%M:%S"`

gradient notebooks metrics get \
  --id $notebook_id \
  --start "$starttime" \
  --end "$endtime" \
  --metric gpuUtilization \
  --metric gpuMemoryUtilization

echo Notebook-specific testing is done
