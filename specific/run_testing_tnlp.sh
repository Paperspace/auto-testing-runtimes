#!/bin/bash
#
# Runtime-specific testing for Transformers + NLP
#
# Last updated: Sep 20th 2022

printf "Running Runtime-specific testing for Transformers + NLP ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# These are the 3 .ipynbs in the https://github.com/huggingface/transformers repo
# mkdirs to avoid the 2 notebooks called demo.ipynb overwriting each other

printf "\nRunning notebooks ...\n\n"

mkdir $resultsdir/movement-pruning
mkdir $resultsdir/lxmert
mkdir $resultsdir/visual_bert

jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/movement-pruning/Saving_PruneBERT.ipynb --allow-errors --output-dir $resultsdir/movement-pruning
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/lxmert/demo.ipynb                       --allow-errors --output-dir $resultsdir/lxmert
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/visual_bert/demo.ipynb                  --allow-errors --output-dir $resultsdir/visual_bert

printf "\nGetting metrics ...\n\n"

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

printf "\nRuntime-specific testing is done\n"
