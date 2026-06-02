# Routing & Structure

How to design the route tree (with layout/loading/error boundaries) and map it onto FSD layers. Folder-layer rules themselves are owned by the `clean-architecture` (FSD) skill — this reference covers *routing structure* and the *route → FSD mapping*, not the FSD layering definitions.

## Route Tree Design

Derive routes from the domain's bounded contexts, not from UI screens. Each top-level area usually corresponds to a bounded context (`ddd-architecture` output).

Design the tree with these boundaries (Next App Router naming; equivalents exist in Remix/React Router):

- **layout** — shared shell for a segment (nav, providers, auth gate). Nest layouts to share UI and providers across a group.
- **loading** — Suspense fallback for a segment; place at the granularity where streaming helps perceived performance.
- **error** — error boundary per segment; isolate failures so one area's error doesn't blank the whole app.
- **not-found** — per-segment 404 where the domain has addressable-but-missing resources.
- **route groups** `(group)` — group routes that share a layout without affecting the URL (e.g. `(marketing)` vs `(app)` vs `(auth)`).
- **parallel / intercepting routes** — only when the UX genuinely needs them (modals over a page, dashboards with independent panes). Don't reach for them by default.

Example shape:
```
app/
  (marketing)/            # public, SEO, marketing layout
    layout.tsx
    page.tsx
    pricing/page.tsx
  (app)/                  # authenticated app shell + providers
    layout.tsx            # auth gate + client providers (theme/store)
    loading.tsx
    error.tsx
    dashboard/page.tsx
    products/
      page.tsx            # list
      [id]/
        page.tsx          # detail
        loading.tsx
  (auth)/                 # minimal layout for login/signup
    layout.tsx
    login/page.tsx
```

Guidelines:
- One **error/loading boundary per meaningful async area**, not one giant root boundary.
- Put **providers in the lowest layout** that covers all consumers (see `server-client-boundary.md`).
- Keep **route components thin** — they compose widgets/features (FSD), they don't hold business logic.

## Mapping Routes → FSD Layers

FSD layers (top imports from lower; never the reverse), per `clean-architecture`/`reference/FSD.md`:

```
app        → providers, router setup, global styles, entry
processes  → cross-page flows (optional; e.g. multi-step checkout)
pages      → route-level composition (maps to app/ route files)
widgets    → self-contained UI blocks composed of features/entities
features   → user actions / interactions around a domain capability
entities   → domain models + their UI/api (from ddd-architecture)
shared     → reusable, domain-agnostic utils/ui/config
```

Mapping rules:
- A **route file** (`page.tsx`) belongs to the **pages** layer — it composes widgets and features, holds no business logic.
- A **bounded context** maps to a set of **entities** + the **features** that act on them.
- A **reusable UI block** spanning multiple features → **widgets**.
- A **multi-step cross-page flow** (checkout, onboarding) → **processes** (or a coordinating feature if simple).
- **Design-system primitives** live in **shared/ui** and are specified by `design-system-spec`.

Import direction is enforced by FSD: `pages → widgets → features → entities → shared`. Routing structure must respect this — a page composes downward only.

## State Placement in the Structure

Combine with the `spec-advisor` state-strategy table and `server-client-boundary.md`:

| State | Lives in (FSD) | Mounted at (route) |
|-------|----------------|--------------------|
| App-wide client store/providers | app or (app) layout | lowest covering layout |
| Feature-local client state | the feature slice | the feature's components |
| Server cache (TanStack Query client) | app (provider) | root/app layout |
| Entity data/api | entities slice | fetched in pages/features |
| URL state | the consuming feature/page | route search params |

## Output

Produce:
1. **Route tree** — annotated with layout/loading/error boundaries and the domain area each segment serves.
2. **Route → FSD mapping** — which slices each route composes.
3. **Folder skeleton** — the FSD tree (delegated to `clean-architecture` for exact rules), annotated with placements above.

Hand the folder skeleton's component/UI layer to `design-system-spec`, and the whole skeleton to `feature-checklist`.
