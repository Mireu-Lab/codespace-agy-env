#!/usr/bin/env bash
# ==============================================================================
# Post-Creation Provisioning Script for GitHub Codespaces & DevContainers
# Applies Limmireu AGY CLI, MCP Servers, Pipeline Rules, and Dev Tooling
# ==============================================================================
set -euo pipefail

readonly C_RESET='\033[0m'
readonly C_BLUE='\033[0;34m'
readonly C_GREEN='\033[0;32m'
readonly C_YELLOW='\033[0;33m'
readonly C_RED='\033[0;31m'

log_info()    { echo -e "${C_BLUE}[INFO]${C_RESET} $*"; }
log_success() { echo -e "${C_GREEN}[SUCCESS]${C_RESET} $*"; }
log_warn()    { echo -e "${C_YELLOW}[WARN]${C_RESET} $*"; }
log_error()   { echo -e "${C_RED}[ERROR]${C_RESET} $*" >&2; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
AGY_ENV_RAW_BASE_URL="${AGY_ENV_RAW_BASE_URL:-https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main}"

export PATH="${HOME}/.local/bin:${HOME}/.local/go/bin:${HOME}/go/bin:/usr/local/go/bin:${PATH}"

# ------------------------------------------------------------------------------
# 1. Run Core AGY Environment Installer (Local Repo or Remote Fallback)
# ------------------------------------------------------------------------------
log_info "Starting Limmireu AGY Codespace Post-Create Provisioning..."
if [ -f "${REPO_ROOT}/install.sh" ]; then
    log_info "Found local installer at ${REPO_ROOT}/install.sh. Executing..."
    bash "${REPO_ROOT}/install.sh"
else
    log_warn "Local install.sh not found in ${REPO_ROOT}. Fetching from ${AGY_ENV_RAW_BASE_URL}..."
    curl -fsSL "${AGY_ENV_RAW_BASE_URL}/install.sh" | bash
fi

# ------------------------------------------------------------------------------
# 2. Apply Safe Git Defaults (Preserving Codespaces Native Credential Helper)
# ------------------------------------------------------------------------------
configure_git_defaults() {
    log_info "Configuring Git defaults (preserving existing Codespaces auth)..."

    if ! git config --global init.defaultBranch >/dev/null 2>&1; then
        git config --global init.defaultBranch main
    fi

    if ! git config --global pull.rebase >/dev/null 2>&1; then
        git config --global pull.rebase false
    fi

    if [ -f "${REPO_ROOT}/dotfiles/.gitconfig" ]; then
        local default_name default_email
        default_name="$(git config --file "${REPO_ROOT}/dotfiles/.gitconfig" user.name 2>/dev/null || true)"
        default_email="$(git config --file "${REPO_ROOT}/dotfiles/.gitconfig" user.email 2>/dev/null || true)"

        if ! git config --global user.name >/dev/null 2>&1 && [ -n "${default_name}" ]; then
            git config --global user.name "${default_name}"
        fi

        if ! git config --global user.email >/dev/null 2>&1 && [ -n "${default_email}" ]; then
            git config --global user.email "${default_email}"
        fi
    fi

    log_success "Git global defaults verified."
}

configure_git_defaults

# ------------------------------------------------------------------------------
# 3. Post-Create Verification Summary
# ------------------------------------------------------------------------------
verify_environment() {
    log_info "Verifying provisioned tools and AGY configuration files..."
    local missing=0

    local tools=(agy go node npx uv uvx terraform gh glab cloud-pricing-mcp gcp-calculator-mcp cloud-calc agy-sync)
    for tool in "${tools[@]}"; do
        if command -v "${tool}" >/dev/null 2>&1; then
            log_success "  [OK] tool: ${tool} -> $(command -v "${tool}")"
        else
            log_warn "  [WARN] tool not found in PATH: ${tool}"
        fi
    done

    local configs=(
        "${HOME}/.gemini/antigravity-cli/settings.json"
        "${HOME}/.gemini/config/mcp_config.json"
        "${HOME}/.gemini/config/GEMINI.md"
        "${HOME}/.gemini/config/gcp_pricing.json"
        "${HOME}/.gemini/config/rules/limmireu-pipeline.md"
        "${HOME}/.gemini/config/skills/mcp-and-skills-guide/SKILL.md"
    )
    for cfg in "${configs[@]}"; do
        if [ -f "${cfg}" ]; then
            log_success "  [OK] config: ${cfg}"
        else
            log_error "  [MISSING] config: ${cfg}"
            missing=$((missing + 1))
        fi
    done

    if [ "${missing}" -gt 0 ]; then
        log_error "${missing} required AGY configuration file(s) are missing."
        return 1
    fi

    log_success "All Codespace AGY configurations verified successfully."
}

verify_environment
