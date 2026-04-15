#!/bin/bash
#SBATCH -A punakha_general
#SBATCH -p dgx
#SBATCH -q punakha_dgx_general
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00
#SBATCH -o sleap_job_%j.out
#SBATCH -e sleap_job_%j.err

# Add uv tools to PATH
export PATH="$WORK/bin:$PATH"

# Navigate to your working directory with the project files
cd $WORK/sleap_setup

# Run SLEAP inference
# The output will be created next to the input video unless otherwise specified
sleap track \
  -i sample/mouse_test.mp4 \
  -m model 