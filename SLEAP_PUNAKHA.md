# Installing SLEAP on the UTEP PUNAKHA Cluster (x64, H100)

## Overview
This guide provides a workflow for installing and running **SLEAP** on the **UTEP PUNAKHA** HPC cluster using the **uv** package manager. 
It includes missing environment details, GPU node usage, and practices for persistent user installations.

**Tested configuration:**
- **SLEAP:** 1.6
- **Python:** 3.11
- **CUDA:** 12.1+ (NVIDIA H100 nodes)
- **Nodes:** hopper (GPU‑enabled)

**Note if using automated install:**
This guide walks you through the full setup process for installing and configuring SLEAP on the UTEP PUNAKHA cluster. To streamline the workflow, many of these steps have been consolidated into an automated installer script: sleap_punakha_setup.sh. The script handles environment preparation, uv installation, SLEAP installation, and diagnostic checks.

Before running the script, be sure to start an interactive session on the GPU node you intend to use. This ensures access to CUDA, drivers, and cluster resources required for a successful SLEAP installation.

---

## 1. Prepare Your Work Environment
Log in to PUNAKHA and create a directory for the setup.
```bash
ssh youruser@punakha.utep.edu
cd $WORK
mkdir -p sleap_setup
cd sleap_setup
``` 

Clone this repository:
```bash
git clone https://github.com/UTEP-RDS/sleap_container_setup.git .
```

## 2. Install `uv` Into Your $WORK Directory
### 2.1 Create a bin directory
```bash
mkdir -p $WORK/bin
```

### 2.2 Install uv
```bash
curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR="$WORK/bin" sh
```

### 2.3 Add uv to PATH
```bash
export PATH="$WORK/bin:$PATH"
```

### 2.4 Make PATH persistent
```bash
echo 'export PATH="$WORK/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## 3. GPU Interactive Session on PUNAKHA
Request an H100-enabled GPU node (hopper):
```bash
srun -A punakha_general -p dgx -q punakha_dgx_general --gres=gpu:1 --mem=32G --cpus-per-task=8 --pty bash
```

**Notes:**
- `--gres=gpu:1` ensures one GPU
- Add `--time=04:00:00` if you need longer sessions

## 5. Install SLEAP With uv (Python 3.11, CUDA 12.1)
Use PyTorch CUDA 12.1 wheels + PyPI:
```bash
uv tool install "sleap[nn]" --python 3.11   --index https://download.pytorch.org/whl/cu121   --index https://pypi.org/simple
```

Check uv tools:
```bash
uv tool list
```

## 6. Validate Installation
### 6.1 Run SLEAP diagnostics
```bash
sleap doctor
```
You should see:
- GPU detected
- TensorFlow + PyTorch GPU builds functioning

### 6.2 Sample inference test
```bash
sleap track -i sample/mouse_test.mp4 -m model
```

## 7. Batch Job Example for SLEAP Tracking
Create a script named `sleap_track.slurm`:
```bash
#!/bin/bash
#SBATCH -A punakha_general
#SBATCH -p dgx
#SBATCH -q punakha_dgx_general
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=04:00:00

export PATH="$WORK/bin:$PATH"

sleap track -i input_video.mp4 -m exported_model
```
Submit using:
```bash
sbatch sleap_track.slurm
```

## 8. Troubleshooting
### Issue: GPU not detected
- Ensure you're actually running on a GPU node: `nvidia-smi`

### Issue: SLEAP cannot import TensorFlow
- TensorFlow GPU requires the CUDA module to be loaded *before* running sleap.
- Verify which Python uv is using:
  ```bash
  uv python list
  ```

---

## Acknowledgements
- Mouse sample data and base model provided by **Dr. Rodolfo Flores Garcia**, University of Texas at El Paso.
- This project is funded by the National Science Foundation Campus Cyberinfrastructure (CC*) program under award #2346717.

## About Punakha HPC
https://radcdocs.utep.edu/landing_page/high-performance-computing/punakha/

The PUNAKHA cluster is the first High Performance Cluster on campus that offers NVIDIA GPUs for Artificial Intelligence (AI) and Machine Learning (ML) workloads. This cluster was built with the initial collaboration from Dr. Moore, Dr. Tosh, and Information Resources (IR).

### Specs
NVIDIA DGX and an HGX system, both using NVIDIA Hopper architecture with fourth-generation Tensor cores (H100s). The cluster uses Docker and SLURM to schedule jobs and partitions NVIDIA H100 with Multi-Instance GPU (MIG) instances to provide substantial and granular AI/ML capability through predefined cores and memory allocation per GPU (MIG). 

## References
- SLEAP Official Docs: https://docs.sleap.ai/dev/installation/
- UTEP RDS — SLEAP Setup Repository: https://github.com/UTEP-RDS/sleap_container_setup
