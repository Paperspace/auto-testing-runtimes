#!/bin/bash
#
# See repo for how to use this script:
# https://github.com/Paperspace/test-updated-runtimes
#
# Last updated: Aug 18th 2022


# -----------------------------------------
# Set to ID of own created Gradient Project

#projectId="<Project ID>"
projectId="p3lkwjx67pw"
# ------------------------------------------


# Loop through each valid runtime+machine combination
#
# for given runtime
#   foreach machine
#     create Notebook
#     run tests
#
# For R runtimes and M machines, this would creates R*M Gradient Notebooks
# So script is called for one runtime at once
#
# Ideally the machines list would be the same for all our runtimes, but some combinations are incompatible
# This could be expressed as a support matrix, but currently we simply loop on the compatible combinations within each runtime
# The current machines list follows the Gradient documentation at https://docs.paperspace.com/gradient/machines/
# More information on our runtimes is at https://www.notion.so/paperspace/Tables-of-current-runtimes-7d2580b067dc45919b3220bc56ec9eda
# Runtimes are divided into ours, which use our base Docker image (or another one beginning with "paperspace") + a repo, and partners', which use their Docker images
# Our base runtime is tested directly via the "Start from Scratch" runtime below, which is the base with no repo
# Notebooks CLI reference is at https://docs.paperspace.com/gradient/cli/notebooks

# Current machines

# CPU: C5, C7
# GPU: P4000, RTX4000, RTX5000, P5000, P6000, A4000, V100, V100-32G, A5000, A6000, A100, A100-80G
# Multi-GPU: A4000x2, V100-32Gx2, V100-32Gx4, A5000x2, A6000x2, A6000x4, A100x2
# Free: Free CPU (C4), Free GPU+ (M4000), Free P4000, Free RTX4000, Free P5000, Free RTX5000, Free A4000, Free A5000, Free A6000, Free A100-80G
# IPU: Free-IPU-POD16

# Current runtimes

# Ours: PyTorch 1.12, TensorFlow 2.9.1, Paperspace + Fast.AI, DALL-E Mini, Transformers+NLP, Start from Scratch, ClipIt-PixelDraw
# Partner: NVIDIA RAPIDS, Hugging Face Optimum on IPU, PyTorch on IPU, TensorFlow 2 on IPU

# Total combinations <= 32*11 = 354

# Global settings

runtime=$1
base="paperspace/gradient-base:pt112-tf29-jax0314-py39-20220803"


# PyTorch 1.12
# ------------

if [ "$runtime" = "PyTorch 1.12" ]; then
    
  machines=("P4000")
  #machines=("P4000" "P5000")
  #machines=("P4000", "RTX4000", "RTX5000", "P5000", "P6000", "A4000", "V100", "V100-32G", "A5000", "A6000", "A100", "A100-80G")

  workspace="https://github.com/gradient-ai/PyTorch"
  #name="..." # Doesn't parse correctly if placed here, so currently directly in the CLI invocation
  #command='...' # Doesn't parse correctly if placed here, so currently directly in the CLI invocation
  #There might be a better redirect than 2>&1 | tee, but we want to capture stdout and stderr
  #If gradient notebooks create is same for every runtime can bring out into function
  tag="autotestingpytorch112" # Tags can only contain alphanumeric characters

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && cd test-updated-runtimes && chmod 764 run_testing.sh && chmod 764 run_testing_pt112.sh && ./run_testing.sh 2>&1 | tee run_testing.log & cd test-updated-runtimes && ./run_testing_pt112.sh 2>&1 | tee run_testing_pt112.log & echo "And now JupyterLab" && PIP_DISABLE_PIP_VERSION_CHECK=1 && jupyter lab --allow-root --ip=0.0.0.0 --no-browser --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# TensorFlow 2.9.1
# ----------------

if [ "$runtime" = "TensorFlow 2.9.1" ]; then
    
  machines=("P4000" "P5000")
  #machines=("P4000", "RTX4000", "RTX5000", "P5000", "P6000", "A4000", "V100", "V100-32G", "A5000", "A6000", "A100", "A100-80G")

  workspace="https://github.com/gradient-ai/TensorFlow"
  tag="autotestingtensorflow291"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && cd test-updated-runtimes && chmod 764 run_testing.sh && ./run_testing.sh $runtime 2>&1 | tee run_testing.log & echo "And now JupyterLab" && PIP_DISABLE_PIP_VERSION_CHECK=1 && jupyter lab --allow-root --ip=0.0.0.0 --no-browser --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi

# TODO

#Paperspace + Fast.AI
#DALL-E Mini
#Transformers+NLP
#Start from Scratch
#ClipIt-PixelDraw
#NVIDIA RAPIDS
#Hugging Face Optimum on IPU
#PyTorch on IPU
#TensorFlow 2 on IPU


# Improvements
# ************

# Better would be to create one Notebook for each runtime and run it for all machines
# This would avoid creating a large number of Notebooks
# But using gradient notebooks create, stop, and start same ID with different machine still creates a new one each time, leaving just as many

# Potentially add these (the Notebook ID can be retrieved)

#gradient notebooks stop \   # Avoid leaving them all running if can wait for testing in each one to be done before stopping
#  --id "<Notebook ID>"

#gradient notebooks logs \   # Retrieve the logs from each Notebook
#  --id "<Notebook ID>"
  
#gradient notebooks delete \   # If results are uploaded elsewhere, don't need to keep each Notebook
#  --id "<Notebook ID>"

#gradient notebooks metrics get \   # Record resource usage, e.g., GPUs
#  --id "<Notebook ID>" \
#  --metric <GPU>, etc.
