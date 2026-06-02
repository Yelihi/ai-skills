# Library Decision Guide

Category-by-category option map for frontend stack selection. For each category: what decides it, the realistic options, and when each fits. Recommendations are defaults, not laws — the deciding tradeoff is always project-specific.

> State management has its own dedicated reference: `state-management-decision.md`. This file covers everything else and points there for the server/client state split.

## 1. Rendering Model → Meta-framework

The rendering model is the first and most load-bearing decision; everything else follows from it.

| Need | Rendering model | Recommendation |
|------|-----------------|----------------|
| SEO-critical, content + app, server data | RSC / SSR | **Next.js (App Router)** |
| Data-heavy app, web-standards, nested routes | SSR | **Remix / React Router 7** |
| Internal tool, dashboard, no SEO | CSR (SPA) | **Vite + React** |
| Mostly static content, islands of interactivity | SSG + islands | **Astro** |

Deciding tradeoffs:
- **SEO / first-paint matters** → server rendering (Next/Remix/Astro). Otherwise an SPA is simpler to reason about.
- **Streaming server data into the tree** → RSC (Next App Router) reduces client JS but makes the server/client boundary a real design surface (hand this to `architecture-design`).
- **Team unfamiliar with RSC** → an SSR or SPA model has a gentler model; weigh learning cost against bundle/data wins.

## 2. Routing

Mostly derived from the framework — an independent decision only for SPAs.

- **Next.js / Remix** → built-in file-based routing. Do not add a separate router.
- **Vite SPA** → **React Router** (mature, nested routes, loaders) or **TanStack Router** (type-safe routes + search params, first-class data loading). Pick TanStack Router when typed search-param state and built-in loaders matter; React Router when familiarity and ecosystem matter.

## 3. Server State (data fetching & caching)

Remote, async, cached data. See `state-management-decision.md` for the full server-vs-client split.

| Context | Recommendation |
|---------|----------------|
| RSC available (Next App Router) | Server Components + **server actions** for reads/mutations; add TanStack Query only for rich client-side caching needs |
| SPA / client-driven data | **TanStack Query** (powerful cache, mutations, invalidation) |
| Simple fetching, minimal API | **SWR** (lighter, hook-first) |
| GraphQL backend | **Apollo Client** or **urql** (urql when you want lighter weight) |

Do not store server data in a client global store. That is the most common architecture mistake — it duplicates the cache and desyncs.

## 4. Client State

Only genuinely local/global **UI** state. Full decision tree in `state-management-decision.md`. Summary:

- **Local component state** → `useState` / `useReducer`.
- **Shared, low-frequency** (theme, auth status, modals) → **Context** (split providers to avoid re-render storms).
- **Shared, frequent / cross-tree** → **Zustand** (simple store) or **Jotai** (atomic, bottom-up).
- **Large app, complex flows, devtools/middleware needs** → **Redux Toolkit**.
- **URL-owned state** (filters, pagination, tabs) → the router's search params, not a store.

## 5. Forms & Validation

- **Form library**: **React Hook Form** (performance via uncontrolled inputs, huge ecosystem) is the default. **TanStack Form** when you want full type-safety and framework-agnostic logic. Native form actions (RSC/Remix) can replace a form library for simple server-driven forms.
- **Schema / validation**: **Zod** (default — great DX, wide adoption) or **Valibot** (smaller bundle, modular). Share the schema between form validation and API boundary types. Pair with the form library via resolvers.

## 6. Styling

Coordinate the final decision with `design-system-spec`.

| Approach | When |
|----------|------|
| **Tailwind CSS** | Fast iteration, utility-first, design tokens via config — strong default |
| **CSS Modules** | Want plain CSS, scoped, zero runtime |
| **vanilla-extract** | Type-safe tokens + zero runtime, good for design systems |
| **CSS-in-JS** (styled-components / Emotion) | Dynamic theming heavy, legacy familiarity — note RSC/runtime-cost caveats |

For RSC/Next App Router, prefer zero-runtime approaches (Tailwind, CSS Modules, vanilla-extract) over runtime CSS-in-JS.

## 7. Component / Headless Primitives

- **Headless + own styling**: **Radix UI** or **React Aria** (accessibility-first) → pair with the chosen styling solution and `design-system-spec`.
- **Prebuilt, copy-in**: **shadcn/ui** (Radix + Tailwind) when you want ownership of the component code.
- **Full design system out of the box**: **MUI / Mantine / Chakra** when speed beats customization control.

## 8. Testing

Align with the project's existing test skills (`frontend-test-principles`, `frontend-test-suite`) if present.

- **Unit / component**: **Vitest** (default for Vite/modern) or **Jest** (legacy/Next compatibility) + **React Testing Library**.
- **E2E**: **Playwright** (default — multi-browser, reliable) or **Cypress**.
- **Component dev/visual**: **Storybook** — also a natural home for `design-system-spec` output.

## How to Use This Guide

1. Resolve categories top-to-bottom; earlier choices constrain later ones.
2. For each, name the realistic options, the single tradeoff that decides it for *this* project, and the assumption behind the pick.
3. Feed the result into the `spec-advisor` decision table and the handoff note for `architecture-design`.
