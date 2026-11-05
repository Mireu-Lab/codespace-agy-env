---
name: mcp-and-skills-guide
description: >-
  Provides a comprehensive global guide on MCP (Model Context Protocol) and Skills in Antigravity (AGY).
  Use this skill whenever the user asks about MCP, MCP servers, Skills, rules, plugins, or how to customize Antigravity capabilities.
---

# MCP (Model Context Protocol) & Skills Guide

This document explains how **MCP Servers** and **Skills** work in Antigravity (AGY) and how to configure them globally or within a workspace.

---

## 1. Skills (스킬)

### **개념 및 특징**
- **스킬(Skill)**은 에이전트의 능력과 작업 절차(Runbook, 절차서)를 확장하는 모듈형 패키지입니다.
- **점진적 공개 (Progressive Disclosure)**: 스킬 전체 내용이 처음에 프롬프트에 모두 포함되지 않으며, `name`과 `description`만 항시 인식됩니다. 에이전트나 사용자가 해당 스킬이 필요하다고 판단할 때만 `SKILL.md` 파일과 하위 세부 문서를 로드하여 토큰 소비를 최적화합니다.

### **디렉토리 구조**
```text
skills/<skill-name>/
├── SKILL.md          # 필수: YAML frontmatter (name, description) 및 절차 안내
├── scripts/          # 선택: 실행 가능한 헬퍼 스크립트
├── examples/         # 선택: 예시 및 참조 코드
├── resources/        # 선택: 추가 템플릿/자산
└── references/       # 선택: 세부 매뉴얼 문서
```

### **설정 위치 및 우선순위**
1. **작업 공간(Workspace)**: 프로젝트 루트의 `.agents/skills/` (팀 공유용)
2. **글로벌(Global)**: `~/.gemini/config/skills/` (모든 프로젝트에 적용)
3. **기본 내장(Built-in)**: CLI/IDE에 기본 탑재된 스킬

---

## 2. MCP (Model Context Protocol) Servers

### **개념 및 특징**
- **MCP**는 AI 모델이 외부 데이터 소스, API, 커스텀 도구(Tool) 및 리소스(Resource)와 안전하게 양방향 통신할 수 있게 해주는 표준 프로토콜입니다.
- 연동된 MCP 서버의 도구들은 에이전트의 도구 모음(Toolsets)에 자동으로 포함되어 직접 호출이 가능합니다.

### **전송 방식 (Transport Mechanisms)**
1. **Stdio Transport (로컬)**: 로컬 CLI 명령어나 스크립트(`node`, `python3`, 실행 바이너리 등)를 프로세스로 실행하여 표준 입출력(stdio)으로 통신.
2. **SSE Transport (원격)**: HTTP Server-Sent Events (SSE)를 통해 원격 서버 endpoints와 통신.

### **설정 방법 (`mcp_config.json`)**
- **글로벌 위치**: `~/.gemini/config/mcp_config.json`
- **구조 예시**:
```json
{
  "mcpServers": {
    "duckduckgo": {
      "command": "uvx",
      "args": ["duckduckgo-mcp-server"]
    },
    "custom-remote": {
      "serverUrl": "https://mcp.example.com/sse"
    }
  }
}
```

---

## 3. 커스텀 커스터마이징 요약

| 구분 | 주요 파일/폴더 | 주요 용도 |
| :--- | :--- | :--- |
| **Rules** | `GEMINI.md`, `AGENTS.md` | 코드 스타일, API 제약 조건, 지침 강제 |
| **Skills** | `skills/<name>/SKILL.md` | 다단계 작업 절차, 런북, 워크플로우 가이드 |
| **Plugins** | `plugins/<name>/plugin.json` | Rules, Skills, MCP 설정을 하나의 묶음으로 패키징 |
| **MCP** | `mcp_config.json` | 외부 도구 및 DB/API 커넥터 연동 |
