#!/usr/bin/env bash
# ==============================================================================
# Limmireu AGY DevContainer Post-Create Provisioning Script
# Automatically deploys Antigravity CLI, Limmireu Pipeline Rules, and MCP Tools
# ==============================================================================
set -euo pipefail

echo "================================================================================"
echo "🚀 [DevContainer] Provisioning Limmireu AGY & Development Environment..."
echo "================================================================================"

# Install and configure AGY and Limmireu environment via official installer
INSTALL_URL="https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/install.sh"
echo "Fetching and executing installer from: ${INSTALL_URL}"
curl -fsSL "${INSTALL_URL}" | bash

echo "================================================================================"
echo "✅ [DevContainer] Limmireu AGY Environment successfully initialized!"
echo "Type 'agy' or 'gcp-calc' to begin development."
echo "================================================================================"
