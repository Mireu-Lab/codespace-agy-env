# Limmireu AGY DevContainer 템플릿

이 디렉토리(`.devcontainer/`)는 임의의 다른 Git 저장소(리포지토리)에서 **Google Antigravity CLI (`agy`)** 및 **Limmireu Pipeline Global Rules**, **GCP Calculator MCP & CLI (`gcp-calculator-cli`)** 개발 환경을 동일하게 100% 자동 구성하기 위한 표준 DevContainer 템플릿입니다.

---

## 🚀 다른 저장소에 적용하는 방법

대상 프로젝트의 루트 디렉토리에서 아래 명령어를 실행하면 본 템플릿이 자동으로 구성됩니다:

```bash
# 대상 프로젝트 루트에서 실행
mkdir -p .devcontainer
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/.devcontainer/devcontainer.json -o .devcontainer/devcontainer.json
curl -fsSL https://raw.githubusercontent.com/Mireu-Lab/codespace-agy-env/main/.devcontainer/postCreateCommand.sh -o .devcontainer/postCreateCommand.sh
chmod +x .devcontainer/postCreateCommand.sh
```

구성 완료 후 해당 저장소를 **GitHub Codespaces**로 열거나 VS Code의 **Dev Containers: Reopen in Container**를 실행하면 전체 환경이 자동으로 배포됩니다.

---

## 📦 자동 프로비저닝되는 주요 컴포넌트

1. **Google Antigravity CLI (`agy`)**: 최신 flat native build 자동 연동
2. **GCP Calculator MCP & CLI ([`gcp-calculator-cli`](https://github.com/Mireu-workflow/gcp-calculator-cli))**:
   - 공식 소스 클론 & Go 빌드 자동화 (`~/.local/bin/gcp-calculator-mcp`)
   - 115+ GCP 서비스 오프라인 카탈로그 (`catalog.json`) 및 단가 DB (`gcp_pricing.json`) 배포
   - 터미널 단축 명령어 (`gcp-calc`) 및 MCP 서버 자동 구성
3. **Limmireu Pipeline Global Rules & Settings**:
   - `GEMINI.md`, `limmireu-pipeline.md`, `settings.json`, `config.json`
   - Chrome DevTools 플러그인 (`chrome-devtools-plugin`) 및 6종 스킬
4. **개발 언어 및 인프라 도구**:
   - Golang 1.23+, Astral `uv`/`uvx`, `huggingface-hub` CLI (`hf`)
   - Terraform, GitHub CLI (`gh`), GitLab CLI (`glab`), Node.js/npx
