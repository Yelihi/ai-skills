# State Management Decision

The most common frontend architecture mistake is treating all state as one thing. It is not. Classify state first, then pick tools per class. A single app routinely uses three or four state mechanisms, and that is correct — not over-engineering.

## Step 1: Classify the State

| Class | Nature | Examples | Owned by |
|-------|--------|----------|----------|
| **Server state** | Remote, async, cached, shared truth lives elsewhere | user profile, product list, posts | Data-fetching layer |
| **Client global state** | Local, synchronous, shared across the tree | theme, auth session flag, open modals, cart (pre-checkout) | Client store / Context |
| **Local state** | Confined to one component subtree | input value, hover, accordion open | `useState` / `useReducer` |
| **URL state** | Belongs in the address bar, shareable/bookmarkable | filters, pagination, active tab, search query | Router search params |
| **Form state** | Transient editing state with validation | field values, errors, dirty/touched | Form library |

The decisive question for each piece of state: **"Where is the source of truth?"** If it's on a server, it's server state — do not copy it into a client store.

## Step 2: Pick Tools Per Class

### Server state
Use a caching data layer, never a plain global store:
- **TanStack Query** (default for client-driven fetching) — caching, background refetch, mutations, invalidation.
- **SWR** — lighter, hook-first, simpler needs.
- **RSC + server actions** (Next App Router) — fetch on the server, pass down; add TanStack Query only where rich client caching is needed.
- GraphQL → **Apollo / urql** with their normalized caches.

### Client global state — decision tree
```
Is it actually local to one subtree?
  └─ yes → useState / useReducer (stop here)
Is it server data?
  └─ yes → server state layer, NOT a store (stop here)
Does it belong in the URL?
  └─ yes → router search params (stop here)
Is it low-frequency, simple shared state (theme, auth flag)?
  └─ yes → Context (split providers per concern to limit re-renders)
Is it frequently updated or accessed across a wide tree?
  ├─ want minimal API, single store    → Zustand
  ├─ want atomic / bottom-up, fine-grained subscriptions → Jotai
  └─ large app, complex async flows, middleware/devtools, team familiarity → Redux Toolkit
```

### Local state
`useState` for simple values; `useReducer` when transitions are interrelated or state-machine-like. Prefer deriving values during render over syncing them with effects.

### URL state
Filters, pagination, sort, active tab, search term → store in the router's search params (`useSearchParams`, TanStack Router typed search). Benefits: shareable, bookmarkable, survives refresh, back/forward works. Avoid duplicating it into a client store.

### Form state
Owned by the form library (React Hook Form / TanStack Form). Do not lift every keystroke into global state; submit results may become server state (via a mutation) or client state.

## Step 3: Common Anti-patterns to Flag

- Server data cached in Redux/Zustand → cache duplication, staleness, manual sync. Move to a data layer.
- Everything in one global store → re-render storms, coupling. Split by class and concern.
- Context for high-frequency state → re-renders every consumer. Use Zustand/Jotai instead.
- Filters/tabs in client state instead of the URL → loses shareability and refresh persistence.
- `useEffect` to copy props/server data into local state → derive during render or use the data layer.

## Output for spec-advisor

Produce an explicit **state strategy summary**:

| State class | Concrete examples in this app | Chosen mechanism |
|-------------|-------------------------------|------------------|
| Server | ... | TanStack Query / RSC |
| Client global | ... | Context / Zustand / Jotai / RTK |
| Local | ... | useState / useReducer |
| URL | ... | router search params |
| Form | ... | React Hook Form + Zod |

Pass this to `architecture-design`, which decides *where* each store/provider physically lives in the boundary and folder structure.
