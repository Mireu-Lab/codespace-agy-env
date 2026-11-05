#!/usr/bin/env bash
# ==============================================================================
# Post-Creation Command for DevContainers & Codespaces
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== Running Limmireu AGY DevContainer Provisioning ==="
if [ -f "${SCRIPT_DIR}/install.sh" ]; then
    bash "${SCRIPT_DIR}/install.sh"
else
    echo "[WARN] install.sh not found in project root. Downloading from repository..."
    curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/install.sh | bash
fi
