## AI Skills 모음집

> 평소 자주 활용하는 skills 를 모아놓은 저장소입니다. 외부 좋은 skills 를 포함하여 평소 생각했던 skill 까지 취합중입니다.

---

### 적용 방법

vercel cli 를 활용하면 쉽게 적용할 수 있습니다.

- 적용하고자 하는 프로젝트에 아래 명령어를 실행시키시면 됩니다.
- 모든 skills 를 전부 적용하기 전에 space bar 를 통해 적용시키고 싶은 skills 를 선택하여 적용할 수 있습니다.

```bash
npx skills add Yelihi/ai-skills
```

### 현재 작성된 skills 목록

| 스킬 | 설명 | 출처 |
|------|------|------|
| `spec-advisor` | 기획·도메인 모델 바탕으로 프론트엔드 기술 스택·상태관리 옵션 정리 및 트레이드오프 기반 추론·추천 (설계 파이프라인) | 자체 제작 |
| `architecture-design` | 선택된 스택 기반 server/client 경계·라우팅·상태배치·폴더 구조 설계 (FSD·ddd 참조, 설계 파이프라인) | 자체 제작 |
| `design-system-spec` | 디자인 토큰·컴포넌트 variant/state·접근성·반응형 규격화 및 spec 문서 작성 (설계 파이프라인) | 자체 제작 |
| `feature-checklist` | 기능 구현 직전 요구사항·경계·상태·엣지케이스·접근성·테스트 점검 체크리스트 작성 (설계 파이프라인) | 자체 제작 |
| `figma-to-tsx` | Figma 시안을 디자인 토큰에 매핑하여 TailwindCSS 컨벤션 준수 TSX로 변환 (구현 파이프라인) | 자체 제작 |
| `component-builder` | props 구조·폴더 위치·server/client 경계·순수성·코드 스타일을 갖춘 React 컴포넌트 작성·정제 (구현 파이프라인) | 자체 제작 |
| `type-checker` | 타입 에러·any 남용·null/undefined 미처리 점검 (tsc 실행, 검증 파이프라인) | 자체 제작 |
| `code-cleaner` | 런타임 견고성 점검 — 예외 처리·빈 화면/로딩/에러 상태 처리 (검증 파이프라인) | 자체 제작 |
| `code-quality` | 정적 품질 점검 — 중복(DRY)·네이밍·복잡도·가독성 (eslint 실행, 검증 파이프라인) | 자체 제작 |
| `a11y-checker` | 웹 접근성(WCAG) 집중 감사 — 시맨틱·키보드·포커스·ARIA·대비 (검증 파이프라인) | 자체 제작 |
| `performance-checker` | 에러 기록·성능 점검·우선순위 개선방향 제시 (검증 파이프라인) | 자체 제작 |
| `commit-convention-reviewer` | 프로젝트 커밋 컨벤션에 맞는 Git 커밋 메시지 생성 및 리뷰 | 자체 제작 |
| `clean-architecture` | FSD 기반 프로젝트 구조 설계 및 구현 가이드 | 자체 제작 |
| `karpathy-guidelines` | LLM 코딩 실수 방지를 위한 행동 지침 (과도한 추상화, 불필요한 변경 방지 등) | Karpathy |
| `deploy-to-vercel` | Vercel 배포 자동화 (CLI, git push, no-auth fallback 지원) | Vercel |
| `web-design-guidelines` | UI 코드의 웹 인터페이스 가이드라인 준수 여부 리뷰 | Vercel |
| `vercel-react-best-practices` | React/Next.js 성능 최적화 가이드 (58개 규칙, 8개 카테고리) | Vercel |
| `vercel-composition-patterns` | React 컴포지션 패턴 가이드 (boolean prop 남용 방지, compound component 등) | Vercel |
| `obsidian` | Obsidian 마크다운 파일 관리 및 구조화 가이드 | BitBonsai |
| `verify-pipeline` | `quickstart-custom-plate` 내 템플릿 또는 scaffold 로직 변경 후 전체 검증 파이프라인 실행 | 자체 제작 |
