#!/bin/bash

resultsdir=/notebooks/test-updated-runtimes/auto_testing_results

# These are the 3 .ipynbs in the https://github.com/huggingface/transformers repo
# mkdirs to avoid the 2 notebooks called demo.ipynb overwriting each other

mkdir $resultsdir/movement-pruning
mkdir $resultsdir/lxmert
mkdir $resultsdir/visual_bert

jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/movement-pruning/Saving_PruneBERT.ipynb --allow-errors --output-dir $resultsdir/movement-pruning
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/lxmert/demo.ipynb                       --allow-errors --output-dir $resultsdir/lxmert
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/visual_bert/demo.ipynb                  --allow-errors --output-dir $resultsdir/visual_bert

echo Testing is done
