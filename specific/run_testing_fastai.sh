#!/bin/bash

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# Confirm datasets in shared storage from runtime's run.sh is working
python -c 'from fastai.vision.all import *; path = untar_data(URLs.PETS); print(path)'

jupyter nbconvert --to notebook --execute /notebooks/01_intro.ipynb          --allow-errors --output-dir $resultsdir
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
