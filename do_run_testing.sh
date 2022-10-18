#!/bin/bash
#
# Repo for this script: https://github.com/Paperspace/test-updated-runtimes
#
#./do_run_testing.sh [-c "<clusterId>" -w "<workspaceRef>"] "<runtime>" "<projectId>"
#
# Last updated: Oct 18th 2022


# What this script does
# *********************

# Loop through each valid runtime+machine combination
#
# for given runtime
#   foreach machine
#     create Notebook
#     run tests
#
# For R runtimes and M machines, this would create R*M Gradient Notebooks
# So script is called for one runtime at once, each call creating M Notebooks
#
# The current machines list follows the Gradient documentation at https://docs.paperspace.com/gradient/machines/
# More information on our runtimes is at https://www.notion.so/paperspace/Tables-of-current-runtimes-7d2580b067dc45919b3220bc56ec9eda
# Runtimes include ours, which use our base Docker image (or another one beginning with "paperspace") + a repo, and partners', which use their Docker images
# Our base runtime is tested directly via the "Start from Scratch" runtime below, which is the base with no repo
# Notebooks CLI reference is at https://docs.paperspace.com/gradient/cli/notebooks
#
# The nbconvert form given to run the .ipynb notebooks in the called subscripts runs the notebook in the notebook
# This outputs a copy where the cells have been run into the directory for auto-testing results
# https://nbconvert.readthedocs.io/en/latest/usage.html
# https://nbconvert.readthedocs.io/en/latest/install.html


# 0. Setup
# ********

# Current machines on Paperspace
# Settings in section 2 are currently testing GPU: can add multi-GPU, etc.
# Ideally the machines list would be the same for all our runtimes, but some combinations are incompatible
# This could be expressed as a support matrix, but currently we simply loop on the compatible combinations within each runtime

# CPU: C5, C7
# GPU: P4000, RTX4000, RTX5000, P5000, P6000, A4000, V100, V100-32G, A5000, A6000, A100, A100-80G
# Multi-GPU: A4000x2, V100-32Gx2, V100-32Gx4, A5000x2, A6000x2, A6000x4, A100x2
# Free: Free CPU (C4), Free GPU+ (M4000), Free P4000, Free RTX4000, Free P5000, Free RTX5000, Free A4000, Free A5000, Free A6000, Free A100-80G
# IPU: Free-IPU-POD16

# Current runtimes
# All of these have settings below in section 2

# Ours: PyTorch 1.12, TensorFlow 2.9.1, Paperspace + Fast.AI, DALL-E Mini, Transformers + NLP, Start from Scratch, ClipIt-PixelDraw, Stable Diffusion
# Partner: NVIDIA RAPIDS, Hugging Face Optimum on IPU, PyTorch on IPU, TensorFlow 2 on IPU

# Total combinations <= 32*11 = 352

# Global settings

base="paperspace/gradient-base:pt112-tf29-jax0314-py39-20220803"      # The runtime base Docker image
autotestingrepo="https://github.com/Paperspace/test-updated-runtimes" # Git repo for auto-testing
autotestingrepodir="test-updated-runtimes"                            # Directory created on Notebook by cloning this repo
resultsdir="auto_testing_results"                                     # Directory for all results of testing
apifile="$HOME/.paperspace/config.json"                               # File containing API key (use HOME not ~)
shutdowntime="6"                                                      # Avoid default 1h shutdown on IPUs (integer, no units)

# Get user input arguments

# getopts has user supply options first before required arguments
# So usage is ./do_run_testing.sh [-c "<clusterId>" -w "<workspaceRef>"] "<runtime>" "<projectId>"
# Then get runtime and projectId as last 2 arguments
# Setup like this is not great but allows -c and -w to be optional

runtime=${@: -2:1}
projectId=${@: -1}

while getopts "c:w:" opt; do
  case $opt in
    c)
      clusterId=$OPTARG
      ;;
    w)
      workspaceRef=$OPTARG
      ;;
  esac
done

apikey=`cat $apifile | grep apiKey | awk '{print $NF}'`


