# SLEAP Setup Resources (Windows GUI + PUNAKHA HPC)

## Overview
This repository provides a complete setup for running **SLEAP (Social LEAP Estimates Animal Poses)** on both **Windows desktops** and the **UTEP PUNAKHA High‑Performance Computing Cluster**.

SLEAP is an open‑source deep‑learning framework for **multi‑animal pose tracking**, enabling labeling, model training, and high‑speed inference for behavior analysis. According to the SLEAP developers, the framework includes a powerful GUI, supports both single- and multi-animal tracking, and is designed for high‑performance training and inference.

Originally introduced in *Nature Methods*, SLEAP delivers fast, flexible, and accurate tracking across many species and imaging conditions. 

This repository includes two complementary workflows:


## 1. Windows Desktop — SLEAP GUI via Docker + VNC
A Windows-compatible Docker/VNC container is provided for users who require the full **graphical labeling interface**.

**See:** [SLEAP_CONTAINER_GUI.md](./SLEAP_CONTAINER_GUI.md)

This setup provides:
- Full Linux desktop environment via VNC
- Automatic fallback to CPU if no NVIDIA GPU is found
- Support for `sleap-label` GUI
- Direct mapping between Windows folders and `/app` inside the container

Ideal for:
- Dataset labeling
- Proofreading
- GUI-based visualization
- Local interactive workflows


## 2. PUNAKHA HPC Cluster — CLI Training & Inference
A complete workflow for running SLEAP on the **UTEP PUNAKHA cluster** using GPU nodes (H100).

**See:** [SLEAP_PUNAKHA.md](./SLEAP_PUNAKHA.md)

This setup supports:
- GPU‑accelerated training using CUDA 12.x
- High‑throughput inference
- Automated setup via `sleap_punakha_setup.sh`
- uv‑based Python environment management
- Interactive and Slurm batch workflows

Ideal for:
- Large datasets
- Long training jobs
- Batch inference pipelines
- Scalable, reproducible research

## Architecture Compatibility
- Windows container: **x86‑64 only**
- Automatically falls back to **CPU mode** if no NVIDIA CUDA GPU is available

## Included in This Repository
- `SLEAP_CONTAINER_GUI.md` — Windows GUI setup
- `SLEAP_PUNKAHA.md` — HPC setup guide
- `sleap_punakha_setup.sh` — Automated HPC installer
- `submit_sleap.sh` — Sample SLURM job submission
- `start-vnc.sh` — Part of the SLEAP GUI Container to initialize VNC
- Dockerfile for GUI container
- Usage instructions and reference materials
- Model and Data Sample Video Provided by Dr. Rodolfo Flores Garcia - UTEP

## Why Two Workflows?
### Windows GUI Container
Best for **interactive tasks**:
- Labeling
- Proofreading
- Pose visualization

### PUNAKHA HPC
Best for **high‑performance compute tasks**:
- Training deep neural networks
- Processing long recordings
- Parallelized inference

Together, they enable a complete SLEAP workflow from labeling → training → inference.


## Acknowledgements
- This project is funded by the National Science Foundation Campus Cyberinfrastructure (CC*) program under award #2346717.
- SLEAP official site https://docs.sleap.ai/dev/ 
- Pereira, T. D., Tabris, N., Matsliah, A., Turner, D. M., Li, J., Ravindranath, S., ... & Murthy, M. (2022). SLEAP: A deep learning system for multi-animal pose tracking. Nature methods, 19(4), 486-495.
- SLEAP GitHub repository https://github.com/talmolab/sleap


## Repository and Sample Authors
- M.S. Luis A. Garnica Chavira - The University of Texas at El Paso
- Dr. Rodolfo Flores Garcia - The University of Texas at El Paso