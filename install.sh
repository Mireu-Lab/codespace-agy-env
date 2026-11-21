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
GCP_CALC_REPO="https://github.com/Mireu-workflow/gcp-calculator-cli.git"

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
mkdir -p "${HOME}/.gemini/config/plugins"
mkdir -p "${HOME}/go/bin"

export PATH="${HOME}/.local/bin:${HOME}/.local/go/bin:${HOME}/go/bin:/usr/local/go/bin:${PATH}"

# ------------------------------------------------------------------------------
# 2. Helper to fetch file / directory (from local repo or fallback to GitHub raw)
# ------------------------------------------------------------------------------
get_file() {
    local rel_path="$1"
    local dest_path="$2"

    mkdir -p "$(dirname "${dest_path}")"
    if [ -n "${REPO_DIR}" ] && [ -f "${REPO_DIR}/${rel_path}" ]; then
        cp "${REPO_DIR}/${rel_path}" "${dest_path}"
    else
        log_info "Fetching ${rel_path} from remote repository..."
        curl -fsSL "${RAW_BASE_URL}/${rel_path}" -o "${dest_path}"
    fi
}

copy_dir() {
    local rel_path="$1"
    local dest_path="$2"

    mkdir -p "${dest_path}"
    if [ -n "${REPO_DIR}" ] && [ -d "${REPO_DIR}/${rel_path}" ]; then
        cp -r "${REPO_DIR}/${rel_path}"/* "${dest_path}/" 2>/dev/null || true
    fi
}

# ------------------------------------------------------------------------------
# 3. Clean up legacy deprecated binaries if present
# ------------------------------------------------------------------------------
rm -f "${HOME}/.local/bin/cloud-calc" "${HOME}/.local/bin/cloud-pricing-mcp" 2>/dev/null || true

# ------------------------------------------------------------------------------
# 4. Install Antigravity CLI (agy)
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
# 5. Install uv and Python Tooling
# ------------------------------------------------------------------------------
log_info "Verifying uv / uvx Python manager..."
if ! command -v uv >/dev/null 2>&1; then
    log_info "Installing Astral uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="${HOME}/.local/bin:${PATH}"
fi

if command -v uv >/dev/null 2>&1; then
    log_success "uv is ready: $(uv --version)"
    if ! command -v hf >/dev/null 2>&1; then
        log_info "Installing huggingface-hub CLI via uv..."
        uv tool install huggingface-hub || log_warn "Failed to install huggingface-hub via uv tool."
    fi
else
    log_warn "uv installation could not be completed."
fi

# ------------------------------------------------------------------------------
# 6. Verify and Install Golang (HEAVY Tech Stack Rule)
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
# 7. Verify Node / npx & VCS CLIs (glab, terraform)
# ------------------------------------------------------------------------------
log_info "Verifying Node.js and npx runtime..."
if command -v npx >/dev/null 2>&1; then
    log_success "Node.js / npx is ready: $(node -v) / npx $(npx -v)"
else
    log_warn "npx not found. Some MCP servers (puppeteer, memory, gmail) require Node.js."
fi

log_info "Verifying GitLab CLI (glab)..."
if ! command -v glab >/dev/null 2>&1; then
    log_info "glab not detected. Installing standalone binary..."
    GLAB_VER="1.46.1"
    curl -fsSL "https://gitlab.com/gitlab-org/cli/-/releases/v${GLAB_VER}/downloads/glab_${GLAB_VER}_Linux_x86_64.tar.gz" -o /tmp/glab.tar.gz 2>/dev/null && \
    tar -xzf /tmp/glab.tar.gz -C /tmp bin/glab 2>/dev/null && \
    mv /tmp/bin/glab "${HOME}/.local/bin/glab" 2>/dev/null && \
    chmod +x "${HOME}/.local/bin/glab" 2>/dev/null && \
    rm -rf /tmp/glab.tar.gz /tmp/bin || true
fi
if command -v glab >/dev/null 2>&1; then
    log_success "GitLab CLI (glab) is ready: $(glab --version 2>&1 | head -n 1)"
fi

log_info "Verifying Terraform CLI..."
if ! command -v terraform >/dev/null 2>&1; then
    log_info "Installing standalone Terraform binary..."
    TF_VER="1.9.8"
    curl -fsSL "https://releases.hashicorp.com/terraform/${TF_VER}/terraform_${TF_VER}_linux_amd64.zip" -o /tmp/tf.zip 2>/dev/null && \
    unzip -q -o /tmp/tf.zip -d "${HOME}/.local/bin" 2>/dev/null && \
    chmod +x "${HOME}/.local/bin/terraform" 2>/dev/null && \
    rm -f /tmp/tf.zip || true
fi
if command -v terraform >/dev/null 2>&1; then
    log_success "Terraform is ready: $(terraform -version | head -n 1)"
fi

# ------------------------------------------------------------------------------
# 8. Install & Build GCP Pricing Calculator MCP (https://github.com/Mireu-workflow/gcp-calculator-cli)
# ------------------------------------------------------------------------------
log_info "Installing GCP Calculator MCP according to official installation guide..."
TARGET_BIN="${HOME}/.local/bin/gcp-calculator-mcp"
BUILD_SUCCESS=false

# 8.1 Primary Installation Method: Build directly from source repository
if command -v go >/dev/null 2>&1 && command -v git >/dev/null 2>&1; then
    log_info "Cloning and building gcp-calculator-cli from source (${GCP_CALC_REPO})..."
    TMP_BUILD_DIR="$(mktemp -d)"
    if git clone --depth 1 "${GCP_CALC_REPO}" "${TMP_BUILD_DIR}" 2>/dev/null; then
        (
            cd "${TMP_BUILD_DIR}"
            go build -v -o "${TARGET_BIN}" main.go
        )
        if [ -x "${TARGET_BIN}" ]; then
            log_success "Successfully built and installed gcp-calculator-mcp from source."
            BUILD_SUCCESS=true
        fi
    fi
    rm -rf "${TMP_BUILD_DIR}"
fi

# 8.2 Fallback Installation Method: Deploy pre-compiled bundled binary
if [ "${BUILD_SUCCESS}" != "true" ]; then
    log_warn "Source build unavailable or failed. Deploying bundled standalone binary..."
    get_file "bin/gcp-calculator-mcp" "${TARGET_BIN}"
    chmod +x "${TARGET_BIN}"
fi

# 8.3 Maintenance scripts
get_file "bin/clean_brain_archive.sh" "${HOME}/.local/bin/clean_brain_archive.sh"
get_file "bin/update_gcp_pricing.sh" "${HOME}/.local/bin/update_gcp_pricing.sh"
get_file "bin/agy-sync" "${HOME}/.local/bin/agy-sync"

chmod +x "${TARGET_BIN}"
chmod +x "${HOME}/.local/bin/clean_brain_archive.sh"
chmod +x "${HOME}/.local/bin/update_gcp_pricing.sh"
chmod +x "${HOME}/.local/bin/agy-sync"
log_success "GCP Calculator and binaries deployed to ${HOME}/.local/bin."

# ------------------------------------------------------------------------------
# 9. Deploy Gemini & AGY Configuration, Plugins, Skills, and Rules
# ------------------------------------------------------------------------------
log_info "Deploying Antigravity CLI configuration, Plugins, and Limmireu Pipeline rules..."

# 9.1 settings.json (Antigravity CLI Core Settings)
SETTINGS_TEMPLATE="/tmp/settings.json.template"
get_file "gemini-config/settings.json.template" "${SETTINGS_TEMPLATE}"
sed "s|__HOME__|${HOME}|g" "${SETTINGS_TEMPLATE}" > "${HOME}/.gemini/antigravity-cli/settings.json"
rm -f "${SETTINGS_TEMPLATE}"

# 9.2 config.json (AGY User Configuration)
CONFIG_TEMPLATE="/tmp/config.json.template"
get_file "gemini-config/config.json.template" "${CONFIG_TEMPLATE}"
sed "s|__HOME__|${HOME}|g" "${CONFIG_TEMPLATE}" > "${HOME}/.gemini/config/config.json"
rm -f "${CONFIG_TEMPLATE}"

# 9.3 mcp_config.json (MCP Servers)
MCP_TEMPLATE="/tmp/mcp_config.json.template"
get_file "gemini-config/mcp_config.json.template" "${MCP_TEMPLATE}"
sed "s|__HOME__|${HOME}|g" "${MCP_TEMPLATE}" > "${HOME}/.gemini/config/mcp_config.json"
rm -f "${MCP_TEMPLATE}"

# 9.4 GEMINI.md, gcp_pricing.json, catalog.json, rules, skills, plugins
get_file "gemini-config/GEMINI.md" "${HOME}/.gemini/config/GEMINI.md"
get_file "gemini-config/gcp_pricing.json" "${HOME}/.gemini/config/gcp_pricing.json"
get_file "gemini-config/catalog.json" "${HOME}/.gemini/config/catalog.json"
get_file "gemini-config/rules/limmireu-pipeline.md" "${HOME}/.gemini/config/rules/limmireu-pipeline.md"
get_file "gemini-config/skills/mcp-and-skills-guide/SKILL.md" "${HOME}/.gemini/config/skills/mcp-and-skills-guide/SKILL.md"
get_file "gemini-config/.migrated" "${HOME}/.gemini/config/.migrated"

# 9.5 Chrome DevTools Plugin
copy_dir "gemini-config/plugins/chrome-devtools-plugin" "${HOME}/.gemini/config/plugins/chrome-devtools-plugin"

log_success "AGY configurations, plugins, skills, and pipeline rules deployed successfully."

# ------------------------------------------------------------------------------
# 10. Configure Shell Environment & Aliases (.bashrc)
# ------------------------------------------------------------------------------
log_info "Configuring bash shell environment..."
BASHRC="${HOME}/.bashrc"

BASH_MARKER="# >>> Limmireu AGY Configuration >>>"
# Clean up any existing older block first to ensure consistency
if [ -f "$BASHRC" ] && grep -Fq "$BASH_MARKER" "$BASHRC"; then
    sed -i "/# >>> Limmireu AGY Configuration >>>/,/# <<< Limmireu AGY Configuration <<</d" "$BASHRC"
fi

cat << 'EOF' >> "$BASHRC"

# >>> Limmireu AGY Configuration >>>
export PATH="$HOME/.local/bin:$HOME/.local/go/bin:$HOME/go/bin:/usr/local/go/bin:$PATH"
export GOPATH="$HOME/go"

alias agy="$HOME/.local/bin/agy"
alias ll="ls -alF --color=auto"
alias gs="git status -sb"
alias gl="git log --oneline --graph --decorate -n 15"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcp-calc="$HOME/.local/bin/gcp-calculator-mcp"
alias agy-clean="$HOME/.local/bin/clean_brain_archive.sh"
alias agy-pricing-update="$HOME/.local/bin/update_gcp_pricing.sh"
alias agy-sync="$HOME/.local/bin/agy-sync"
export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
# <<< Limmireu AGY Configuration <<<
EOF
log_success "Configured environment variables and aliases in ${BASHRC}."

# ------------------------------------------------------------------------------
# 11. Summary Verification
# ------------------------------------------------------------------------------
echo ""
echo -e "${C_CYAN}================================================================${C_RESET}"
echo -e "${C_CYAN}🎉 Limmireu AGY Codespace Environment Provisioning Completed! 🎉${C_RESET}"
echo -e "${C_CYAN}================================================================${C_RESET}"
echo -e "• agy binary       : $(command -v agy 2>/dev/null || echo "${HOME}/.local/bin/agy")"
echo -e "• GCP Calc MCP     : ${HOME}/.local/bin/gcp-calculator-mcp (alias: gcp-calc)"
echo -e "• Pricing DB       : ${HOME}/.gemini/config/gcp_pricing.json"
echo -e "• Catalog DB       : ${HOME}/.gemini/config/catalog.json"
echo -e "• AGY Settings     : ${HOME}/.gemini/antigravity-cli/settings.json"
echo -e "• AGY Config       : ${HOME}/.gemini/config/config.json"
echo -e "• MCP Config       : ${HOME}/.gemini/config/mcp_config.json"
echo -e "• Pipeline Rules   : ${HOME}/.gemini/config/rules/limmireu-pipeline.md"
echo -e "• Global Prompt    : ${HOME}/.gemini/config/GEMINI.md"
echo -e "• Plugins          : ${HOME}/.gemini/config/plugins/chrome-devtools-plugin"
echo -e "${C_CYAN}================================================================${C_RESET}"
echo -e "Type ${C_GREEN}agy${C_RESET} in your terminal to launch Antigravity!"
echo ""
