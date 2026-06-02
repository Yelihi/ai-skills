# Runtime Robustness Checklist

The audit rubric for `code-cleaner`. Each item is a checkable assertion about how the code behaves when reality is hostile: failures, empty data, slow networks, repeated actions, teardown. Scope is runtime robustness only — naming/duplication → `code-quality`, philosophy → `karpathy-guidelines`.

## 1. Exception handling

- [ ] Every operation that can throw/reject (fetch, mutation, parse, storage, third-party call) has a defined failure path.
- [ ] No silently swallowed errors — `catch {}` or `.catch(() => {})` without handling/logging is a finding.
- [ ] Errors are surfaced meaningfully (user-facing message / toast / inline), not only `console.error`.
- [ ] `catch` narrows the error (it's `unknown`) before reading `.message` etc.
- [ ] Error boundaries wrap render-time failures where a subtree can crash (React error boundary / route error element).
- [ ] Thrown errors carry enough context to diagnose (not bare `throw new Error()`).

## 2. Async failure paths

- [ ] Each `await` / promise chain handles rejection, not just resolution.
- [ ] Data-fetching hooks (`useQuery`/`useSWR`/server fetch) consume the `error` state, not only `data`.
- [ ] No unhandled promise rejections (fire-and-forget promises are awaited or explicitly `.catch`-ed).
- [ ] Timeouts / cancellation considered for long requests (AbortController where relevant).
- [ ] Retries (if any) are bounded — no infinite retry loop.

## 3. UI states (the "blank screen" check)

For every view backed by async / remote / derived data:

- [ ] **Loading** state rendered (skeleton/spinner/placeholder) — no blank flash while pending.
- [ ] **Empty / zero-data** state designed (not an empty list silently rendering nothing).
- [ ] **Error** state rendered with a recovery affordance (retry / message) — not a perpetual spinner.
- [ ] **Partial / stale** data handled if the library exposes it.
- [ ] Success path does not assume data is present (no render before `data` exists).

## 4. Defensive handling

- [ ] Boundary inputs: empty arrays/strings, very long content (truncation/overflow), missing optional fields.
- [ ] User actions that mutate are guarded against **double-submit** (disable while pending).
- [ ] **Race conditions**: out-of-order responses / stale closures handled (latest-wins, keys, abort).
- [ ] Division/index/`.length` access guarded against undefined collections.
- [ ] External input (URL params, form values) validated before use.

## 5. Cleanup & lifecycle

- [ ] `useEffect` subscriptions, timers (`setInterval`/`setTimeout`), event listeners, and observers are cleaned up in the return function.
- [ ] No state updates after unmount (the effect's async path respects cleanup/abort).
- [ ] Resources (object URLs, sockets, streams) are released.

## Output format

Report each violation as `file:line — [category] what fails → handling to add`, with severity (critical = crashes/hangs for a user, warning = degraded). Include a per-view **state coverage table** (loading / empty / error → ✓/✗). End with the verdict and the highest-risk gaps. Anything outside robustness gets a one-line "→ code-quality" / "→ a11y-checker" pointer, not a fix.
