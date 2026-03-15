# Claude Code Skill: Obsidian Vault Refactor (YAML Standard)

## Skill Name
obsidian-vault-refactor-yaml

## Purpose
Refactor and normalize an Obsidian vault used for technical learning and work knowledge management into a structured note system with explicit YAML frontmatter.

This skill is designed for vaults that mix:
- books
- articles
- lectures
- company/work notes
- investigations
- concept summaries
- map-style overview notes

The goal is to transform the vault into a durable knowledge system with five note types:

1. Source Note
2. Raw Note
3. Concept Note
4. Map Note
5. Work Note

---

## When to Use This Skill
Use this skill when the user wants to:
- reorganize an Obsidian vault
- standardize markdown notes
- split long mixed notes into smaller typed notes
- convert article/book/lecture notes into source-driven knowledge
- unify concepts from multiple sources into one concept note
- preserve company/project context separately from general knowledge
- introduce YAML frontmatter for machine-readable classification
- prepare vault files for Codex, Claude Code, scripts, or Dataview queries

Do not use this skill for:
- prose editing unrelated to vault structure
- generic markdown beautification without taxonomy changes
- one-off note cleanup that does not need a system-wide rule set

---

## Core Principles

### 1. Separate source from knowledge
A note about something read or watched is not automatically a knowledge note.

- Source Notes manage consumption and metadata.
- Raw Notes capture temporary observations/questions.
- Concept Notes hold source-independent knowledge about one concept.
- Map Notes show relationships between multiple concepts.
- Work Notes preserve company/project-specific context.

### 2. Concepts must be source-independent
If the same concept appears in:
- a book
- an article
- a lecture
- a work investigation

it should eventually converge into a single Concept Note when appropriate.

### 3. Work context must be preserved
Company-specific facts, constraints, decisions, and investigations should not be flattened into generic concept notes unless the content is truly generalizable.

### 4. Frontmatter is mandatory
Every managed note must contain YAML frontmatter following the standard below.

### 5. Prefer restructuring over rewriting
Preserve the user's meaning.
Do not invent facts.
Do not over-expand notes.
Keep useful questions and ambiguity markers.

---

## Canonical Note Types

### 1. Source Note
Purpose: manage a source and its reading/consumption state.

Examples:
- article to read
- book chapter reference
- lecture note entry
- documentation page tracker

A Source Note is about:
- what the source is
- why it matters
- what state it is in
- what notes derive from it

It is not the final knowledge note.

### 2. Raw Note
Purpose: capture rough notes while reading, watching, investigating, or working.

Examples:
- quick takeaways from an article
- questions while reading a chapter
- rough notes during a lecture
- investigation scratch notes from work

A Raw Note is intentionally incomplete and temporary.

### 3. Concept Note
Purpose: explain one concept clearly.

Examples:
- Hydration
- Reconciliation
- Event Loop
- Signed URL Upload
- Cache Invalidation

A Concept Note should answer:
- what is it
- why it matters
- what is easy to confuse it with
- where it is used in practice

### 4. Map Note
Purpose: connect multiple concepts into a structure.

Examples:
- React Rendering Architecture
- Browser Execution Flow
- Upload Pipeline Design
- SSR Rendering Strategies
- Async Models in Frontend

A Map Note should emphasize relationships, flow, comparison, hierarchy, and gaps.

### 5. Work Note
Purpose: preserve work/project-specific facts and context.

Examples:
- SSR Cache Miss Investigation
- Admin Table Virtualization Bug Analysis
- Signed Upload Queue Decision
- Focus MVP MediaPipe Constraints

A Work Note may link to concepts, but should preserve business and technical context.

---

## YAML Frontmatter Standard

## Common Minimum Fields for All Managed Notes
Every note should contain at least:

```yaml
---
type: concept
title: Reconciliation
domain: react
status: seed
tags: [concept, react, rendering]
created: 2026-03-14
updated: 2026-03-14
---
```

Required common fields:
- type
- title
- domain
- status
- tags
- created
- updated

Optional common fields:
- aliases
- source_refs
- related_concepts
- related_maps
- project
- context
- url
- author
- published

---

## Type-Specific YAML Schemas

### Source Note YAML
```yaml
---
type: source
source_kind: article
title: React Compiler Deep Dive
domain: react
status: unread
tags: [source, article, react]
url:
author:
publisher:
published:
related_concepts: []
created: 2026-03-14
updated: 2026-03-14
---
```

Allowed `source_kind` values:
- article
- book
- lecture
- documentation
- paper
- reference
- internal

Allowed `status` values for Source Notes:
- unread
- reading
- read
- archived

