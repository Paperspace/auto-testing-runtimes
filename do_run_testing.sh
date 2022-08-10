#!/bin/bash
#
# Requirements:
#
# Gradient CLI
# User subscription tier that allows many Notebooks
#
# Last updated: Aug 10th 2022

projectId="<Project ID>" # Set to own project


# Our runtimes
# ------------

# Start same Notebook for different machines
# Ideally machines list same for all our runtimes, and only partner ones have any incompatible machines, but may not hold

machines=("P4000" "P5000") # TODO - add rest
base="paperspace/gradient-base:pt112-tf29-jax0314-py39-20220803"
#command='...' # Doesn't parse below correctly

# PyTorch 1.12

runtime="PyTorch 1.12"
workspace="https://github.com/gradient-ai/PyTorch"
#name="..." # Doesn't parse below correctly

for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
	--machineType $machine \
        --container $base \
        --projectId $projectId \
        --name "Runtime = $runtime, Machine = $machine" \
        --command 'git clone https://github.com/Paperspace/test-updated-runtimes && cd test-updated-runtimes && chmod 764 run_testing.sh && ./run_testing.sh 2>&1 | tee run_testing.log & echo "And now JupyterLab" && jupyter lab --allow-root --ip=0.0.0.0 --no-browser --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" --ServerApp.allow_credentials=True' \
        --workspace $workspace
    
done

# TODO

# TensorFlow 2.9.1
# Paperspace+Fast.ai
# DALL-E-Mini

# Not doing

# Transformers + NLP
# ClipIt-PixelDraw


# Partner runtimes
# ----------------

# Similar but own containers not base

# TODO

# NVIDIA RAPIDS
# Graphcore IPU


# Base image / Gradient runtime
# -----------------------------

# Also similar, no workspace

# TODO


# Close notebooks after running
# -----------------------------

# TODO

#gradient notebooks logs \
#  --id "<Notebook ID>"

#gradient notebooks stop \
#  --id "<Notebook ID>"
  
#gradient notebooks delete \
#  --id "<Notebook ID>"

#to add: gradient notebooks metrics get \
#  --id "<Notebook ID>" \
#  --metric <GPU>, etc.
