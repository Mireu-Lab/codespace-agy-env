# Limmireu Pipeline Global Rules

## 1. Language & Tech Stack
- **LIGHT Implementation**: Use Shell Script (`bash`) strictly adhering to `set -euo pipefail`, explicit logging, and robust error handling.
- **HEAVY Implementation / System Engineering / Experiments**: **Golang (Go)** is strictly mandatory.
  - Using other languages like Python is prohibited (unless explicitly requested by the user).
  - Go projects must declare a compatible Go version in `go.mod`, use compatible libraries, format code with `gofmt`, and enforce strict error handling.
- **Strict Zero-Hardcoding Principle (하드코딩 전면 금지)**:
  - **Zero Hardcoding Across All Implementations**: Hardcoding any values—including secrets, API keys, credentials, IP addresses, ports, URLs/endpoints, local absolute file paths, and magic numbers/strings—is strictly prohibited.
  - **Dynamic & Externalized Configuration**: All variables, environmental settings, and credentials must be injected dynamically via environment variables, CLI flags, or external configuration files (`config.yaml`, `.env`) with proper validation and robust defaults. Shell scripts must parameterize arguments or env vars at the top, and Go code must use structured config models.

## 2. Infrastructure as Code (IaC), Security & Cost First
- **IaC (Infrastructure as Code)**: **Terraform** must be prioritized for infrastructure provisioning.
- **TF State**: Local state management is prohibited. Configure **Remote Backend and State Locking** appropriate for the deployment environment.
- **Security & Secret Management**: Hardcoding secrets is strictly prohibited. Secrets, credentials, and sensitive tokens must never be committed to repository code or state files. Configure and modify security settings based on the Security Agent manual and platform secret managers.
- **GCP Pricing Calculator & FinOps CLI**:
  - Prioritize the globally installed **GCP Pricing Calculator MCP Server & CLI Tool (`gcp-calculator-mcp`, https://github.com/Mireu-workflow/gcp-calculator-cli)** when designing infrastructure, estimating quotes, or calculating costs for Google Cloud services (Compute Engine, Cloud Run, GKE, Cloud SQL, BigQuery, Storage).
  - Enforce a self-contained, CLI-First and MCP-ready design capable of executing directly in terminal/shell environments or via MCP stdio protocol.
- **Experimental Projects**: Utilize **GCP Cloud Run** or **GCP Compute Engine**, always prioritizing **COST FIRST** when selecting compute resources.
- **Automated Cleanup**: Ensure unused VMs/containers are torn down immediately or configured with auto-termination upon completion of experiments or jobs.

## 3. Logging, Monitoring & Notification
- **Architecture Logging Standard**:
  - Application/Database environments: Apply structured Log4j-style logging with log levels.
  - Pipeline/Script environments: Dual-logging standard following Jenkins style (step-by-step `status.log` + detailed `processing.log`).
- **Long-Running Tasks**:
  - Dispatch status notifications at **1-hour intervals** and upon **task completion/termination**.
  - Monitoring & Alerting Channel: Utilize **GCP Cloud Monitoring** (Alerting Policies, Notification Channels, and Log-based Metrics).
- **Immediate Error Notification**: On job failure or exception, trigger an immediate alert via GCP Cloud Monitoring (e.g., Log-based Alerting Policy) with the error tail log without waiting for the 1-hour interval.
- **Priority-based VM Autonomous Shutdown & Brain Cleanup**:
  - **Priority 0 (Immediate Autonomous Shutdown on Task Completion)**: For unattended/nightly tasks, the agent creates `/tmp/antigravity_task.lock` during execution to shield against watchdog intervention. Upon 100% completion and final response delivery, execute safe shutdown routine if configured.
  - **Priority 1 (30-Minute Idle Watchdog Safety Net)**: An autonomous watchdog runs via crontab every 5 minutes. If no task lock exists, no SSH/interactive session is active, and no background build/eval jobs exist for 30 consecutive minutes, safe shutdown triggers.
  - **Common Safe Shutdown Routine & Brain Cleanup**: Prior to poweroff, automatically archive `brain/` directories into `*.zip`, sync backups, write Jenkins-style dual-logs (`status.log` + `processing.log`), and execute poweroff/cleanup to eliminate idle compute costs.

## 4. Machine Learning, Deep Learning & MLOps
- **Model & Dataset**: Upload validated models to the **Hugging Face (HF) Model Hub** upon release. Upload verified datasets to **HF Datasets**.
- **Backup (MLflow)**: Leverage Hugging Face features upon completion to establish complete backup mirrors of MLflow tracking history and artifacts.

## 5. Figma MCP & UI Fidelity Rules
- **Target**: Parsing the entire canvas is strictly prohibited. Always target specific node IDs via `Copy link to selection`.
- **Node ID**: Replace `-` with `:`, and ensure `/file/` path compatibility instead of `/design/`.
- **Hierarchy**: Hierarchically traverse from document root into the selected node ID (focusing on autolayout properties).
- **Payload**: Retain `layoutMode`, `itemSpacing`, `padding*`, `style`, and `fills`. Exclude non-essential metadata such as bezier curves.
- **Fidelity**: UI/UX redesign or arbitrary property guessing is strictly forbidden (Zero Creative Liberty).
- **AutoLayout**: Strictly map `HUG` (`w-fit`), `FILL` (`flex-1`/`w-full`), and `FIXED` (`w-[Npx]`).
- **Tailwind**: No estimations; explicitly use bracket notation for exact measurements (`gap-[Npx]`, `p-[Npx]`).
- **Workflow**: Separate work into Stage 1 Token Extraction and Stage 2 Structural Assembly.
- **Cross-Check**: Validate 100% visual fidelity between the rendered image and generated code using Visual-Language Models (VLM).

## 6. Git Workflow, GitOps & Knowledge Sharing
- **Branch Strategy**: Strictly follow **GitFlow methodology** (`main`, `develop`, `feature`, `release`, `hotfix`).
- **Release Strategy**: Maximize utilization of **GitOps pipelines** during release cycles.
- **Target Platforms & CLIs**:
  - **GitHub**: `gh` CLI (`gh issue create/view/comment`, git-based wiki, `git push`)
  - **GitLab**: `glab` CLI (`glab issue create/view/note`, wiki API/git wiki, `git push`)
  - **Hugging Face Hub**: `hf` CLI (`hf discussions create/info/comment/close`, repo docs, `git push` / `hf upload`)
- **Knowledge Sharing & Documentation Principle**:
  - All technical investigations, architectural design decisions (ADR), alternatives evaluated, project objectives, and implementation details discussed during development must be documented and shared via **remote repository Issues/Discussions or Wiki pages**, rather than left only in local conversation sessions.
- **Verification First Principle**:
  - When fixing bugs or adding features, complete root cause analysis (RCA), code implementation, local/remote builds, and end-to-end verification against real data/environments before creating issues, committing, or pushing code.
- **Structured Issue & Discussion Workflow**:
  - Mandatory Issue Template: `[1. Overview & Purpose, 2. Discussions & Decisions, 3. Analyzed Issues, 4. Implementation Details, 5. Verification Results]`. Create and manage issues via CLI beforehand.
- **Wiki / Architecture Documentation Workflow**:
  - Document overall system architectures, pipeline data flows, and permanent reference guides in dedicated Wiki pages or repo documentation.
- **Conventional Commits with Issue Linking**:
  - Strictly adhere to Conventional Commits: `<type>(<scope>): <summary> (#<issue_iid>)`.
  - Include issue closing keywords in the commit footer (`Closes #<issue_iid>`).

## 7. Meeting Minutes, Ideas as Issues & PM Governance
- **Mandatory Issue Tracking for Minutes & Ideas**:
  - Project architecture designs, ADRs, meeting minutes, and next-generation implementation ideas must be formally registered as remote repository Issues or Discussions, with cross-links to Wiki/documentation (`docs/`, `README.md`).
- **Sole Project Manager & Implementation Owner**:
  - The creator, assignee, Project Manager (PM), and reviewer for all project issues must be exclusively assigned to **`limmireu1214@gmail.com`** (GitLab: `@mireu-lab`, GitHub: `@Mireu-Lab`).
  - Mandatory metadata header in the issue body:
    ```markdown
    * **Project Manager**: limmireu1214@gmail.com
    * **Implementation Owner**: limmireu1214@gmail.com
    ```
  - When creating issues via CLI, always include the `--assignee` flag (GitLab: `glab issue create ... --assignee mireu-lab`, GitHub: `gh issue create ... --assignee Mireu-Lab`) to complete formal assignment.
