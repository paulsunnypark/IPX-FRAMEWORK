# 01 — Poly Vibe Coding Method: Principles & Flow

## 철학
Poly Vibe Coding은 "속도와 명확성"을 동시에 추구한다.  
AI와 개발자가 **동일한 계약서(OpenSpec)**를 공유하고,  
모든 결정이 **검증 가능한 테스트(TDD)**로 연결되며,  
모든 변화가 **맥락(Context Contraction)**으로 남는다.

---

## 5대 원칙
1. **Spec-Driven** — 문서화된 계약(OpenSpec)으로부터만 구현한다.  
2. **Context-Aware** — 상태를 기억하고 공유한다.  
3. **TDD** — 테스트가 구현을 이끈다.  
4. **Fail-Fast** — 오류는 즉시 노출되고 복구는 신속하다.  
5. **Interface-First & DI** — 구조는 계약으로 정의된다.  

---

## 명령어 루틴
| 명령 | 역할 |
|------|------|
| `분석!` | PRD(OpenSpec) 생성 |
| `계획!` | 상위/하위 작업 자동 생성 |
| `실행!` | 다음 단계 실행 |
| `실행! N.M` | 특정 하위 작업 실행 |
| `맥락축약!` | 결과 축약 로그 작성 |
| `커밋!` | GitHub 커밋 및 승인 |

---

## Context Contraction 포맷
YYYY-MM-DD HH:mm (작업 N.M 완료)
What: 한 줄 요약
 Architecture Delta: +/~/- 항목
 Test Coverage: 주요 테스트 파일·케이스
 Known Issues: 미해결 항목
 Next Focus: 다음 실행! 포인트
---

## Fail-Fast Recovery Protocol
1. 오류 로그 및 원인 요약  
2. 제안 옵션: `수정!`, `재분석!`, `보류!`  
3. 사용자가 선택 시 해당 프로세스 실행  
> 외부 의존성(API키, 인프라 등)은 자동 `보류!` 처리.


