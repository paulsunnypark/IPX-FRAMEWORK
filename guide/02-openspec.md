# 02 — OpenSpec Guide (Phase 0: 분석!)

## 목표
제품 목표 및 기존 코드베이스를 조사하여,  
기술적 계약(PRD, OpenSpec)을 생성한다.

---

## 절차
1. 입력: `분석!`  
2. 맥락 로드: `/tasks/context-contraction.md`  
3. 조사 항목:
   - 아키텍처 및 DI 구조  
   - 인터페이스/포트 정의  
   - 재사용 가능한 서비스  
   - 잠재적 리스크 및 영향 파일  
4. 산출:
   - `/tasks/prd-[project].md`  
   - 요약을 context-contraction.md에 append  

---

## OpenSpec 템플릿
```markdown
# PRD – <project>
## One Goal
단일 명확한 목표 정의

## System Context
- Framework / Infra / API 관계도  
- 주요 컴포넌트 및 데이터 흐름  

## Acceptance Criteria
- 정상 / 오류 / 경계 / 보안 조건  

## Contracts
- API / DTO / DB Schema / Event 구조  

## Risk & Assumption
- 리스크, 미해결 이슈, 가정  

## Done Definition
- 테스트 / 성능 / 로그 조건


