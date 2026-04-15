#!/usr/bin/env bash
set -e

echo "=============================================="
echo "   SLEAP Installer for UTEP PUNAKHA Cluster"
echo "   Using uv + CUDA12 GPU Build (H100 nodes)"
echo "=============================================="

# ---------------------------------------------------------
# 0. PRECHECKS
# ---------------------------------------------------------

# Confirm $WORK exists
if [ -z "$WORK" ]; then
    echo "ERROR: The WORK environment variable is not set."
    echo "Make sure you're logged into PUNAKHA properly."
    exit 1
fi

echo "[OK] WORK directory: $WORK"

# GPU check (warn only, user may install without GPU session)
if ! command -v nvidia-smi >/dev/null 2>&1; then
    echo "WARNING: nvidia-smi not found. You may NOT be on a GPU node."
    echo "Recommend running:"
    echo "   srun -A punakha_general -p dgx -q punakha_dgx_general --gres=gpu:1 --pty bash"
else
    echo "[OK] GPU detected on this node:"
    nvidia-smi | head -n 10
fi

# ---------------------------------------------------------
# 1. CLONE SETUP REPOSITORY
# ---------------------------------------------------------
SETUP_DIR="$WORK/sleap_setup"

echo "Cloning SLEAP setup repo into: $SETUP_DIR"

mkdir -p "$SETUP_DIR"
cd "$SETUP_DIR"

if [ ! -d "$SETUP_DIR/.git" ]; then
    git clone https://github.com/UTEP-RDS/sleap_container_setup.git .
else
    echo "[INFO] Repo already exists — pulling latest updates..."
    git pull
fi

# ---------------------------------------------------------
# 2. INSTALL UV INTO $WORK/bin
# ---------------------------------------------------------
echo "--------------------------------------------"
echo "Installing uv into $WORK/bin"
echo "--------------------------------------------"

mkdir -p "$WORK/bin"

curl -LsSf https://astral.sh/uv/install.sh | UV_INSTALL_DIR="$WORK/bin" sh

# Add to PATH for current session
export PATH="$WORK/bin:$PATH"

# Ensure permanent PATH entry
if ! grep -q "$WORK/bin" ~/.bashrc; then
    echo 'export PATH="$WORK/bin:$PATH"' >> ~/.bashrc
    echo "[OK] Added uv to PATH in ~/.bashrc"
else
    echo "[INFO] PATH already includes $WORK/bin"
fi

# ---------------------------------------------------------
# 3. INSTALL SLEAP WITH UV
# ---------------------------------------------------------
echo "--------------------------------------------"
echo "Installing SLEAP via uv (Python 3.11, CUDA 12.x)"
echo "--------------------------------------------"

uv tool install "sleap[nn]" --python 3.11 \
  --index https://download.pytorch.org/whl/cu121 \
  --index https://pypi.org/simple

echo "[OK] SLEAP Installed."

# ---------------------------------------------------------
# 4. RUN SLEAP DIAGNOSTICS
# ---------------------------------------------------------
echo "--------------------------------------------"
echo "Running SLEAP diagnostics..."
echo "--------------------------------------------"

sleap doctor || {
    echo "ERROR: sleap doctor reported an issue."
    exit 1
}

echo "=============================================="
echo "  INSTALLATION COMPLETE!"
echo "  SLEAP is ready to use on PUNAKHA."
echo "=============================================="
``