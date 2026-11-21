# Limmireu Pipeline Global Rules

[Tech_Stack & Code_Std]
- LIGHT: Shell Script (`bash`) strictly adhering to `set -euo pipefail`, explicit logging, and robust error handling.
- HEAVY/System: Golang (Go) is mandatory. Prohibit other languages like Python unless explicitly requested. Enforce go.mod compatibility, gofmt, and strict error handling.
- Zero-Hardcoding: Hardcoding values (secrets, tokens, paths, URLs, IPs, ports, magic numbers/strings) is strictly prohibited across all code and scripts. Always externalize parameters via environment variables, CLI flags, or config files.

[Infra(IaC) & Cost]
- IaC: Terraform must be prioritized for infrastructure provisioning.
- TF State: Prohibit local state. Configure Remote Backend and State Locking appropriate for deployment environments.
- Security: Secret hardcoding is strictly prohibited. Configure security according to Security Agent manuals.
- Cost First & GCP Pricing: Prioritize the globally installed `gcp-calculator-mcp` (GCP Pricing Calculator MCP Server & CLI Tool, https://github.com/Mireu-workflow/gcp-calculator-cli) for Google Cloud infrastructure design, price estimation, and FinOps cost calculations. Enforce CLI-First and MCP-integrated design. Prioritize Cloud Run / Compute Engine with automated resource cleanup.

[Logging & Monitor]
- Architecture: Apply Log4j-style hierarchical/structured logging in App/DB environments. Apply Jenkins-style dual logging (step-by-step status.log + detailed processing.log) in pipeline/script environments.
- Monitoring/Notification: Integrate with GCP Cloud Monitoring (Alerting Policies, Notification Channels, Log-based Metrics). Trigger immediate alerts with error tail logs upon failure without waiting for the 1-hour interval.
- Cleanup & Shutdown: Priority-based 2-tier VM shutdown. Priority 0: Agent autonomously triggers safe shutdown routine upon task completion (shielded via `/tmp/antigravity_task.lock`). Priority 1: idle watchdog triggers shutdown after 30 mins of complete idle (no SSH, no builds, no locks). Both routines compress `brain/`, sync to backup archive, dual-log, and execute cleanup.

[ML/DL & MLOps]
- Model & Dataset: Upload validated models to Hugging Face (HF) Model Hub upon release. Upload verified datasets to HF Datasets.
- Backup (MLflow): Utilize Hugging Face capabilities upon completion as a comprehensive backup mirror of MLflow tracking history and artifacts.

[Figma_MCP & UI_Fidelity]
- Target: Full canvas parsing is strictly prohibited. Always target specific node IDs via `Copy link to selection`.
- Node ID: Replace `-` with `:`, and ensure `/file/` path compatibility instead of `/design/`.
- Hierarchy: Hierarchical traversal from root into the selected node ID (focusing on autolayout properties).
- Payload: Maintain `layoutMode`, `itemSpacing`, `padding*`, `style`, and `fills`. Exclude bezier curves and redundant metadata.
- Fidelity: Zero Creative Liberty; no redesigns or arbitrary guesses.
- AutoLayout: Strictly enforce `HUG` (`w-fit`), `FILL` (`flex-1`/`w-full`), and `FIXED` (`w-[Npx]`).
- Tailwind: No approximations; enforce exact bracket notations (`gap-[Npx]`, `p-[Npx]`).
- Workflow: Stage 1 Token Extraction followed by Stage 2 Structural Assembly.
- Cross-Check: Use Visual-Language Models (VLM) to verify 100% visual fidelity between the rendered image and code.

[Git_Workflow & GitOps]
- Branch: Strictly adhere to GitFlow methodology (`main`, `develop`, `feature`, `release`, `hotfix`).
- Release: Maximize use of GitOps pipelines during releases.
- Knowledge Sharing: Document decisions, discussions, and RCA in remote repository Issues/Wiki (never keep only in local chat). Verify 100% before push.
- Issue: Standard template `[1. Overview & Purpose, 2. Discussions & Decisions, 3. Analyzed Issues, 4. Implementation Details, 5. Verification Results]`. Manage via CLI.
- Wiki (Architecture/SOP): Document system architecture, data flows, and permanent guidelines in Wiki pages.
- Commit: Conventional Commits `<type>(<scope>): <summary> (#issue)`. Append `Closes #issue` in footer.

[PM_Governance]
- Ideas / Meeting Minutes: Mandatory issue tracking on remote repositories with documentation cross-links.
- PM / Implementation Owner: Solely assigned to `limmireu1214@gmail.com` (GitLab: `@mireu-lab`, GitHub: `@Mireu-Lab`).
- Assignment: Explicitly declare PM/Owner metadata in the issue header and assign via CLI (`--assignee`).
