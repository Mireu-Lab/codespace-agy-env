# Limmireu Pipeline Global Rules (임미르식 프로그램 구현 파이프라인 글로벌 룰)

## 1. 언어 및 기술 스택 선정 (Language & Tech Stack)
- **LIGHT 구현**: Shell Script (`bash`) 활용 (`set -euo pipefail`, 명확한 로깅 및 오류 처리 작성).
- **HEAVY 구현 / 시스템 구축 / 실험 구현**: **Golang (Go)** 필수 활용.
  - Python 등 기타 언어 활용 금지 (단, 명시적 사용자 요청 시 예외 적용).
  - Go 프로젝트 작성 시 Target Go Version에 맞춰 호환되는 라이브러리와 모듈(`go.mod`)을 구성하고 `gofmt` 및 엄격한 에러 핸들링 준수.

## 2. 인프라(IaC) 및 비용 최우선 원칙 (Infra IaC, Security & Cost First)
- **IaC (Infrastructure as Code)**: 인프라 프로비저닝 시 **Terraform** 최우선 활용.
- **TF State**: 로컬 State 관리 금지. 프로젝트/서비스 환경에 맞는 **Remote Backend 및 State Locking** 구성.
- **보안 (Security)**: Secret 하드코딩 절대 금지. Security Agent 매뉴얼 기반 보안 구성 및 수정.
- **시스템/인프라 구성**: 컴퓨팅 및 인프라 설계 시 **GCP 계산기(GCP Pricing Calculator)**를 활용하여 최적의 사양과 최저 비용 고안.
- **실험 구현 프로젝트**: **GCP Cloud Run** 또는 **GCP Compute Engine**을 활용하되, 항상 **COST 최우선**으로 컴퓨팅 자원을 선정.
- **자원 정리 (Automated Cleanup)**: 실험 및 프로세스 완료 후 미사용 VM/컨테이너가 남지 않도록 즉시 정리하거나 자동 종료(Auto-termination) 설정.

## 3. 프로세스 모니터링, 로깅 및 알림 (Logging, Monitoring & Notification)
- **아키텍처 로깅 표준**:
  - App/DB 연동 환경: Log4j 형태(레벨링/구조화 로깅) 적용.
  - 파이프라인/스크립트 환경: Jenkins 형태(단계별 status.log + 상세 processing.log)로 이원화.
- **장시간 프로세스 (Long-Running Tasks)**:
  - 실행 시간이 긴 작업 진행 시 **1시간 간격** 및 **프로세스 완료/종료 시점**에 상태(Status) 알림 전송.
  - 알림 채널: **Google Chat (Webhook)** 또는 **Gmail (SMTP/API)** 활용.
- **예외 발생 즉시 알림**: 작업 실패 또는 에러 발생 시 1시간을 기다리지 않고 즉시 에러 로그(Tail output)와 함께 알림 전송.
- **VM 종료 및 디렉토리 정리 규칙 (VM Shutdown & Brain Cleanup)**:
  - **KST 00:00시 (UTC 15:00시) VM 종료 및 자동 정리**: VM 종료 시점 또는 KST 00:00 정기 스케줄 실행 시 `/home/limmireu1214/.gemini/antigravity-cli/brain` 내 오래된 디렉토리를 Zip 파일(`*.zip`)로 압축 보관하고 원본 디렉토리를 즉시 삭제(Cleanup)할 것.

## 4. 머신러닝/딥러닝 및 MLOps (ML/DL & MLOps)
- **Model & Dataset**: 릴리즈 시 **Hugging Face(HF) Model Hub**에 모델 업로드. 안정성 검증 완료된 데이터셋은 **HF Datasets**에 업로드.

## 5. 피그마 MCP 및 UI 일치도 규칙 (Figma_MCP & UI_Fidelity)
- **Target**: 캔버스 전체 파싱 절대 금지. `Copy link to selection`으로 특정 노드 ID 타겟팅 필수.
- **Node ID**: `-`를 `:`로 변환, `/design/` 대신 `/file/` 경로 호환성 확보.
- **Hierarchy**: 문서 -> 선택 ID 내부(오토레이아웃 속성 중심)로 계층적 탐색.
- **Payload**: `layoutMode`, `itemSpacing`, `padding*`, `style`, `fills` 유지. 베지에 곡선 등 메타데이터 제외.
- **Fidelity**: UI/UX 리디자인 및 임의 속성 추론 절대 금지 (Zero Creative Liberty).
- **AutoLayout**: `HUG`(`w-fit`), `FILL`(`flex-1`/`w-full`), `FIXED`(`w-[Npx]`) 엄격 적용.
- **Tailwind**: 어림잡기 금지, `gap-[Npx]`, `p-[Npx]` 등 대괄호 기반 정확한 수치 매핑 필수.
- **Workflow**: 1단계 토큰 추출(Token Extraction), 2단계 레이아웃 구조 조립(Structural Assembly) 분리 진행.
- **Cross-Check**: VLM(Visual-Language Model) 활용하여 렌더링 이미지와 코드의 100% 일치 교차 검증.

