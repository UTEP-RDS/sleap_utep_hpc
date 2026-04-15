# SLEAP for Windows — GUI via Docker + VNC
This guide explains how to run the **SLEAP GUI** on **Windows** using a **Docker‑based Linux container** with a built‑in **VNC desktop environment**. This method provides full access to SLEAP’s labeling, proofreading, and training interface without requiring a native Windows installation.

**Note:**
This container is compatible only with x86‑64 systems. If no NVIDIA CUDA‑capable GPU is detected, it will automatically fall back to CPU‑only processing.

**Tested with:**  
Base SLEAP CUDA 11.2.1 - https://github.com/talmolab/sleap-cuda-container/blob/main/sleap_cuda/Dockerfile   
May be improved with a new base: https://github.com/talmolab/sleap-cuda-container/blob/main/sleap_v151_cuda_v128/Dockerfile   

---

## 1. Requirements
Install the following tools before starting:

### **VNC Viewer** (free)
https://www.tightvnc.com/

### **Git Client**
Use your favority git client to clone this repository.   
CLI Git: https://git-scm.com/install/windows 
Source Tree GUI: https://www.sourcetreeapp.com/ 

### **Docker Desktop + Docker Hub account**
https://www.docker.com/
Make sure Docker Desktop is running before continuing.

## 2. Clone this repository
If using the Git Command Line Interface:
git clone https://github.com/UTEP-RDS/sleap_container_setup.git . 

## 3. Build and Run the SLEAP VNC Container
This section covers building the image locally and launching the VNC‑enabled SLEAP environment.

### Step 1 — Build the SLEAP GUI Container
In the folder containing your Dockerfile, run:
```bash
docker build -t sleap-vnc-gui .
```

### Step 2 — Run the Container
The command below:
- Maps port **5901** → VNC
- Allocates **2GB shared memory** (required for SLEAP)
- Mounts your current Windows directory into the container at `/app`

```powershell
docker run -it --rm `
    -p 5901:5901 `
    --shm-size=2gb `
    -v ${PWD}:/app `
    sleap-vnc-gui
```

> **Note:** `${PWD}` automatically maps your current Windows folder to `/app` inside the container.

### Step 3 — VNC Password
Use the password defined in your Dockerfile. Default:
```
password
```

## 4. Connecting to the SLEAP Linux Desktop (VNC)
1. Open **TightVNC Viewer**
2. Connect to:
```
localhost:5901
```
3. Enter your VNC password
4. You will see a full **XFCE Linux desktop** running inside the container.

## 5. Launching the SLEAP GUI
Inside the XFCE desktop:

1. Open the **Terminal Emulator**
2. Start SLEAP:
```bash
sleap-label
```

This launches the complete SLEAP labeling and training interface.

## 6. Running SLEAP Commands
### SLEAP GUI
```bash
sleap-label
```

### SLEAP tracking/training
You can run any command inside the container terminal or use the GUI.

## 7. File & Directory Mapping
Files inside the container appear inside:
```
/app
```
This maps directly to the folder on Windows from which you executed `docker run`.

### Example
If you run the container from:
```
C:\Users\you\SLEAP
```
Then inside the container:
```
/app/model                    → C:\Users\you\SLEAP\model
/app/sample/mouse_sample.mp4  → C:\Users\you\SLEAP\sample\mouse_sample.mp4
```

This allows easy access to your training datasets, videos, and exported models.


## 7. Additional Resources
### Native Windows Installation Guide - Old Version (Video)
https://www.youtube.com/watch?v=Tk8CsCeYyDg

### Official SLEAP Documentation
https://docs.sleap.ai/latest/installation/

### Base Docker Image
https://hub.docker.com/r/eberrigan/sleap-cuda

---

## Acknowledgements
This container workflow is based on the community SLEAP CUDA images and adapted for easier Windows usage.