# 1. Function to run machines
# ***************************

# Function to run chosen runtime for each of the machines given in its settings below
# Bash script variables are global by default so function has no arguments
# Function is only run once each time so using globals is OK
# The --command syntax is tricky: note the single "&" before the JupyterLab part, and all others double "&&"
# This is backgrounding the subscript invocations so that the jupyter lab can run and the Notebook can finish starting without erroring waiting for the Jupyter server response
# There might be a better redirect than 2>&1 | tee, but we want to capture both stdout and stderr

run_on_machines () {

  echo Runtime $runtime

  for machine in ${machines[@]}; do
    
    echo Machine $machine
  
    # Construct --command

    command="'git clone $autotestingrepo && \
              cd $autotestingrepodir && \
	      chmod 764 run_testing.sh && \
	      chmod 764 specific/run_testing_$shortname.sh && \
	      ./run_testing.sh 2>&1 | tee $resultsdir/run_testing.log && \
	      ./specific/run_testing_$shortname.sh $apikey 2>&1 | tee $resultsdir/run_testing_$shortname.log & \
	      echo \"And now JupyterLab\" && \
              $jupytercmd'"
    
    # Construct gradient notebooks create

    name="Auto-testing: $runtime on $machine"
    tag="autotesting"$shortname # Tags can only contain alphanumeric characters
    
    cmdstr="gradient notebooks create \
            --machineType \"$machine\" \
            --container \"$container\" \
            --projectId \"$projectId\" \
            --name \"$name\" \
            --command $command \
	    --shutdownTimeout \"$shutdowntime\" \
            --tag \"$tag\""

    # Include workspace unless running base image only (e.g., "Start from Scratch" runtime)
    if [ -z "$runningbase" ]; then
	cmdstr=$cmdstr" --workspace \"$workspace\""
    fi

    # User optionally adds clusterId
    if [ -n "$clusterId" ]; then
	cmdstr=$cmdstr" --clusterId \"$clusterId\""
    fi

    # User optionally adds workspaceRef
    if [ -n "$workspaceRef" ]; then
	cmdstr=$cmdstr" --workspaceRef \"$workspaceRef\""
    fi

    # Uncomment this if you want to see the gradient notebooks create command used for each Notebook
    # sed filter prevents the API key from being written out
    
    # echo $cmdstr | sed s/$apikey/"<API key>"/g
    
    eval $cmdstr # Run the Notebook

  done

}

# 2. Settings for each runtime
# ****************************

# These are different for each of the runtimes and therefore hardwired
# They could potentially be put in their own settings files


# 2.1: PyTorch 1.12
# -----------------

if [ "$runtime" = "PyTorch 1.12" ]; then

  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container=$base
  workspace="https://github.com/gradient-ai/PyTorch"
  shortname="pt112"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"

  run_on_machines

fi


# 2.2: TensorFlow 2.9.1
# ---------------------

