# Performance Audit Checklist

The audit rubric for `performance-checker`. Three parts: **record errors**, **check performance by category** (delegating depth to `vercel-react-best-practices`), and **produce a prioritized report**. Prefer evidence (build/lint/console output) over inference.

## Part A — Error ledger

Collect a concrete record before judging performance.

- [ ] Run the project's `build` (and `lint`); capture compiler/build **warnings and errors** with `file:line`.
- [ ] Capture **console errors/warnings** and unhandled exceptions/rejections surfaced at runtime (React warnings, hydration mismatches, key warnings, act warnings).
- [ ] Note **missing** error handling that risks a runtime failure (unawaited promises, no error state) — cross-reference `code-cleaner`; list here as "missing handling".
- [ ] Hydration errors / server-client markup mismatches flagged explicitly (they're both correctness and performance issues).

Output an error ledger: `file:line — occurred|missing — description`.

## Part B — Performance by category

Audit each category; for the fix detail, **cite the `vercel-react-best-practices` rule** by prefix rather than re-explaining.

### Waterfalls (CRITICAL · `async-*`)
- [ ] Independent awaits run in parallel (`Promise.all` / `async-parallel`), not sequentially.
- [ ] `await` deferred into the branch that needs it (`async-defer-await`).
- [ ] Streaming/Suspense used for slow sections (`async-suspense-boundaries`).

### Bundle (CRITICAL · `bundle-*`)
- [ ] No barrel imports pulling whole libraries (`bundle-barrel-imports`).
- [ ] Heavy/below-fold components dynamically imported (`bundle-dynamic-imports`).
- [ ] Analytics/third-party deferred after hydration (`bundle-defer-third-party`).

### Server (HIGH · `server-*`)
- [ ] Per-request dedup / caching where applicable (`server-cache-react`, `server-cache-lru`).
- [ ] Minimal data serialized across the RSC boundary (`server-serialization`, `server-dedup-props`).
- [ ] Fetches parallelized server-side (`server-parallel-fetching`).

### Re-render (MEDIUM · `rerender-*`)
- [ ] Derived state computed in render, not synced via effect (`rerender-derived-state-no-effect`).
- [ ] Interaction logic in event handlers, not effects (`rerender-move-effect-to-event`).
- [ ] Memoization applied only where measured-expensive (`rerender-memo`); no premature memo.
- [ ] Stable callbacks/props where they drive child re-renders.

### Rendering / JS (MEDIUM-LOW · `rendering-*`, `js-*`)
- [ ] Long lists virtualized / `content-visibility` (`rendering-content-visibility`).
- [ ] Static JSX hoisted (`rendering-hoist-jsx`); ternary over `&&` for conditional render.
- [ ] Repeated lookups use Map/Set; no expensive work repeated in render (`js-index-maps`, `js-early-exit`).
- [ ] Images optimized (correct sizing, lazy, modern format).

## Part C — Prioritized improvement report

For each finding, output a row:

```
[priority] issue — file:line
  evidence:  (build warning / console error / measured / static)
  fix:       → vercel-react-best-practices: <rule-prefix>
  impact:    CRITICAL | HIGH | MEDIUM | LOW
  effort:    S | M | L
```

- Order by impact first (mirror Vercel category priority), then by effort (quick high-impact wins first).
- Don't list micro-optimizations with no measurable effect — note them as "minor" or omit.
- End with: error-ledger summary, the top 3–5 fixes to do next, and the overall verdict.

## Boundaries

- **Depth of each fix** → `vercel-react-best-practices` (cite the rule; don't restate it).
- **Missing error handling / UI failure states** → `code-cleaner` (this skill only *records* them in the ledger).
- This skill owns: running the audit, recording errors, and prioritizing — not the rule catalog itself.