### Raw Note YAML
```yaml
---
type: raw
source_kind: article
title: RAW - React Compiler Deep Dive
domain: react
status: inbox
tags: [raw, react]
source_refs:
  - [[SRC - Article - React Compiler Deep Dive]]
created: 2026-03-14
updated: 2026-03-14
---
```

Allowed `status` values for Raw Notes:
- inbox
- processed
- archived

### Concept Note YAML
```yaml
---
type: concept
title: Reconciliation
domain: react
status: seed
tags: [concept, react, rendering]
aliases: []
source_refs:
  - [[SRC - Book - Inside React - Chapter 03]]
  - [[SRC - Article - React Rendering Overview]]
related_maps:
  - [[MAP - React Rendering Architecture]]
created: 2026-03-14
updated: 2026-03-14
---
```

Allowed `status` values for Concept Notes:
- seed
- growing
- stable
- archived

### Map Note YAML
```yaml
---
type: map
title: React Rendering Architecture
domain: react
status: growing
tags: [map, react, rendering]
key_concepts:
  - [[CPT - Reconciliation]]
  - [[CPT - Commit Phase]]
  - [[CPT - Fiber]]
created: 2026-03-14
updated: 2026-03-14
---
```

Allowed `status` values for Map Notes:
- seed
- growing
- stable
- archived

### Work Note YAML
```yaml
---
type: work
title: SSR Cache Miss Investigation
domain: performance
status: active
tags: [work, performance, cache]
project: academy-admin
context: company
related_concepts:
  - [[CPT - Cache Invalidation]]
  - [[CPT - SSR Caching]]
created: 2026-03-14
updated: 2026-03-14
---
```

Allowed `status` values for Work Notes:
- active
- blocked
- done
- archived

---

## Recommended Folder Structure

```text
Obsidian Vault/
├── 00_Inbox/
│   ├── fleeting/
│   ├── capture/
│   └── triage/
│
├── 01_Sources/
│   ├── books/
│   │   ├── unread/
│   │   ├── reading/
│   │   └── done/
│   ├── articles/
│   │   ├── unread/
│   │   ├── reading/
│   │   ├── read/
│   │   └── archived/
│   ├── lectures/
│   │   ├── unread/
│   │   ├── in-progress/
│   │   └── done/
│   └── references/
│
├── 02_Raw/
│   ├── books/
│   ├── articles/
│   ├── lectures/
│   ├── work/
│   └── research/
│
├── 03_Knowledge/
│   ├── concepts/
│   │   ├── frontend/
│   │   ├── react/
│   │   ├── vue/
│   │   ├── browser/
│   │   ├── javascript/
│   │   ├── typescript/
│   │   ├── network/
│   │   ├── architecture/
│   │   ├── performance/
│   │   ├── testing/
│   │   ├── security/
│   │   └── ai-frontend/
│   ├── maps/
│   │   ├── rendering/
│   │   ├── runtime/
│   │   ├── async/
│   │   ├── state-management/
│   │   ├── server-client-boundary/
│   │   └── engineering-decisions/
│   └── principles/
│
├── 04_Work/
│   ├── company/
│   │   ├── facts/
│   │   ├── decisions/
│   │   ├── questions/
│   │   ├── investigations/
│   │   └── retrospectives/
│   ├── projects/
│   └── reusable-patterns/
│
├── 05_MOCs/
├── 06_Templates/
└── 99_Archive/
```

---

## File Naming Rules

### Source Notes
```text
SRC - {SourceKind} - {Title}.md
```

Examples:
- `SRC - Article - React Compiler Deep Dive.md`
- `SRC - Book - Inside React Chapter 03.md`
- `SRC - Lecture - Browser Rendering Part 1.md`

### Raw Notes
```text
RAW - {Origin} - {Title}.md
```

Examples:
- `RAW - Article - React Compiler Deep Dive.md`
- `RAW - Book - Inside React Chapter 03.md`
- `RAW - Work - SSR Cache Miss Investigation.md`

### Concept Notes
```text
CPT - {Concept Name}.md
```

Examples:
- `CPT - Reconciliation.md`
- `CPT - Event Loop.md`
- `CPT - Cache Invalidation.md`

### Map Notes
```text
MAP - {Topic}.md
```

Examples:
- `MAP - React Rendering Architecture.md`
- `MAP - Browser Execution Flow.md`

### Work Notes
```text
WORK - {Project or Context} - {Topic}.md
```

Examples:
- `WORK - Academy Admin - SSR Cache Miss Investigation.md`
- `WORK - Focus - MediaPipe Main Thread Constraints.md`

