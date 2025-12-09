# 03 — Execution Guide (계획! · 실행! · 맥락축약! · 커밋!)

---

## A. 계획! (작업 계획)
1. 입력: `/tasks/prd-[project].md`, `/tasks/context-contraction.md`
2. 상위 작업(5–10개) 생성 후:
[상위 작업 검토]
상위 작업 N개가 생성되었습니다.
파일: /tasks/tasks-prd-[project].md
검토 후 "계획!" 을 다시 입력하면 하위 작업이 자동 생성됩니다.
3. 사용자가 다시 `계획!` 입력 시 하위 작업 생성 (번호: 1.1, 1.2 …)

---

## B. 실행! (작업 수행)
- **`실행!`** : 계획된 다음 단계 순차 실행  
- **`실행! N.M`** : 특정 하위 작업 TDD 기반 수행  

### 수행 절차
1. 테스트 설계 → 최소 구현 → 검증  
2. 실패 시 **Fail-Fast Recovery** 실행  
3. 성공 시 tasks-prd-*.md 체크박스 `[x]` 표시
---

## C. 맥락축약! (Context Contraction)
- `/tasks/context-contraction.md`에 append:
YYYY-MM-DD HH:mm (N.M 완료)
What: …
Architecture Delta: +/~/-
Test Coverage: …
Known Issues: …
Next Focus: …

## D. 커밋! (GitHub Commit & 승인)
1. 완료된 작업 기준으로 Atomic Commit  
2. Conventional Commits 적용  
3. 브랜치 전략 예:
   - main: 배포용  
   - develop: 기본 개발  
   - feature/<task> 또는 issue/I1  
4. 리뷰 및 승인 후 병합, 결과 로그 context-contraction.md에 기록

---


## E. 문제 트랙 (Problem Track)
- 하위 작업이 2회 이상 실패하거나, 1시간 이상 정체되면 `I1`, `I2` 트랙으로 분기.  
- 경로: `/tasks/prd-<project>-I1.md`, `/tasks/tasks-prd-<project>-I1.md`  
- 동일한 명령 세트 사용 (`분석!`, `계획!`, `실행!`, `축약!`, `커밋!`)  
- 해결 후:
  - 메인 PRD 수정  
  - 원래 Task를 “RESUMED (I1 resolved)”로 변경  
  - `실행!` 으로 메인 루틴 재개