## 6. Git 워크플로우, GitOps 및 지식 공유 (Git_Workflow, GitOps & Knowledge Sharing)
- **브랜치 전략 (Branch Strategy)**: **GitFlow 방법론** 엄격 준수 (`main`, `develop`, `feature`, `release`, `hotfix`).
- **릴리즈 전략 (Release)**: 릴리즈 진행 시 **GitOps 파이프라인**을 최대한 활용.
- **적용 대상 (Target Platforms & CLIs)**:
  - **GitHub**: `gh` CLI (`gh issue create/view/comment`, git-based wiki, `git push`)
  - **GitLab**: `glab` CLI (`glab issue create/view/note`, wiki API/git wiki, `git push`)
  - **Hugging Face Hub**: `hf` CLI (`hf discussions create/info/comment/close`, repo docs, `git push` / `hf upload`)
- **논의 내용 및 구현 목적/사항 공유 원칙 (Discussion & Knowledge Sharing)**:
  - 개발/수정 과정에서 논의된 기술적 검토 내용, 설계 의사결정(Design Decision), 대안 검토, 그리고 구현 목적(Purpose/Objective)과 실제 구현 사항(Implementation Details)은 세션/로컬 대화에만 남겨두지 않고 **반드시 원격 저장소의 이슈(Issue/Discussions) 또는 위키(Wiki)를 통해 기록하고 공유**해야 한다.
- **사전 검증 원칙 (Verification First)**:
  - 장애/버그 해결 및 기능 추가 시 원인 분석(RCA), 코드 구현, 로컬/원격 빌드 및 실제 데이터/환경 기반 검증을 100% 완료한 후 이슈 등록, 커밋, 푸시를 진행할 것.
- **플랫폼별 이슈/토론 및 코멘트 등록 표준 (Structured Issue & Discussion Workflow)**:
  - 이슈 템플릿: `[1. 개요 및 목적, 2. 논의 및 의사결정 사항, 3. 분석된 문제점, 4. 구현 및 수정 상세, 5. 검증 결과]` 필수 적용 및 CLI로 선등록 관리.
- **위키(Wiki) 및 아키텍처 문서화 표준 (Wiki / Architecture Documentation Workflow)**:
  - 전체 시스템 구조, 파이프라인 데이터 흐름, 영구 참조 가이드는 위키에 페이지를 생성하거나 갱신하여 문서화.
- **커밋 메시지 표준 및 이슈 연동 (Conventional Commits with Issue Linking)**:
  - Conventional Commits 형식 엄격 준수: `<type>(<scope>): <summary> (#<issue_iid>)`
  - 커밋 하단(Footer)에 이슈 자동 종료 키워드 필수 명시 (`Closes #<issue_iid>`).

## 7. 회의록 및 구현 아이디어 이슈화 & 프로젝트 매니저 지정 규칙 (Meeting Minutes, Ideas as Issues & PM Governance)
- **회의록 및 구현 아이디어의 이슈(Issue) 등록 의무화**:
  - 프로젝트 설계, 아키텍처 결정 레코드(ADR), 구현 회의록(Meeting Minutes), 차세대 구현 아이디어(Implementation Ideas)는 반드시 원격 저장소의 공식 이슈(Issue / Discussions)로 등록하고 위키/문서(`docs/`, `README.md`)와 상호 링크하여 관리할 것.
- **프로젝트 매니저 및 구현 책임자 단독 지정 원칙**:
  - 모든 프로젝트의 이슈 생성, 구현 담당자(Assignee), 프로젝트 매니저(PM), 작업 승인자는 오직 **`limmireu1214@gmail.com`** (GitLab: `@mireu-lab`, GitHub: `@Mireu-Lab`) 단독으로만 지정하여 등록해야 한다.
  - 이슈 본문 메타데이터 헤더에 표준 양식 명시 필수:
    ```markdown
    * **프로젝트 매니저 (Project Manager)**: limmireu1214@gmail.com
    * **구현 책임자 (Implementation Owner)**: limmireu1214@gmail.com
    ```
  - CLI를 통한 이슈 생성 시에도 반드시 `--assignee` 옵션(GitLab: `glab issue create ... --assignee mireu-lab`, GitHub: `gh issue create ... --assignee Mireu-Lab`)을 지정하여 해당 계정으로 공식 할당을 완료해야 한다.