---

## Section Templates by Note Type

### Source Note Required Sections
```md
# {Title}

## Summary
Brief description of the source

## Why Read
Why this source matters

## Key Topics
- topic 1
- topic 2

## Status Notes
Consumption notes and next actions

## Derived Notes
- [[RAW - ...]]
- [[CPT - ...]]
- [[MAP - ...]]
```

### Raw Note Required Sections
```md
# {Title}

## Source
- source link or [[Source Note]]

## Topic
What this rough note is about

## Key Points
- point 1
- point 2

## Questions
- question 1
- question 2

## Quotes or Cues
Important memory triggers, snippets, or cues
```

### Concept Note Required Sections
```md
# {Concept Name}

## One-line Definition
One-sentence explanation

## Why It Matters
Why the concept matters

## Core Points
- point 1
- point 2
- point 3

## Related Concepts
- [[...]]
- [[...]]

## Confusions
What it is often confused with

## Open Questions
Remaining uncertainty

## Practical Connection
How it connects to engineering work

## Source Notes
- [[SRC - ...]]
- [[RAW - ...]]
```

### Map Note Required Sections
```md
# {Topic}

## Central Question
The main question this note answers

## Scope
What is in and out of scope

## Key Concepts
- [[CPT - ...]]
- [[CPT - ...]]
- [[CPT - ...]]

## Relationships
- A relates to B because ...
- C happens before D because ...

## Flow
Ordered structure, comparison, hierarchy, or pipeline

## Gaps
What is still incomplete

## Practical Connection
How this map helps decisions or implementation
```

### Work Note Required Sections
```md
# {Title}

## Background
Business or technical context

## Current Problem
What is happening now

## Confirmed Facts
- fact 1
- fact 2

## Hypotheses
- hypothesis 1
- hypothesis 2

## Investigation
Notes from debugging, experiments, or research

## Decision
Chosen direction if available

## Related Concepts
- [[CPT - ...]]
- [[MAP - ...]]
```

---

## Classification Rules

### Classify as Source Note if:
- the note mainly tracks a source
- it contains link/title/author/status metadata
- it exists to manage unread/reading/read state
- it serves as an intake point for future notes

### Classify as Raw Note if:
- the note is incomplete or temporary
- it contains rough takeaways or questions
- it is tightly tied to one reading/watching/investigation session
- it is not yet the canonical explanation of a concept

### Classify as Concept Note if:
- the note explains one concept
- the title is a concept noun phrase
- the focus is on what it is / why it matters / what it is confused with
- it can absorb material from multiple sources

### Classify as Map Note if:
- the note explains multiple concepts together
- the note emphasizes structure, comparison, flow, hierarchy, or decision criteria
- it contains multiple concept links
- it answers a broader question rather than defining one concept

### Classify as Work Note if:
- the note is tied to a company/project context
- it preserves factual context, constraints, incidents, investigations, or decisions
- it may reference concepts but should remain context-aware
- removing the project/business context would reduce meaning

---

## Promotion and Split Rules

### Source -> Raw
Create a Raw Note when a source has enough active reading/thinking to produce:
- takeaways
- questions
- cues
- possible concept candidates

### Raw -> Concept
Promote content into a Concept Note when:
- a single concept clearly emerges
- the concept is reusable outside the original source
- multiple sources start reinforcing the same concept
- the explanation can be made source-independent

### Raw/Concept -> Map
Create a Map Note when:
- 3 or more concept notes belong to the same structure
- the user needs comparison, sequence, architecture, or hierarchy
- the bigger question is not “what is X?” but “how do these fit together?”

### Work -> Concept
Promote Work content into a Concept Note only when:
- the knowledge is generalizable beyond one project
- the concept can be explained without company-specific detail
- the project context is no longer necessary to understand the core idea

Keep the Work Note even after promotion if the business or debugging context still matters.

### Split Mixed Notes
If a note mixes:
- source metadata
- rough notes
- single-concept explanation
- structure across multiple concepts
- project-specific investigation

split it into the appropriate combination of:
- one Source Note
- one Raw Note
- one or more Concept Notes
- zero or one Map Note
- zero or one Work Note

Preserve cross-links between them.

---

## Status Handling Rules

### Source Notes
- unread: collected but not processed
- reading: actively reading
- read: consumed and processed enough to keep
- archived: no longer active

### Raw Notes
- inbox: not yet processed into higher notes
- processed: mined into concept/map/work
- archived: no longer needed actively

### Concept Notes
- seed: initial draft
- growing: accumulating structure and sources
- stable: mature enough to act as canonical note
- archived: deprecated or merged elsewhere

