# Documentation Structure

PastelTasks documentation is split into frozen specifications and living project documents.

## `docs/specs/`

`docs/specs/` contains approved baseline specifications.

These files describe the intended product, architecture, UX, API, database, and roadmap. Treat them as frozen references. They should change only when the team intentionally approves a new baseline or architecture decision.

Examples:

- `PRD.md`
- `TRD.md`
- `UX.md`
- `DATABASE.md`
- `API.md`
- `ROADMAP.md`

## `docs/`

`docs/` contains living documents that evolve during development.

These files track current project memory, milestone progress, implementation notes, decisions, bugs, todos, and change history.

Examples:

- `brain.md`
- `project_status.md`
- `decision_log.md`
- `features.md`
- `database.md`
- `api.md`
- `roadmap.md`
- `bugs.md`
- `changelog.md`
- `todos.md`

## Why This Structure Exists

Windows file systems are case-insensitive by default. That means filenames such as `API.md` and `api.md`, or `DATABASE.md` and `database.md`, cannot reliably coexist in the same directory.

To keep the repository compatible across Windows and other platforms:

- Frozen uppercase specifications live in `docs/specs/`.
- Lowercase living documents remain directly in `docs/`.

This preserves the intended meaning of uppercase frozen specs and lowercase living trackers without relying on case-sensitive directory behavior.

## Reading Order For AI Sessions

1. `docs/brain.md`
2. `docs/project_status.md`
3. `docs/README.md`
4. `docs/specs/` only when more baseline context is required
