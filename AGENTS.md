# AGENTS.md

# AI Startup Rule

Before making any change:

1. Read AGENTS.md

2. Read docs/brain.md

3. Read docs/project_status.md

4. Read relevant living docs

5. Read docs/specs only if required

Never scan the repository first.

# Project Success

The repository should always be:

✓ Buildable

✓ Documented

✓ Testable

✓ Modular

✓ Understandable by another AI

✓ Ready for the next session

Never assume missing requirements.

Ask.

Never invent architecture.

Never invent APIs.

Never invent models.

## Git Workflow

Every completed milestone must follow:

1. flutter analyze
2. flutter test
3. flutter build apk --debug

If all pass:

4. Update brain.md
5. Update project_status.md
6. Update changelog.md
7. Update decision_log.md

8. git status
9. git diff
10. git add .
11. git commit

Semantic commit examples:

feat(...)
fix(...)
refactor(...)
docs(...)
build(...)
test(...)
chore(...)

12. git push

If push fails,
stop immediately and report the error.

Never force push.

Never rewrite history.

Never create a fork unless explicitly instructed.

Never commit failing code.

## Purpose
This file is the operating manual for AI coding assistants working in the
PastelTasks repository.
It applies to ChatGPT Codex, ChatGPT, Claude Code, Cursor, Copilot, and any
other AI assistant that reads or modifies this project.
Do not treat this file as product documentation.
Do not repeat the PRD or TRD here.
Use this file to decide how to work safely inside the repository.
---
## 1. Project Overview
PastelTasks is an offline-first task management application built with Flutter.
The project uses feature-first architecture, Clean Architecture, and
production-quality engineering practices.
The app prioritizes privacy, speed, calm UX, and maintainable implementation.
Normal usage must work without an account.
Google Sign-In is optional and limited to backup and restore flows.
Local data is the source of truth.
Do not introduce cloud-first assumptions.
Do not add features before their milestone begins.
---
## 2. Documentation Workflow
Every AI session must read documentation before acting.
Read in this order:
1. `docs/brain.md`
2. `docs/project_status.md`
3. Relevant living documents in `docs/`
4. `docs/specs/` only if additional baseline context is required
Never scan the whole repository first.
Start with the smallest set of files needed for the task.
Open more files only when the current task requires more context.
Use `docs/brain.md` as compressed project memory.
Use `docs/project_status.md` for milestone state.
Use `docs/README.md` for documentation structure.
Use `docs/specs/` for frozen baseline decisions.
Living documents may evolve during development.
Frozen specs change only through explicit decision.
Ask a concise question when requirements are ambiguous.
Proceed when scope is clear.
---
## 3. Engineering Workflow
Always follow this workflow for implementation tasks:
1. Goal
2. Analysis
3. Plan
4. Files to modify
5. Risks
6. Implementation
7. Validation
8. Documentation updates
9. `brain.md` updates
10. Next recommended task
Never skip these steps.
For documentation-only tasks, keep each step concise.
For code tasks, inspect existing patterns before editing.
Prefer minimal scoped changes.
Do not refactor unrelated code.
Do not rewrite files for style preference only.
Do not change behavior outside the requested scope.
Always validate the actual result.
When validation cannot run, explain why.
---
## 4. Architecture Rules
PastelTasks uses:
- Feature First organization
- Clean Architecture
- MVVM
- Repository Pattern
- Riverpod
- GoRouter
- Isar
Respect this dependency direction:
```text
Presentation
Domain
Repository
Data
```
Presentation may depend on domain contracts.
Domain must stay independent of Flutter.
Data implementations must not leak persistence details upward.
Never bypass layers for convenience.
Never put database calls directly in UI widgets.
Never put business rules directly in screens.
Never let `core` depend on a feature.
Never let `shared` depend on a feature.
Avoid direct feature-to-feature dependencies.
Keep feature internals isolated.
Prefer project conventions over new patterns.
---
## 5. Coding Standards
Apply SOLID.
Apply DRY.
Apply KISS.
Apply YAGNI.
One class should have one clear responsibility.
One file should have one clear purpose.
Use meaningful names.
Prefer explicit names over clever names.
Keep functions small.
Keep widgets small.
Extract reusable pieces when duplication becomes meaningful.
Prefer composition over inheritance.
Avoid magic numbers.
Use constants or design tokens for repeated values.
Handle errors explicitly.
Prefer immutable state.
Avoid global mutable state.
Keep comments useful and sparse.
---
## 6. Flutter Rules
Use Riverpod only for state management.
Use Riverpod for dependency injection.
Use GoRouter only for navigation.
Use Isar only for local database persistence.
Do not add Provider.
Do not add GetX.
Do not add Bloc.
Do not call `Navigator.push` for app navigation.
Route through GoRouter.
Do not initialize app services inside widgets.
Do not initialize Isar unless the current milestone asks for it.
Do not initialize notifications unless the current milestone asks for it.
Do not create screens unless the current milestone asks for them.
Do not create feature folders before their milestone.
Do not generate code unless explicitly requested.
Do not run `build_runner` unless explicitly requested.
---
## 7. Documentation Rules
Every completed task updates:
- `docs/brain.md`
- `docs/project_status.md`
- `docs/changelog.md`
If architecture changes, also update:
- `docs/decision_log.md`
- Relevant files in `docs/specs/`
Do not update frozen specs casually.
Document decisions, not noise.
Keep living documents concise.
Do not duplicate entire specifications.
Do not store source code in project documentation unless explicitly required.
Use `docs/` for living documents.
Use `docs/specs/` for approved baseline specifications.
Remember the Windows case-insensitive filesystem limitation.
Do not try to place `API.md` and `api.md` in the same directory.
---
## 8. `brain.md` Rules
`docs/brain.md` is compressed AI memory.
Future AI sessions should understand current project state from it.
Never store source code in `brain.md`.
Never copy full documentation into `brain.md`.
Only summarize.
Keep it around 150 lines maximum.
Include current milestone, progress, active architecture, important decisions,
current blockers, and next task.
Update it after every completed task.
Remove stale information when it becomes misleading.
Keep it useful for handoff.
---
## 9. Milestone Rules
Never work on multiple milestones simultaneously.
Finish the current milestone before starting another.
Do not implement unrelated features.
Do not create future feature folders early.
Do not add future dependencies early.
Do not build UI before the design-system milestone asks for it.
Do not build business logic before the relevant feature milestone.
Use `docs/project_status.md` as the source of milestone truth.
If requested work conflicts with the current milestone, say so.
---
## 10. Dependency Rules
Never introduce a new package unless it is justified, documented, and approved.
Prefer existing dependencies.
Prefer Flutter and Dart standard libraries when sufficient.
Do not add overlapping state management packages.
Do not add overlapping routing packages.
Do not add overlapping database packages.
Do not modify `pubspec.yaml` for documentation-only tasks.
After dependency changes, check for duplicates.
After dependency changes, update documentation.
---
## 11. Testing Rules
Every feature must include unit tests.
Add widget tests where UI behavior is involved.
Add integration tests for critical flows.
Critical flows include task creation, editing, completion, reminders, archive,
backup, restore, and migration-sensitive behavior.
No feature is complete without validation.
Run the narrowest useful test first.
Run broader tests when shared behavior changes.
If tests cannot run, explain the missing tool or blocker.
Prefer behavior-focused tests.
---
## 12. Performance Rules
Target app launch under 2 seconds.
Target search under 100 ms.
Target task creation under 20 ms.
Maintain smooth scrolling.
Target 60 FPS interactions.
Avoid unnecessary rebuilds.
Prefer immutable state.
Use efficient Isar indexes when data modeling begins.
Avoid heavy work on the UI thread.
Measure before optimizing large changes.
---
## 13. Accessibility Rules
Support dynamic text.
Support screen readers.
Use semantic labels where needed.
Respect 48 dp minimum touch targets.
Support high contrast.
Avoid color-only meaning.
Keep interactions reachable.
Prefer clear focus order.
Do not sacrifice accessibility for visual polish.
---
## 14. Design Rules
Never copy Stitch HTML directly into Flutter.
Treat Stitch files as visual references only.
Recreate UI using native Flutter widgets.
Follow `DESIGN_SYSTEM.md` when design work begins.
Never hardcode colors.
Never hardcode spacing.
Use design tokens.
Use theme values.
Keep the interface calm and minimal.
Do not create UI in foundation-only milestones.
---
## Design Workflow