if [ "$runtime" = "TensorFlow 2.9.1" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container=$base
  workspace="https://github.com/gradient-ai/TensorFlow"
  shortname="tf29" 
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"

  run_on_machines

fi


# 2.3: Paperspace + Fast.AI
# -------------------------

# Command is run.sh rather than jupyter lab
# Container is not base

if [ "$runtime" = "Paperspace + Fast.AI" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container="paperspace/fastai:2.0-fastbook-2022-06-29"
  workspace="https://github.com/fastai/fastbook.git"
  shortname="fastai"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      /run.sh"

  run_on_machines

fi


# 2.4: DALL-E Mini
# ----------------

if [ "$runtime" = "DALL-E Mini" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container=$base
  workspace="https://github.com/gradient-ai/dalle-mini"
  shortname="dalle"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"

  run_on_machines
  
fi


# 2.5: Transformers + NLP
# -----------------------

if [ "$runtime" = "Transformers + NLP" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container=$base
  workspace="https://github.com/huggingface/transformers.git"
  shortname="tnlp"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"
  
  run_on_machines

fi


# 2.6: Start from Scratch
# -----------------------

# This one has no workspace and no .ipynb to run
# Tests the base container directly

if [ "$runtime" = "Start from Scratch" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container=$base
  runningbase="Yes" # No workspace; set this so workspace is not added in run_on_machines()
  shortname="sfs"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"
  
  run_on_machines
  
fi


# 2.7: ClipIt-PixelDraw
# ---------------------

# Container is not base

if [ "$runtime" = "ClipIt-PixelDraw" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container="paperspace/clip-pixeldraw:jupyter"
  workspace="https://github.com/gradient-ai/ClipIt-PixelDraw"
  shortname="clipit"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"

  run_on_machines
  
fi


# 2.8: NVIDIA RAPIDS
# ------------------

# Partner runtime: not using our base image

if [ "$runtime" = "NVIDIA RAPIDS" ]; then
    
  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container="rapidsai/rapidsai:22.10-cuda11.2-runtime-ubuntu20.04-py3.9"
  workspace="https://github.com/gradient-ai/RAPIDS.git"
  shortname="rapids"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"

  run_on_machines

fi


# 2.9: Hugging Face Optimum on IPU
# --------------------------------

# Partner runtime: not using our base image
# Same image as PyTorch on IPU below
# Only IPU machine is compatible
# Command is different from our base: add CACHE_DIR=/tmp DATASET_DIR=/graphcore
# Specify the clusterId (e.g., clcpuovbp), otherwise the Notebook startup fails (PLA-1582)

if [ "$runtime" = "Hugging Face Optimum on IPU" ]; then
    
  machines=("Free-IPU-POD16")
  container="graphcore/pytorch-jupyter:2.6.0-ubuntu-20.04-20220804"
  workspace="https://github.com/gradient-ai/Graphcore-HuggingFace"
  shortname="hfipu"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      CACHE_DIR=/tmp && \
	      DATASET_DIR=/graphcore && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"

  run_on_machines  

fi


# 2.10: PyTorch on IPU
# --------------------

# Specify the clusterId (e.g., clcpuovbp), otherwise the Notebook startup fails (PLA-1582)

if [ "$runtime" = "PyTorch on IPU" ]; then
    
  machines=("Free-IPU-POD16")
  container="graphcore/pytorch-jupyter:2.6.0-ubuntu-20.04-20220804"
  workspace="https://github.com/gradient-ai/Graphcore-Pytorch"
  shortname="ptipu"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      CACHE_DIR=/tmp && \
	      DATASET_DIR=/graphcore && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"

  run_on_machines

fi


# 2.11: TensorFlow 2 on IPU
# -------------------------

# Command is different from HF and PT: add CACHE_DIR=/tmp DATASET_DIR=/tmp
# Specify the clusterId (e.g., clcpuovbp), otherwise the Notebook startup fails (PLA-1582)

if [ "$runtime" = "TensorFlow 2 on IPU" ]; then
    
  machines=("Free-IPU-POD16")
  container="graphcore/tensorflow-jupyter:2-amd-2.6.0-ubuntu-20.04-20220804"
  workspace="https://github.com/gradient-ai/Graphcore-Tensorflow2"
  shortname="tf2ipu"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      CACHE_DIR=/tmp && \
	      DATASET_DIR=/tmp && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"
  
  run_on_machines

fi


# 2.12: Stable Diffusion
# ----------------------

if [ "$runtime" = "Stable Diffusion" ]; then

  machines=("P4000" "RTX4000" "RTX5000" "P5000" "P6000" "A4000" "V100" "V100-32G" "A5000" "A6000" "A100" "A100-80G")
  container=$base
  workspace="https://github.com/gradient-ai/stable-diffusion"
  shortname="stable"
  jupytercmd="PIP_DISABLE_PIP_VERSION_CHECK=1 && \
	      jupyter lab --allow-root --ip=0.0.0.0 --no-browser \
		--ServerApp.trust_xheaders=True --ServerApp.disable_check_xsrf=False \
		--ServerApp.allow_remote_access=True --ServerApp.allow_origin=\"*\" \
		--ServerApp.allow_credentials=True"
  
  run_on_machines

fi
