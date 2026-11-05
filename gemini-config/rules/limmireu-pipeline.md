# Limmireu Pipeline Global Rules

[Tech_Stack & Code_Std]
- LIGHT: bash (set -euo pipefail, 로깅/오류처리 엄수)
- HEAVY/System: Golang 필수 (Python 금지, go.mod 호환, gofmt, 에러핸들링 엄수)

[Infra(IaC) & Cost]
- IaC: 인프라 프로비저닝 시 Terraform 최우선 활용.
- TF State: 로컬 State 금지. 활용 서비스 환경에 맞는 Remote Backend 및 State Locking 구성.
- Security: Secret 하드코딩 금지. Security Agent 매뉴얼 기반 보안 구성 및 수정.
- 비용(Cost) 최우선. GCP Pricing Calculator 검증. Cloud Run/Compute Engine 권장 및 완료 자원 자동 정리.

[Logging & Monitor]
- 아키텍처: App/DB 연동 환경은 Log4j 형태(레벨링/구조화) 적용. 파이프라인/스크립트 환경은 Jenkins 형태(단계별 status.log + 상세 processing.log)로 이원화.
- 모니터링/알림: 장애(EOF) 시 로그 컨텍스트(Status+Error Tail)를 AI Studio API(Gemma 4 2B, Serverless)에 주입. 분석된 RCA 및 조치 매뉴얼 이메일 자동 발송 (민감정보 마스킹).
- 정리: KST 00:00(UTC 15:00) 또는 VM 종료 시 `~/.gemini/antigravity-cli/brain` 내 구형 폴더 .zip 압축 후 삭제.

[ML/DL & MLOps]
- Model & Dataset: 릴리즈 시 Hugging Face(HF) Model Hub에 모델 업로드. 안정성 검증 완료된 데이터셋은 HF Datasets에 업로드.
- Backup (MLflow): 최종 완성 시 HF 제반 기능을 활용하여 MLflow 트래킹 내역 및 아티팩트의 완벽한 백업본으로 구성.

[Figma_MCP & UI_Fidelity]
- Target: 캔버스 전체 파싱 절대 금지. `Copy link to selection`으로 특정 노드 ID 타겟팅 필수[cite: 1].
- Node ID: `-`를 `:`로 변환, `/design/` 대신 `/file/` 경로 호환성 확보[cite: 1].
- Hierarchy: 문서 -> 선택 ID 내부(오토레이아웃 속성 중심)로 계층적 탐색[cite: 1].
- Payload: `layoutMode`, `itemSpacing`, `padding*`, `style`, `fills` 유지. 베지에 곡선 등 메타데이터 제외[cite: 1].
- Fidelity: UI/UX 리디자인 및 임의 속성 추론 절대 금지 (Zero Creative Liberty)[cite: 1].
- AutoLayout: `HUG`(`w-fit`), `FILL`(`flex-1`/`w-full`), `FIXED`(`w-[Npx]`) 엄격 적용[cite: 1].
- Tailwind: 어림잡기 금지, `gap-[Npx]`, `p-[Npx]` 등 대괄호 기반 정확한 수치 매핑 필수[cite: 1].
- Workflow: 1단계 토큰 추출(Token Extraction), 2단계 레이아웃 구조 조립(Structural Assembly) 분리 진행[cite: 1].
- Cross-Check: VLM(Visual-Language Model) 활용하여 렌더링 이미지와 코드의 100% 일치 교차 검증[cite: 1].

[Git_Workflow & GitOps]
- Branch: GitFlow 방법론 엄격 준수 (main, develop, feature, release, hotfix).
- Release: 릴리즈 진행 시 GitOps 파이프라인 최대한 활용.
- 기록원칙: 논의/결정/RCA 원격 Issue/Wiki 기록 필수 (로컬 방치 금지). 선검증 100% 완료 후 Push.
- Issue: 템플릿 [1.개요 2.의사결정 3.문제점 4.구현상세 5.검증결과] 적용. CLI로 관리.
- Wiki (구조/SOP): 아키텍처/파이프라인 명세 반영.
- Commit: Conventional Commits `type(scope): summary (#issue)`. 하단 `Closes #issue` 필수.

[PM_Governance]
- 아이디어/회의록: 원격 Issue 등록 및 Wiki/docs 크로스링크 필수.
- PM/구현 책임자: limmireu1214@gmail.com 단독 지정 (GitLab:@mireu-lab, GitHub:@Mireu-Lab).
- 할당: Issue 헤더에 담당자 명시 및 CLI(`--assignee`) 할당 필수.