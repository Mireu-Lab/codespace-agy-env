# Codespace AGY Environment (임미르식 Codespace AGY 개발 환경 구성)

[![GitHub Codespaces](https://img.shields.io/badge/GitHub-Codespaces-brightgreen?logo=github)](https://github.com/features/codespaces)
[![Google Antigravity](https://img.shields.io/badge/Antigravity-AGY-blue?logo=google)](https://antigravity.google)
[![Go Version](https://img.shields.io/badge/Go-1.23+-00ADD8?logo=go)](https://go.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **프로젝트 매니저 (Project Manager)**: `limmireu1214@gmail.com`  
> **구현 책임자 (Implementation Owner)**: `limmireu1214@gmail.com`  

본 저장소는 **Google Antigravity CLI (`agy`)** 및 **Limmireu Pipeline Global Rules** 기반의 완전한 AI 개발 환경을 **GitHub Codespaces** 환경에 자동 배포하기 위한 올인원 Dotfiles 리포지토리입니다.
비용 예측 및 FinOps 엔지니어링 도구로 **[gcp-calculator-cli](https://github.com/Mireu-workflow/gcp-calculator-cli)** 공식 설치 가이드를 준수하여 빌드 및 연동을 수행합니다.

---

## 📌 주요 구성 및 환경 사양

| 컴포넌트 | 세부 내용 및 버전 | 비고 |
| :--- | :--- | :--- |
| **Antigravity CLI** | Google Antigravity CLI (`agy`) 최신 flat native build | 공식 부트스트랩 자동 연동 |
| **Pipeline Rules** | 임미르식 글로벌 룰 (`GEMINI.md`, `limmireu-pipeline.md`) | `~/.gemini/config/` 배치 (Zero-Hardcoding) |
| **AGY User Config** | 사용자 테마 및 글로벌 권한 (`config.json`) | Dark Seed Theme, Clean Script Auto-Grant |
| **Plugins** | Chrome DevTools Plugin (`chrome-devtools-plugin`) | 6종 개발 스킬 포함 (A11y, LCP, Memory Leak 등) |
| **Skills** | MCP & Skills 통합 가이드 (`mcp-and-skills-guide`) | 점진적 공개(Progressive Disclosure) |
| **GCP Calculator** | Golang 기반 고성능 MCP 서버 & CLI ([`gcp-calculator-cli`](https://github.com/Mireu-workflow/gcp-calculator-cli)) | 공식 소스 빌드 & 독립 실행 바이너리 배포 |
| **MCP Servers (7종)** | `gcp-calculator`, `puppeteer`, `google-workspace`, `memory`, `figma`, `duckduckgo`, `gmail` | `mcp_config.json` 자동 동적 매핑 |
| **Python & MLOps** | Astral `uv`, `uvx`, `huggingface-hub` CLI (`hf`) | 최신 격리 가상환경 및 툴체인 |
| **Heavy Stack** | Golang 1.23+ 툴체인 및 빌드 환경 | Limmireu Global Rule 1 충족 |
| **Infra & IaC** | Terraform, GitLab CLI (`glab`) | Limmireu Global Rule 2, 6 충족 |
| **Shell & Alias** | `agy`, `ll`, `gs`, `gl`, `gco`, `gcb`, `gcp-calc`, `agy-pricing-update`, `agy-clean`, `agy-sync` | `~/.bashrc` 자동 등록 |

---

## 🚀 Quick Start & 적용 방법

### 방법 1. GitHub Codespaces 개인 Dotfiles로 등록 (가장 추천 ⭐)

GitHub 계정에 등록해 두면, **어떤 리포지토리에서 Codespaces를 생성하든 상관없이** 항상 자동으로 `install.sh`가 실행되어 동일한 개발 환경이 100% 자동 구성됩니다.

1. GitHub 상단 프로필 클릭 -> **Settings** 이동
2. 좌측 메뉴에서 **Codespaces** 선택
3. **Dotfiles** 항목으로 스크롤:
   - ☑️ **Automatically install dotfiles** 체크
   - **Repository**: `Mireu-Lab/codespace-agy-env` 선택
4. 이후 새로 생성하는 모든 GitHub Codespaces에서 `agy`와 전체 개발 환경이 즉시 로드됩니다.

---

### 방법 2. 기존 Codespaces 터미널에서 원클릭 즉시 설치

이미 열려 있는 Codespaces나 임의의 Ubuntu/Debian Linux 컨테이너 환경에서 아래 명령어를 한 줄 입력하면 즉시 전체 환경이 배포됩니다:

```bash
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/install.sh | bash
```

설치 완료 후 터미널에 환경을 반영하고 사용합니다:
```bash
source ~/.bashrc
agy
```

---

### 방법 3. 신규/기존 다른 프로젝트에 DevContainer로 포함

다른 리포지토리에서도 동일한 개발 환경을 구성하려면 프로젝트 루트에 본 저장소의 `.devcontainer/` 설정을 추가합니다:

```bash
# 대상 프로젝트 루트에서 실행
mkdir -p .devcontainer
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/.devcontainer/devcontainer.json -o .devcontainer/devcontainer.json
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/.devcontainer/postCreateCommand.sh -o .devcontainer/postCreateCommand.sh
chmod +x .devcontainer/postCreateCommand.sh
```

이후 GitHub Codespaces를 열거나 VS Code의 **Dev Containers: Reopen in Container**를 실행하면 전체 환경이 100% 자동 프로비저닝됩니다.

---

## 🛠️ GCP Calculator MCP & CLI 설치 및 연동 가이드

본 환경은 **[gcp-calculator-cli](https://github.com/Mireu-workflow/gcp-calculator-cli)** 의 공식 인스톨 가이드에 따라 구성됩니다.

### 1. Installation & Build

소스 리포지토리에서 직접 빌드하거나 사전 컴파일된 바이너리를 활용합니다 (`install.sh`에서 자동 처리):

```bash
git clone https://github.com/Mireu-workflow/gcp-calculator-cli.git
cd gcp-calculator-cli
go build -o ~/.local/bin/gcp-calculator-mcp main.go
chmod +x ~/.local/bin/gcp-calculator-mcp
```

### 2. MCP Server Configuration (`mcp_config.json`)

`~/.gemini/config/mcp_config.json`에 `gcp-calculator` 서버가 기본 등록됩니다:

```json
{
  "mcpServers": {
    "gcp-calculator": {
      "command": "/home/codespace/.local/bin/gcp-calculator-mcp",
      "args": [
        "server"
      ]
    }
  }
}
```

### 3. CLI Usage & Examples

터미널에서 `gcp-calc` (또는 `gcp-calculator-mcp`)를 통해 직접 GCP 비용을 산출할 수 있습니다:

```bash
# 1. Compute Engine VM (Seoul region + 3-Year CUD 할인 적용)
gcp-calc compute -machine e2-standard-4 -region asia-northeast3 -commitment 3-year

# 2. Cloud Storage (Seoul region + Standard 500GB)
gcp-calc storage -class standard -gb 500

# 3. Dynamic Universal GCP Service Evaluation (115+ 제품 지원)
gcp-calc service "Sole-tenant Nodes" '{"nodes": 2, "hours_per_month": 730, "region": "asia-northeast3", "commitment": "3-year"}'

# 4. BigQuery Data Warehouse 견적 산출
gcp-calc bigquery -query-tb 10 -storage-gb 500

# 5. MCP Stdio Server 기동
gcp-calc server
```

### 4. MCP Tools Specification (에이전트 호출 지원 8종 도구)

| Tool Name | Description |
| :--- | :--- |
| `calculate_compute_engine` | Calculate monthly cost for GCP Compute Engine VMs, GPUs, Cloud TPUs, CUD, Spot, and Disks. |
| `calculate_cloud_run` | Calculate monthly cost for GCP Cloud Run serverless applications including free tier allowances. |
| `calculate_storage` | Calculate monthly cost for GCP Cloud Storage tiers and network egress. |
| `calculate_gke` | Calculate monthly cost for Google Kubernetes Engine (Autopilot and Standard node pools). |
| `calculate_cloud_sql` | Calculate monthly cost for Cloud SQL instances (MySQL, PostgreSQL, SQL Server, High Availability). |
| `calculate_bigquery` | Calculate monthly cost for BigQuery active storage and on-demand query data scanned. |
| `calculate_gcp_service` | Universal evaluator dynamically querying the complete 115+ GCP service catalog. |
| `estimate_infrastructure` | Full infrastructure cost estimation and FinOps optimization recommendations. |

---

## 📂 저장소 디렉토리 구조

```text
codespace-agy-env/
├── .devcontainer/              # 다른 저장소 범용 배포용 DevContainer 표준 템플릿
│   ├── devcontainer.json       # Go, Terraform, gh feature 및 VS Code 확장 설정
│   ├── postCreateCommand.sh    # Codespace 기동 후 install.sh 자동 실행 스크립트
│   └── README.md               # DevContainer 적용 가이드
├── install.sh                  # Codespace Dotfiles 규격 원클릭 설치 스크립트
├── README.md                   # 본 가이드 문서
├── todo.md                     # 프로젝트 요구사항 및 체크리스트
├── bin/                        # 사용자 바이너리 및 유틸리티
│   ├── gcp-calculator-mcp      # GCP 계산기 MCP 서버 & CLI (Go 단일 네이티브 바이너리)
│   ├── update_gcp_pricing.sh   # 최신 GCP 가격 정책 업데이트 스크립트
│   ├── clean_brain_archive.sh  # Brain 디렉토리 자동 압축/정리 스크립트
│   └── agy-sync                # 세션 동기화 CLI
├── gemini-config/              # AGY & Gemini 에이전트 설정 배포 템플릿
│   ├── settings.json.template  # dangerouslySkipPermissions, trustedWorkspaces 동적 매핑
│   ├── config.json.template    # AGY 테마, 사용자 설정 및 권한 부여 템플릿
│   ├── mcp_config.json.template# gcp-calculator 포함 7종 MCP 설정 템플릿
│   ├── GEMINI.md               # 전역 시스템 프롬프트 및 Limmireu Pipeline 규칙 (영문)
│   ├── gcp_pricing.json        # GCP 리소스 단가 데이터베이스 (pricing.json)
│   ├── catalog.json            # 115+ GCP 전 제품 카탈로그 데이터베이스
│   ├── .migrated               # AGY 마이그레이션 플래그
│   ├── rules/
│   │   └── limmireu-pipeline.md# 임미르식 글로벌 엔지니어링 룰
│   ├── skills/
│   │   └── mcp-and-skills-guide/
│   │       └── SKILL.md        # MCP & Skills 안내 가이드
│   └── plugins/
│       └── chrome-devtools-plugin/ # Chrome DevTools 플러그인 (6개 스킬 포함)
└── dotfiles/                   # Dotfiles 보조 설정
    ├── .bashrc_addon           # PATH 및 편의 alias 세팅
    └── .gitconfig              # Git 기본 설정
```

---

## 📜 라이선스 및 거버넌스

- **PM / 유지보수 담당자**: `limmireu1214@gmail.com` (`@Mireu-Lab`)
- 본 프로젝트는 [Limmireu Pipeline Global Rules](gemini-config/rules/limmireu-pipeline.md)를 엄격히 준수합니다.
