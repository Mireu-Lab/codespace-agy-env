#!/usr/bin/env bash
# ==============================================================================
# Limmireu Antigravity (AGY) & Dev Environment Installer for GitHub Codespaces
# Compatible with: GitHub Codespaces Dotfiles, DevContainers, and Manual Shell
# ==============================================================================
set -euo pipefail

# Colors for logging
readonly C_RESET='\033[0m'
readonly C_RED='\033[0;31m'
readonly C_GREEN='\033[0;32m'
readonly C_YELLOW='\033[0;33m'
readonly C_BLUE='\033[0;34m'
readonly C_CYAN='\033[0;36m'

log_info()    { echo -e "${C_BLUE}[INFO]${C_RESET} $*"; }
log_success() { echo -e "${C_GREEN}[SUCCESS]${C_RESET} $*"; }
log_warn()    { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
log_error()   { echo -e "${C_RED}[ERROR]${C_RESET} $*" >&2; }

RAW_BASE_URL="https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main"

# Determine script root directory
if [ -n "${BASH_SOURCE[0]:-}" ] && [ -f "${BASH_SOURCE[0]}" ]; then
    REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    REPO_DIR=""
fi

log_info "Starting Limmireu AGY & Development Environment Provisioning..."
log_info "Target User: $(whoami) (UID: $(id -u))"
log_info "Target HOME: ${HOME}"

# ------------------------------------------------------------------------------
# 1. Directory Tree Initialization
# ------------------------------------------------------------------------------
log_info "Initializing target directory structure..."
mkdir -p "${HOME}/.local/bin"
mkdir -p "${HOME}/.gemini/antigravity-cli/brain"
mkdir -p "${HOME}/.gemini/config/rules"
mkdir -p "${HOME}/.gemini/config/skills/mcp-and-skills-guide"
mkdir -p "${HOME}/go/bin"

export PATH="${HOME}/.local/bin:${HOME}/go/bin:/usr/local/go/bin:${PATH}"

# ------------------------------------------------------------------------------
# 2. Helper to fetch file (from local repo or fallback to GitHub raw)
# ------------------------------------------------------------------------------
get_file() {
    local rel_path="$1"
    local dest_path="$2"

    if [ -n "${REPO_DIR}" ] && [ -f "${REPO_DIR}/${rel_path}" ]; then
        cp "${REPO_DIR}/${rel_path}" "${dest_path}"
    else
        log_info "Fetching ${rel_path} from remote repository..."
        curl -fsSL "${RAW_BASE_URL}/${rel_path}" -o "${dest_path}"
    fi
}

# ------------------------------------------------------------------------------
# 3. Install Antigravity CLI (agy)
# ------------------------------------------------------------------------------
log_info "Verifying Google Antigravity CLI (agy)..."
if command -v agy >/dev/null 2>&1; then
    log_success "agy is already installed: $(command -v agy) ($(agy --version 2>/dev/null || echo 'active'))"
else
    log_info "Installing agy via official Google bootstrap..."
    if curl -fsSL https://antigravity.google/cli/install.sh | bash; then
        log_success "Google Antigravity CLI installed successfully."
    else
        log_error "Failed to install agy via official bootstrap script."
        exit 1
    fi
fi

# ------------------------------------------------------------------------------
# 4. Install uv and Python Tooling
# ------------------------------------------------------------------------------
log_info "Verifying uv / uvx Python manager..."
if ! command -v uv >/dev/null 2>&1; then
    log_info "Installing Astral uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="${HOME}/.local/bin:${PATH}"
fi

if command -v uv >/dev/null 2>&1; then
    log_success "uv is ready: $(uv --version)"
    # Install Hugging Face Hub CLI via uv tool
    if ! command -v hf >/dev/null 2>&1; then
        log_info "Installing huggingface-hub CLI via uv..."
        uv tool install huggingface-hub || log_warn "Failed to install huggingface-hub via uv tool."
    fi
else
    log_warn "uv installation could not be completed."
fi

# ------------------------------------------------------------------------------
# 5. Verify and Install Golang (HEAVY Tech Stack Rule)
# ------------------------------------------------------------------------------
log_info "Verifying Golang toolchain..."
if ! command -v go >/dev/null 2>&1; then
    log_info "Golang not detected. Checking if apt-get is available..."
    if command -v apt-get >/dev/null 2>&1 && [ "$(id -u)" -eq 0 ]; then
        apt-get update -qq && apt-get install -y -qq golang-go
    elif command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
        sudo apt-get update -qq && sudo apt-get install -y -qq golang-go
    else
        log_info "Downloading standalone Go binary archive (1.23.2)..."
        GO_TAR="/tmp/go.tar.gz"
        curl -fsSL https://go.dev/dl/go1.23.2.linux-amd64.tar.gz -o "${GO_TAR}"
        tar -C "${HOME}/.local" -xzf "${GO_TAR}"
        rm -f "${GO_TAR}"
        export PATH="${HOME}/.local/go/bin:${PATH}"
    fi
fi

if command -v go >/dev/null 2>&1; then
    log_success "Golang is ready: $(go version)"
else
    log_warn "Golang could not be installed automatically. Please install Go manually if needed."
fi

# ------------------------------------------------------------------------------
# 6. Verify Node / npx (Required for MCP Servers)
# ------------------------------------------------------------------------------
log_info "Verifying Node.js and npx runtime..."
if command -v npx >/dev/null 2>&1; then
    log_success "Node.js / npx is ready: $(node -v) / npx $(npx -v)"
else
    log_warn "npx not found. Some MCP servers (puppeteer, github, gitlab, gmail) require Node.js."
fi

# ------------------------------------------------------------------------------
# 7. Install GCP Calculator MCP Server & Utilities
# ------------------------------------------------------------------------------
log_info "Deploying GCP Calculator MCP server & maintenance utilities..."
get_file "bin/gcp-calculator-mcp" "${HOME}/.local/bin/gcp-calculator-mcp"
get_file "bin/clean_brain_archive.sh" "${HOME}/.local/bin/clean_brain_archive.sh"
get_file "bin/update_gcp_pricing.sh" "${HOME}/.local/bin/update_gcp_pricing.sh"

chmod +x "${HOME}/.local/bin/gcp-calculator-mcp"
chmod +x "${HOME}/.local/bin/clean_brain_archive.sh"
chmod +x "${HOME}/.local/bin/update_gcp_pricing.sh"
log_success "Binaries deployed to ${HOME}/.local/bin."

# ------------------------------------------------------------------------------
# 8. Deploy Gemini & AGY Configuration and Rules
# ------------------------------------------------------------------------------
log_info "Deploying Antigravity CLI configuration and Limmireu Pipeline rules..."

# 8.1 settings.json
SETTINGS_TEMPLATE="/tmp/settings.json.template"
get_file "gemini-config/settings.json.template" "${SETTINGS_TEMPLATE}"
sed "s|__HOME__|${HOME}|g" "${SETTINGS_TEMPLATE}" > "${HOME}/.gemini/antigravity-cli/settings.json"
rm -f "${SETTINGS_TEMPLATE}"

# 8.2 mcp_config.json
MCP_TEMPLATE="/tmp/mcp_config.json.template"
get_file "gemini-config/mcp_config.json.template" "${MCP_TEMPLATE}"
sed "s|__HOME__|${HOME}|g" "${MCP_TEMPLATE}" > "${HOME}/.gemini/config/mcp_config.json"
rm -f "${MCP_TEMPLATE}"

# 8.3 GEMINI.md, gcp_pricing.json, rules, skills
get_file "gemini-config/GEMINI.md" "${HOME}/.gemini/config/GEMINI.md"
get_file "gemini-config/gcp_pricing.json" "${HOME}/.gemini/config/gcp_pricing.json"
get_file "gemini-config/rules/limmireu-pipeline.md" "${HOME}/.gemini/config/rules/limmireu-pipeline.md"
get_file "gemini-config/skills/mcp-and-skills-guide/SKILL.md" "${HOME}/.gemini/config/skills/mcp-and-skills-guide/SKILL.md"

log_success "AGY configurations, MCP servers, and pipeline rules deployed successfully."

# ------------------------------------------------------------------------------
# 9. Configure Shell Environment & Aliases (.bashrc)
# ------------------------------------------------------------------------------
log_info "Configuring bash shell environment..."
BASHRC="${HOME}/.bashrc"

BASH_MARKER="# >>> Limmireu AGY Configuration >>>"
if [ -f "$BASHRC" ] && grep -Fq "$BASH_MARKER" "$BASHRC"; then
    log_info "Bashrc already contains Limmireu AGY configuration. Skipping append."
else
    cat << 'EOF' >> "$BASHRC"

# >>> Limmireu AGY Configuration >>>
export PATH="$HOME/.local/bin:$HOME/.local/go/bin:$HOME/go/bin:/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"

alias agy="$HOME/.local/bin/agy"
alias ll="ls -alF --color=auto"
alias gs="git status -sb"
alias gl="git log --oneline --graph --decorate -n 15"
alias agy-clean="$HOME/.local/bin/clean_brain_archive.sh"
alias agy-pricing-update="$HOME/.local/bin/update_gcp_pricing.sh"
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
# <<< Limmireu AGY Configuration <<<
EOF
    log_success "Appended environment variables and aliases to ${BASHRC}."
fi

# ------------------------------------------------------------------------------
# 10. Summary Verification
# ------------------------------------------------------------------------------
echo ""
echo -e "${C_CYAN}================================================================${C_RESET}"
echo -e "${C_CYAN}🎉 Limmireu AGY Codespace Environment Provisioning Completed! 🎉${C_RESET}"
echo -e "${C_CYAN}================================================================${C_RESET}"
echo -e "• agy binary       : $(command -v agy 2>/dev/null || echo "${HOME}/.local/bin/agy")"
echo -e "• GCP Calc MCP     : ${HOME}/.local/bin/gcp-calculator-mcp"
echo -e "• AGY Settings     : ${HOME}/.gemini/antigravity-cli/settings.json"
echo -e "• MCP Config       : ${HOME}/.gemini/config/mcp_config.json"
echo -e "• Pipeline Rules   : ${HOME}/.gemini/config/rules/limmireu-pipeline.md"
echo -e "• Global Prompt    : ${HOME}/.gemini/config/GEMINI.md"
echo -e "${C_CYAN}================================================================${C_RESET}"
echo -e "Type ${C_GREEN}agy${C_RESET} in your terminal to launch Antigravity!"
echo ""