### Map Notes
- seed: early structure sketch
- growing: active relationship-building
- stable: reliable map
- archived: obsolete or superseded

### Work Notes
- active: currently relevant
- blocked: stalled
- done: concluded
- archived: historical

---

## Article unread/read Workflow

Articles can be handled through both folder structure and YAML status.

Recommended operational model:
- keep broad source folders for human browsing
- use YAML `status` as the source of truth for automation

### Recommended article flow
1. Save article as a Source Note in `01_Sources/articles/unread/`
2. Read it and update `status: reading`
3. Create a Raw Note during or after reading
4. Update Source Note to `status: read`
5. Promote reusable knowledge into Concept or Map Notes
6. Move stale or finished material to `archived` only when truly inactive

Do not store all article understanding inside the Source Note.
The Source Note tracks the source.
The Raw/Concept/Map notes hold the knowledge.

---

## Refactor Procedure for Claude Code

When executing this skill, follow this order:

### Step 1. Inspect the note
Determine:
- main role
- whether it mixes multiple roles
- whether frontmatter exists
- whether title and file name match the role

### Step 2. Classify the note
Assign exactly one primary type:
- source
- raw
- concept
- map
- work

If mixed, mark split candidates.

### Step 3. Normalize YAML
Add or correct frontmatter according to the type schema.
Use minimal fields when data is missing.
Do not invent metadata.

### Step 4. Normalize file name
Rename according to file naming rules.

### Step 5. Restructure sections
Rewrite the body into the required section structure.
Prefer concise restructuring over expansive rewriting.

### Step 6. Extract promotions
If the note contains reusable concept content:
- extract into Concept Note candidates
- extract broader structure into Map Note candidates
- preserve work context separately where relevant

### Step 7. Link related notes
Use Obsidian wiki links.
Prefer existing canonical concept notes when they already exist.

### Step 8. Preserve ambiguity
Unknown or uncertain parts should remain in:
- Open Questions
- Gaps
- Hypotheses

Do not pretend uncertainty is resolved.

---

## Execution Rules

- Never fabricate facts.
- Preserve the user’s original intent.
- Prefer shorter, sharper notes over bloated summaries.
- Keep useful engineering context.
- Avoid duplicate concept notes when one canonical note should exist.
- Convert repetition into links when possible.
- Use YAML frontmatter on every managed note.
- Respect the difference between source status and knowledge maturity.
- Keep company/project context in Work Notes.
- Promote only genuinely reusable knowledge into Concept Notes.

---

## Claude Code Command Prompt

Use the following instruction block inside Claude Code when applying this skill:

```md
You are refactoring my Obsidian vault into a structured knowledge system with YAML frontmatter.

The vault uses five note types:
1. Source Note
2. Raw Note
3. Concept Note
4. Map Note
5. Work Note

You must:
- classify each markdown file into one primary type
- detect mixed notes and split them when necessary
- add YAML frontmatter using the defined schema
- rename files according to the naming rules
- restructure note bodies into the required section format
- preserve source-specific context separately from reusable knowledge
- unify source-independent knowledge into canonical concept notes
- preserve project/company-specific knowledge as work notes
- use Obsidian wiki links
- never invent missing facts

YAML rules:
- every managed note must include type, title, domain, status, tags, created, updated
- use type-specific optional fields only when supported by the note role
- preserve uncertainty explicitly in Open Questions, Gaps, or Hypotheses

Classification rules:
- source = source tracking and reading state
- raw = temporary observations and questions
- concept = one concept explained clearly
- map = multiple concepts connected structurally
- work = company/project-specific context and investigation

Status rules:
- source: unread | reading | read | archived
- raw: inbox | processed | archived
- concept: seed | growing | stable | archived
- map: seed | growing | stable | archived
- work: active | blocked | done | archived

Naming rules:
- SRC - {SourceKind} - {Title}.md
- RAW - {Origin} - {Title}.md
- CPT - {Concept Name}.md
- MAP - {Topic}.md
- WORK - {Project or Context} - {Topic}.md

Restructure all notes to follow the standard section templates for their type.
If a note mixes article tracking, rough notes, concepts, and work investigation, split it into the appropriate set of notes and cross-link them.
```

---

## Success Criteria
This skill is successful when:
- every relevant note has valid YAML frontmatter
- note roles are unambiguous
- source tracking is separated from knowledge
- reusable concepts are centralized
- map notes show structure rather than definition duplication
- work context is preserved instead of flattened
- article unread/read flow remains manageable
- the vault becomes easier to query, refactor, and extend
