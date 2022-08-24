#!/bin/bash
#
# See repo for how to use this script:
# https://github.com/Paperspace/test-updated-runtimes
#
# Last updated: Aug 24th 2022


# -----------------------------------------
# Set to ID of own created Gradient Project

#projectId="<Project ID>"
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

# The nbconvert form given to run the .ipynb notebooks in the called subscripts runs the notebook in the notebook
# This outputs a copy where the cells have been run
# https://nbconvert.readthedocs.io/en/latest/usage.html
# https://nbconvert.readthedocs.io/en/latest/install.html

# Current machines

# Below is currently testing GPU: can add multi-GPU, etc.

# CPU: C5, C7
# GPU: P4000, RTX4000, RTX5000, P5000, P6000, A4000, V100, V100-32G, A5000, A6000, A100, A100-80G
# Multi-GPU: A4000x2, V100-32Gx2, V100-32Gx4, A5000x2, A6000x2, A6000x4, A100x2
# Free: Free CPU (C4), Free GPU+ (M4000), Free P4000, Free RTX4000, Free P5000, Free RTX5000, Free A4000, Free A5000, Free A6000, Free A100-80G
# IPU: Free-IPU-POD16

# Current runtimes

# Ours: PyTorch 1.12, TensorFlow 2.9.1, Paperspace + Fast.AI, DALL-E Mini, Transformers + NLP, Start from Scratch, ClipIt-PixelDraw
# Partner: NVIDIA RAPIDS, Hugging Face Optimum on IPU, PyTorch on IPU, TensorFlow 2 on IPU

# Total combinations <= 32*11 = 352

# Global settings

runtime=$1
base="paperspace/gradient-base:pt112-tf29-jax0314-py39-20220803"


# PyTorch 1.12
# ------------

if [ "$runtime" = "PyTorch 1.12" ]; then

  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

  workspace="https://github.com/gradient-ai/PyTorch"
  #name="..." # Doesn't parse correctly if placed here, so currently directly in the CLI invocation
  #command='...' # Doesn't parse correctly if placed here, so currently directly in the CLI invocation
  #The --command syntax is tricky: note the single "&" before the JupyterLab part, and all others double "&&"
  #This is backgrounding the subscript invocations so that the jupyter lab can run and the Notebook can finish starting without erroring waiting for the Jupyter server response
  #There might be a better redirect than 2>&1 | tee, but we want to capture stdout and stderr
  #If gradient notebooks create is same for every runtime can bring out into function, but currently it is not
  tag="autotestingpytorch112" # Tags can only contain alphanumeric characters

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_pt112.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_pt112.sh 2>&1 | tee auto_testing_results/run_testing_pt112.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# TensorFlow 2.9.1
# ----------------

