# Server / Client Boundary

How to decide what runs on the server vs the client, where the boundary line falls, and where each class of state physically lives. Written with Next.js App Router (RSC) as the primary case, with notes for SSR (Remix) and SPA models.

## Core Principle

**Default to the server. Opt into the client only for interactivity.** Server components reduce client JS, keep data fetching close to the source, and never ship secrets. A component becomes a client component only when it needs: state/effects, event handlers, browser-only APIs, or interactive hooks.

Push the boundary **down to the leaves**: keep pages and layouts on the server, and make only the interactive sub-components client components. A client component anywhere makes its whole import subtree client — so isolate interactivity.

## RSC Decision (Next App Router)

```
Does this component need...
  state/effects (useState/useEffect)?      ─┐
  event handlers (onClick/onChange)?        ├─ yes → client component ('use client')
  browser APIs (window, localStorage)?      │
  interactive hooks (useContext, custom)?  ─┘
  └─ none of the above → server component (default)
```

Patterns:
- **Server shell, client islands** — server component fetches data and renders layout; passes data as props into small client components for interactivity.
- **Pass server data as props, not via fetch in client** — fetch on the server, hand serializable props down across the boundary.
- **Children as a slot** — a client component can receive server-rendered `children`, keeping subtrees on the server even inside a client wrapper.
- **Server actions for mutations** — co-locate write logic on the server; call from client forms/handlers.

Boundary rules:
- Props crossing server→client must be **serializable** (no functions except server actions, no class instances).
- Never import server-only modules (db clients, secrets) into client components. Use `server-only` / `client-only` guards.
- Context providers are client components — place them as low as possible, wrapping only the subtree that needs them.

## SSR (Remix / React Router) Notes

- Data flows through **loaders** (server) → component; mutations through **actions** (server). The whole route renders on the server then hydrates.
- Boundary is per-route, not per-component: there's no RSC-style intra-tree split. Keep loaders thin and typed; keep browser-only logic in effects.

## SPA (Vite) Notes

- Everything is client. The "boundary" is instead **data layer vs UI**: data fetching/caching (TanStack Query) is the analog of the server side. Keep network/cache logic out of presentational components.

## Where Each State Class Lives (across the boundary)

Take the `spec-advisor` state-strategy table and assign a physical home:

| State class | Boundary side | Physical home |
|-------------|---------------|---------------|
| Server state | Server-fetched, hydrated to client cache | RSC fetch / server action, or TanStack Query on client |
| Client global | Client only | Provider/store mounted at the lowest covering layout |
| Local | Client only | The component itself |
| URL state | Shared (server reads it for SSR, client updates it) | Router search params |
| Form state | Client (or server actions for submit) | Form library, near the form |

Key placements:
- **Client providers** (theme, auth, store) → mount in a client component wrapping only the subtree that consumes them, ideally in a layout — not at the root unless truly app-wide.
- **Server data** → fetch as high as the data is needed (often the page/server component), pass down; or fetch in client leaves via the data layer when interaction-driven.
- **URL state** → readable on the server for first render, mutated on the client.

## Data-flow Direction

Always **down and across one way**: server fetches → props/serialized data → client interactivity → mutations via server actions/API → cache invalidation → re-render. Avoid client→server→client round-trips for data the server already has. Avoid lifting server data into a client global store (see `spec-advisor/references/state-management-decision.md`).

## Output

For each route/feature area, produce a boundary map line:

```
/products/[id]
  server: page (fetch product, related list) → renders layout + ProductView (server)
  client: AddToCartButton (state + onClick), ImageGallery (interactive)
  boundary: 'use client' at AddToCartButton / ImageGallery leaves
  state: product = server; cart = client store (mounted in (shop) layout); selectedImage = local
```

Feed these into the `architecture-design` boundary map and state-placement table.
