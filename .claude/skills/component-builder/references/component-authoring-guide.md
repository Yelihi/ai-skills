# Component Authoring Guide

The decision flow for turning a spec or scaffold into a proper React component. This file covers **placement, boundary, props API, and purity**. It deliberately delegates: detailed composition patterns → `vercel-composition-patterns`; performance → `vercel-react-best-practices`; FSD layer rules → `clean-architecture`/`fsd-clean-architecture`; styling/tokens → `figma-to-tsx`/`design-system-spec`.

## 1. Placement & file co-location

Decide *where the component lives* before writing it.

- **FSD slice** — map by responsibility (per `architecture-design` / FSD): pure UI primitive → `shared/ui`; domain-agnostic composite → `shared/ui`; a feature's interactive block → `features/<slice>/ui`; a composed page section → `widgets`. Don't put domain logic in `shared`.
- **Co-locate** the component with what only it uses:

  ```
  features/cart/ui/CartItem/
    CartItem.tsx
    CartItem.types.ts        # props + local types (or inline if tiny)
    CartItem.test.tsx        # → frontend-test-principles
    index.ts                 # re-export ONLY this component
  ```

- **One component, one file** as a default. Split out subcomponents only when reused or when the file gets hard to scan.
- Respect FSD **import direction** (lower layers don't import higher ones). Defer the layer rules themselves to the FSD skill.

## 2. Server vs Client boundary

Per `architecture-design`'s boundary map:

- **Default to a server component.** Add `'use client'` only when the component needs interactivity (state, effects, event handlers, browser APIs).
- Push the boundary to the **leaf**: a mostly-static section should stay a server component with a small client child, not become entirely client.
- Props crossing the boundary must be **serializable** — no functions, class instances, or server-only objects passed into client children.
- Keep data fetching on the server side of the boundary; pass plain data down.

## 3. Props API design

Design the interface to be hard to misuse. (Detailed rules and examples live in `vercel-composition-patterns`; this is the working checklist.)

- **Composition over configuration** — prefer `children` / slots over a growing prop list. A component that takes `header`, `footer`, `sidebar` as render props usually wants compound components (`Card.Header`).
- **Variant unions, not booleans** — `variant: 'primary' | 'danger'`, not `isPrimary` + `isDanger`. Avoids impossible/conflicting states.
- **`children` over `renderX` props** for composition.
- **Pass through native props** — spread `...rest` onto the root element and accept `className` (merged last via `cn`) so the component is extensible.
- **`ref` as a prop** (React 19) — no `forwardRef`. (`vercel-composition-patterns` → `react19-no-forwardref`.)
- **Controlled vs uncontrolled** — pick one as the contract; if supporting both, document the `value`/`defaultValue` + `onChange` rules.
- Name props for **intent**, not implementation. Booleans read as states (`disabled`, `loading`), not config toggles.

## 4. Purity & state (the core of "pure component")

A component should be a pure function of its props/state during render. Most "weird React bugs" come from breaking this.

- **Derive during render, don't sync with effects.** If a value can be computed from props/state, compute it inline (or `useMemo` only when measured-expensive). Don't mirror props into `useState` + `useEffect`.

  ```tsx
  // ❌ derived state synced via effect
  const [full, setFull] = useState("");
  useEffect(() => setFull(`${first} ${last}`), [first, last]);

  // ✅ derive in render
  const full = `${first} ${last}`;
  ```

- **No side effects in render** — no fetching, subscriptions, logging-with-effect, or mutation during the render pass. Side effects go in event handlers (for user actions) or effects (for genuine external synchronization only).
- **Event handler vs effect** — "when the user clicks" → handler. "stay in sync with an external system (DOM node, socket, subscription)" → effect. Don't use an effect to react to a state change you caused.
- **Model finite states as unions**, not boolean bags (`status: 'idle' | 'loading' | 'error' | 'done'`), mirroring the domain types from `ddd-architecture`.
- **Keys** for lists are stable IDs, never array index when the list reorders.
- **Lift state** to the lowest common owner for sibling sharing; don't hoist higher than needed (state placement comes from `architecture-design`).

## 5. Naming

- Component & file: `PascalCase` matching the export. Hooks: `useX`. Handlers: `handleX` / `onX` props.
- Name by role/domain (`CartItem`, `CheckoutButton`), not by appearance (`BlueBox`).

## 6. Barrel exports — use sparingly

- A slice-level `index.ts` that re-exports the public component is fine.
- Avoid deep/aggregating barrels that re-export everything — they hurt tree-shaking and create import cycles. Export the public surface only.

## 7. What to defer (do not duplicate here)

| Concern | Owner |
|---|---|
| Compound components, render-props, context interface, boolean-prop rules | `vercel-composition-patterns` |
| Memoization, re-render avoidance, lazy/Suspense, bundle | `vercel-react-best-practices` |
| FSD layer definitions & import rules | `clean-architecture` / `fsd-clean-architecture` |
| Tokens, variants/states spec, a11y spec | `design-system-spec` |
| Tailwind class conventions | `figma-to-tsx` (`tailwind-conventions.md`) |
| Tests | `frontend-test-principles` / `frontend-test-suite` |

Write a correct, pure, well-placed component; let each linked skill own its depth.
