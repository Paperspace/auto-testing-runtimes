#!/bin/bash

# These are the 3 .ipynbs in the https://github.com/huggingface/transformers repo

jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/movement-pruning/Saving_PruneBERT.ipynb --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/lxmert/demo.ipynb                       --allow-errors --output-dir /notebooks/auto_testing_results
jupyter nbconvert --to notebook --execute /notebooks/examples/research_projects/visual_bert/demo.ipynb                  --allow-errors --output-dir /notebooks/auto_testing_results

echo Testing is done
