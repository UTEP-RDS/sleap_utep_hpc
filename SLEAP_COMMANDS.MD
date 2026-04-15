# SLEAP Quick Reference & Cheat Sheet
A compact reference for researchers performing **labeling**, **training**, and **inference** with SLEAP, including guidance for **batch‑processing multiple videos**.

---

# 1. Core SLEAP Commands

## Launch the GUI (Labeling & Proofreading)
```bash
sleap-label
```
Use for:
- Creating labels
- Proofreading predictions
- Visualizing tracking results

## Training Models (CLI)
### Train using default configuration
```bash
sleap-train training_job.json dataset.slp
```
Where `training_job.json` defines the model architecture and parameters.

### Auto‑generate a training config
```bash
sleap-train auto python
```

### Train with GPU
```bash
sleap-train training_job.json dataset.slp --use_gpu
```

## Running Inference (Tracking)
### Basic inference
```bash
sleap track -i input_video.mp4 -m path/to/model
```

### Specify output file
```bash
sleap track -i input_video.mp4 -m model -o predictions.slp
```

### Generate rendered video output
```bash
sleap track -i input_video.mp4 -m model --video rendered_output.mp4
```

### Export predictions to JSON or HDF5
```bash
sleap-convert predictions.slp --format json -o predictions.json
sleap-convert predictions.slp --format h5 -o predictions.h5
```

---

# 2. Diagnostics
Check GPU, environment, and installation:
```bash
sleap doctor
```

---

# 3. Batch‑Processing Multiple Videos
Below are recommended strategies for processing entire folders of videos.

## Method 1 — Bash Loop (Linux / HPC)
Run inference on all MP4 files in a folder:
```bash
for v in *.mp4; do
  out="${v%.mp4}_predictions.slp"
  sleap track -i "$v" -m model -o "$out" --video "${v%.mp4}_rendered.mp4"
done
```

## Method 2 — Slurm Array Job (HPC)
**sleap_array.slurm**
```bash
#!/bin/bash
#SBATCH -A punakha_general
#SBATCH -p dgx
#SBATCH --gres=gpu:1
#SBATCH --array=0-9

# module load cuda/12.1 # hopper setup is cuda ready so not needed

# uv utility path
export PATH="$WORK/bin:$PATH"

VIDEOS=($(ls *.mp4))
VIDEO=${VIDEOS[$SLURM_ARRAY_TASK_ID]}

sleap track -i "$VIDEO" -m model -o "${VIDEO%.mp4}_pred.slp"
```
Submit job:
```bash
sbatch sleap_array.slurm
```

---

# 4. Useful Conversion & Utility Commands

## Convert SLP → JSON
```bash
sleap-convert labels.slp --format json -o labels.json
```

## Split a dataset
```bash
sleap-dataconvert split labels.slp --train 0.8 --val 0.2
```

## Extract labeled frames from a dataset
```bash
sleap-dataconvert export-images labels.slp -o frames/
```

---

# 5. Common File Types
| Extension | Meaning |
|----------|---------|
| `.slp` | SLEAP labels/predictions file |
| `.json` | Exported predictions or labels |
| `.h5` | Deep inference predictions |
| `.mp4` | Input/output videos |




