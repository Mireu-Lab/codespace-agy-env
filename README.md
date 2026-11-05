# Codespace AGY Environment (임미르식 Codespace AGY 개발 환경 구성)

[![GitHub Codespaces](https://img.shields.io/badge/GitHub-Codespaces-brightgreen?logo=github)](https://github.com/features/codespaces)
[![Google Antigravity](https://img.shields.io/badge/Antigravity-AGY-blue?logo=google)](https://antigravity.google)
[![Go Version](https://img.shields.io/badge/Go-1.23+-00ADD8?logo=go)](https://go.dev/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> **프로젝트 매니저 (Project Manager)**: `limmireu1214@gmail.com`  
> **구현 책임자 (Implementation Owner)**: `limmireu1214@gmail.com`  

본 저장소는 **Google Antigravity CLI (`agy`)** 및 **Limmireu Pipeline Global Rules** 기반의 완전한 AI 개발 환경을 **GitHub Codespaces** 환경에 그대로 복제/배포하기 위한 올인원 인스톨러 및 Dotfiles 리포지토리입니다.

---

## 📌 주요 구성 및 환경 사양

| 컴포넌트 | 세부 내용 및 버전 | 비고 |
| :--- | :--- | :--- |
| **Antigravity CLI** | Google Antigravity CLI (`agy`) 최신 flat native build | 공식 부트스트랩 자동 연동 |
| **Pipeline Rules** | 임미르식 글로벌 룰 (`GEMINI.md`, `limmireu-pipeline.md`) | `~/.gemini/config/` 배치 |
| **MCP Servers (11종)** | GCP Calculator, Puppeteer, GitHub, GitLab, Memory, Figma, DuckDuckGo, Gmail, Google Cloud/Workspace, KiCAD | `mcp_config.json` 자동 동적 매핑 |
| **GCP Calculator** | Golang 기반 고성능 MCP 서버 (`gcp-calculator-mcp`) + 오프라인 가격 DB | `$HOME/.local/bin` 자동 설치 |
| **Python & MLOps** | Astral `uv`, `uvx`, `huggingface-hub` CLI (`hf`) | 최신 격리 가상환경 도구 |
| **Heavy Stack** | Golang 1.23+ 툴체인 및 빌드 환경 | Limmireu Global Rule 1 충족 |
| **Infra & IaC** | Terraform, GitHub CLI (`gh`), GitLab CLI (`glab`) | Limmireu Global Rule 2, 6 충족 |
| **Shell & Alias** | `agy`, `ll`, `gs`, `gl`, `agy-clean`, `agy-pricing-update` | `~/.bashrc` 자동 등록 |

---

## 🚀 적용 방법 (3가지 지원)

### 방법 1. GitHub Codespaces 개인 Dotfiles로 등록 (가장 추천 ⭐)

GitHub 계정에 등록해 두면, **어떤 리포지토리에서 Codespaces를 생성하든 상관없이** 항상 자동으로 `install.sh`가 실행되어 동일한 개발 환경이 100% 자동 구성됩니다.

1. GitHub 상단 프로필 클릭 -> **Settings** 이동
2. 좌측 메뉴에서 **Codespaces** 선택
3. **Dotfiles** 항목으로 스크롤:
   - ☑️ **Automatically install dotfiles** 체크
   - **Repository**: `Mireu-Lab/codespace-agy-env` 선택
4. 이후 새로 생성하는 모든 GitHub Codespaces에서 `agy`와 전체 파이프라인 개발 환경이 즉시 로드됩니다.

---

### 방법 2. 기존 Codespaces 터미널에서 원클릭 즉시 설치

이미 열려 있는 Codespaces나 임의의 Ubuntu/Debian Linux 컨테이너 환경에서 아래 명령어를 한 줄 입력하면 즉시 전체 환경이 배포됩니다:

```bash
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/install.sh | bash
```

설치 완료 후 새 터미널을 열거나 다음을 실행하여 즉시 사용할 수 있습니다:
```bash
source ~/.bashrc
agy
```

---

### 방법 3. 신규/기존 프로젝트에 DevContainer로 포함

특정 프로젝트를 열 때 팀원 모두가 동일한 AGY 환경을 사용하도록 하려면, 프로젝트 루트에 본 저장소의 `.devcontainer/` 폴더를 복사합니다:

```bash
# 대상 프로젝트 루트에서 실행
mkdir -p .devcontainer
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/.devcontainer/devcontainer.json -o .devcontainer/devcontainer.json
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/.devcontainer/postCreateCommand.sh -o .devcontainer/postCreateCommand.sh
chmod +x .devcontainer/postCreateCommand.sh
```

---

## 📂 저장소 디렉토리 구조

```text
codespace-agy-env/
├── install.sh                  # Codespace Dotfiles 공식 규격 설치 스크립트 (원격/로컬 겸용)
├── README.md                   # 본 가이드 문서
├── .devcontainer/              # DevContainer 표준 템플릿
│   ├── devcontainer.json       # Go, Terraform, gh feature 및 확장 설정
│   └── postCreateCommand.sh    # Codespace 컨테이너 기동 후 자동 프로비저닝 스크립트
├── bin/                        # 사용자 바이너리 및 유틸리티
│   ├── gcp-calculator-mcp      # GCP 계산기 MCP 서버 (Go 네이티브 바이너리)
│   ├── update_gcp_pricing.sh   # 최신 GCP 가격 정책 업데이트 스크립트
│   └── clean_brain_archive.sh  # Brain 디렉토리 자동 압축/정리 스크립트
├── gemini-config/              # AGY & Gemini 에이전트 설정
│   ├── settings.json.template  # dangerouslySkipPermissions, trustedWorkspaces(/workspaces)
│   ├── mcp_config.json.template# $HOME 경로 동적 매핑 11종 MCP 설정
│   ├── GEMINI.md               # 전역 시스템 프롬프트 및 Limmireu Pipeline 규칙
│   ├── gcp_pricing.json        # GCP 리소스 단가 데이터베이스
│   ├── rules/
│   │   └── limmireu-pipeline.md# 임미르식 글로벌 엔지니어링 룰
│   └── skills/
│       └── mcp-and-skills-guide/
│           └── SKILL.md        # MCP & Skills 가이드
└── dotfiles/                   # Dotfiles 보조 설정
    ├── .bashrc_addon           # PATH 및 편의 alias 세팅
    └── .gitconfig              # Git 기본 인증 및 계정 설정
```

---

## 🧪 로컬 검증 및 기능 테스트

- **스크립트 구문 검사**: `bash -n install.sh` 통과 완료.
- **환경 변수 및 경로 매핑**: 하드코딩된 특정 사용자 홈(`/home/limmireu1214`)을 모두 배제하고 `$HOME` 및 `/workspaces` 동적 매핑 완료.
- **MCP 서버 연동**: Node (`npx`), Python (`uvx`), Go (`$HOME/.local/bin/gcp-calculator-mcp`) 간 원활한 상호작용 검증.

---

## 📜 라이선스 및 거버넌스

- **PM / 유지보수 담당자**: `limmireu1214@gmail.com` (`@Mireu-Lab`)
- 본 프로젝트는 [Limmireu Pipeline Global Rules](file:///home/limmireu1214/_projects/_gemini_rule/agy-pipeline.md)를 엄격히 준수합니다.
