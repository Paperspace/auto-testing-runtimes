#!/bin/bash

# These are the 3 .ipynbs in the https://github.com/huggingface/transformers repo
# mkdirs to avoid the 2 notebooks called demo.ipynb overwriting each other

mkdir /notebooks/auto_testing_results/movement-pruning
mkdir /notebooks/auto_testing_results/lxmert
mkdir /notebooks/auto_testing_results/visual_bert

jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/movement-pruning/Saving_PruneBERT.ipynb --allow-errors --output-dir /notebooks/auto_testing_results/movement-pruning
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/lxmert/demo.ipynb                       --allow-errors --output-dir /notebooks/auto_testing_results/lxmert
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/visual_bert/demo.ipynb                  --allow-errors --output-dir /notebooks/auto_testing_results/visual_bert

echo Testing is done
