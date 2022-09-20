#!/bin/bash
#
# Runtime-specific testing for Paperspace + Fast.AI
#
# Last updated: Sep 20th 2022

printf "Running Runtime-specific testing for Paperspace + Fast.AI ...\n"

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# Confirm datasets in shared storage from runtime's run.sh is working
printf "\nConfirm datasets in shared storage ...\n\n"

python -c 'from fastai.vision.all import *; path = untar_data(URLs.PETS); print(path)'

printf "\nRunning notebook ...\n\n"

jupyter nbconvert --to notebook --execute /notebooks/01_intro.ipynb          --allow-errors --output-dir $resultsdir

printf "\nGetting metrics ...\n\n"

# Notebook takes a few minutes to run

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

# Notebooks 2-20 are not run, but probably should be

#jupyter nbconvert --to notebook --execute /notebooks/02_production.ipynb     --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/03_ethics.ipynb         --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/04_mnist_basics.ipynb   --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/05_pet_breeds.ipynb     --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/06_multicat.ipynb       --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/07_sizing_and_tta.ipynb --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/08_collab.ipynb         --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/09_tabular.ipynb        --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/10_nlp.ipynb            --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/11_midlevel_data.ipynb  --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/12_nlp_dive.ipynb       --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/13_convolutions.ipynb   --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/14_resnet.ipynb         --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/15_arch_details.ipynb   --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/16_accel_sgd.ipynb      --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/17_foundations.ipynb    --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/18_CAM.ipynb            --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/19_learner.ipynb        --allow-errors --output-dir $resultsdir
#jupyter nbconvert --to notebook --execute /notebooks/20_conclusion.ipynb     --allow-errors --output-dir $resultsdir