Before implementing any screen:

1. Read DESIGN_SYSTEM.md
2. Read the corresponding Stitch README
3. Inspect reference.html
4. Inspect reference.png
5. Extract reusable components
6. Implement native Flutter widgets
7. Never convert HTML directly into Flutter
---
## 15. Git Rules
Recommended branch names:
- `feature/<name>`
- `bugfix/<name>`
- `release/<version>`
Recommended commit prefixes:
- `feat:`
- `fix:`
- `docs:`
- `refactor:`
- `test:`
- `chore:`
Keep commits focused.
Do not mix unrelated work.
Do not rewrite history unless explicitly requested.
Do not discard user changes.
Do not run destructive git commands without explicit approval.

**Milestone Tagging:** Every completed milestone must end with a release tag. In addition to committing and pushing, create a Git tag for the completed milestone using the semantic format `v0.[Phase].[Milestone]`. For example: `git tag -a v0.3.8 -m "Complete M3.8 Swipe Actions"` followed by `git push origin v0.3.8`.
---
## 16. AI Restrictions
Never rewrite unrelated files.
Never delete working code.
Never change architecture without explanation.
Never modify dependencies without reason.
Never add placeholder implementations unless requested.
Never implement application features during documentation-only tasks.
Never modify Flutter code during documentation-only tasks.
Never scan the entire repository unless necessary.
Never edit generated files manually.
Never ignore dirty worktree changes made by others.
Ask questions whenever requirements are ambiguous.
State assumptions when they affect behavior.
---
## 17. Output Format
Every implementation task should respond with:
1. Goal
2. Analysis
3. Plan
4. Files modified
5. Risks
6. Implementation
7. Validation
8. Documentation updates
9. `brain.md` updates
10. Next task
For documentation-only tasks, keep the same shape but concise.
For review tasks, lead with findings.
For blocked tasks, explain the blocker and smallest path forward.
Always report validation results.
Always mention when tooling is unavailable.
---
## 18. Definition of Done
A task is complete only when:
- It satisfies the requested scope.
- It does not introduce unrelated changes.
- It builds successfully when build validation is applicable.
- There are no analyzer errors when analysis is applicable.
- Tests pass when tests are applicable.
- Documentation is updated.
- `docs/brain.md` is updated.
- `docs/project_status.md` is updated.
- No critical bugs are known.
- Remaining risks are stated.
Documentation-only tasks do not require Flutter build validation unless they
change project configuration.
Foundation tasks do not require feature tests.
Feature tasks require meaningful validation.
---
## 19. Future AI Sessions
Assume another AI will continue this project.
Leave the repository in a clean, understandable state.
Minimize token usage by relying on `docs/brain.md`.
Keep handoff notes accurate.
Update stale status before ending a task.
Prefer small reversible changes.
Keep future milestones unblocked.
Do not surprise the next assistant with hidden assumptions.
Make the next step obvious.
---
## Quick Start Checklist
Before changing files:
- Read `docs/brain.md`.
- Read `docs/project_status.md`.
- Read relevant living docs.
- Confirm the current milestone.
- Confirm the requested scope.
- Identify files to modify.
- Identify validation steps.
Before final response:
- Verify files changed.
- Verify scope was respected.
- Run relevant validation.
- Update required docs.
- Update `docs/brain.md`.
- Report remaining work.
---
## Current Project Reminder
M0.1 Project Foundation is completed.
M0.2 Application Bootstrap is the next recommended milestone.
M0.2 may include app startup wiring, theme wiring, RiverpodScope, GoRouter,
Logger, and Isar initialization.
M0.2 must not include feature implementation.
Do not create screens during M0.2 unless the milestone definition changes.
Do not create feature folders during M0.2 unless explicitly approved.

# AI Shutdown Rule

Before ending every task:

✓ Validate changes

✓ Update brain.md

✓ Update project_status.md

✓ Update changelog.md

✓ Update decision_log.md if architecture changed

✓ Report next milestone

✓ Leave project buildable