if [ "$runtime" = "TensorFlow 2.9.1" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

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
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_tf29.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_tf29.sh 2>&1 | tee auto_testing_results/run_testing_tf29.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag
    
  done

fi


# Paperspace + Fast.AI
# -------------------

# Command is run.sh rather than jupyter lab

if [ "$runtime" = "Paperspace + Fast.AI" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

  workspace="https://github.com/fastai/fastbook.git"
  tag="autotestingfastai"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_fastai.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_fastai.sh 2>&1 | tee auto_testing_results/run_testing_fastai.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 /run.sh' \
      --workspace $workspace \
      --tag $tag
    
  done

fi


# DALL-E Mini
# -----------

if [ "$runtime" = "DALL-E Mini" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

  workspace="https://github.com/gradient-ai/dalle-mini"
  tag="autotestingdalle"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_dalle.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_dalle.sh 2>&1 | tee auto_testing_results/run_testing_dalle.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# Transformers + NLP
# ------------------

if [ "$runtime" = "Transformers + NLP" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

  workspace="https://github.com/huggingface/transformers.git"
  tag="autotestingtnlp"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_tnlp.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_tnlp.sh 2>&1 | tee auto_testing_results/run_testing_tnlp.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# Start from Scratch
# ------------------

# This one has no workspace and no .ipynb to run
# Tests the base container directly

if [ "$runtime" = "Start from Scratch" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

  tag="autotestingscratch"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" \
		 --ServerApp.allow_credentials=True' \
      --tag $tag

  done

fi


# ClipIt-PixelDraw
# ----------------

if [ "$runtime" = "ClipIt-PixelDraw" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

  workspace="https://github.com/gradient-ai/ClipIt-PixelDraw"
  tag="autotestingclipit"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $base \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_clipit.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_clipit.sh 2>&1 | tee auto_testing_results/run_testing_clipit.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# NVIDIA RAPIDS
# -------------

# Partner runtime: not using our base image

if [ "$runtime" = "NVIDIA RAPIDS" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")

  container="rapidsai/rapidsai:22.06-cuda11.0-runtime-ubuntu18.04-py3.8"
  workspace="https://github.com/gradient-ai/RAPIDS.git"
  tag="autotestingrapids"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $container \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_rapids.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_rapids.sh 2>&1 | tee auto_testing_results/run_testing_rapids.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin="*" \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# Hugging Face Optimum on IPU
# ---------------------------

### Not yet tested, due to PLA-1582 ###

# Partner runtime: not using our base image
# Only IPU machine is compatible
# Command is different from our base: add CACHE_DIR=/tmp DATASET_DIR=/graphcore

if [ "$runtime" = "Hugging Face Optimum on IPU" ]; then
    
  machines=("Free-IPU-POD16")

  container="graphcore/pytorch-jupyter:2.6.0-ubuntu-20.04-20220804"
  workspace="https://github.com/gradient-ai/Graphcore-HuggingFace"
  tag="autotestinghfipu"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $container \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_hfipu.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_hfipu.sh 2>&1 | tee auto_testing_results/run_testing_hfipu.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 CACHE_DIR=/tmp && \
		 DATASET_DIR=/graphcore && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin='*' \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# PyTorch on IPU
# --------------

### Not yet tested, due to PLA-1582 ###

if [ "$runtime" = "PyTorch on IPU" ]; then
    
  machines=("Free-IPU-POD16")

  container="graphcore/pytorch-jupyter:2.6.0-ubuntu-20.04-20220804"
  workspace="https://github.com/gradient-ai/Graphcore-Pytorch"
  tag="autotestingptipu"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $container \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_ptipu.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_ptipu.sh 2>&1 | tee auto_testing_results/run_testing_ptipu.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 CACHE_DIR=/tmp && \
		 DATASET_DIR=/graphcore && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin='*' \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


# TensorFlow 2 on IPU
# -------------------

### Not yet tested, due to PLA-1582 ###

# Command is different from HF and PT: add CACHE_DIR=/tmp DATASET_DIR=/tmp

if [ "$runtime" = "TensorFlow 2 on IPU" ]; then
    
  machines=("Free-IPU-POD16")

  container="graphcore/tensorflow-jupyter:2-amd-2.6.0-ubuntu-20.04-20220804"
  workspace="https://github.com/gradient-ai/Graphcore-Tensorflow2"
  tag="autotestingtf2ipu"

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine

    gradient notebooks create \
      --machineType $machine \
      --container $container \
      --projectId $projectId \
      --name "Auto-testing: $runtime on $machine" \
      --command 'git clone https://github.com/Paperspace/test-updated-runtimes && \
      		 cd test-updated-runtimes && \
		 chmod 764 run_testing.sh && \
		 chmod 764 specific/run_testing_tf2ipu.sh && \
		 ./run_testing.sh 2>&1 | tee auto_testing_results/run_testing.log && \
		 ./specific/run_testing_tf2ipu.sh 2>&1 | tee auto_testing_results/run_testing_tf2ipu.log & \
		 echo "And now JupyterLab" && \
		 PIP_DISABLE_PIP_VERSION_CHECK=1 && \
		 CACHE_DIR=/tmp && \
		 DATASET_DIR=/tmp && \
		 jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		 --ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		 --ServerApp.allow_remote_access=True --ServerApp.allow_origin='*' \
		 --ServerApp.allow_credentials=True' \
      --workspace $workspace \
      --tag $tag

  done

fi


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
