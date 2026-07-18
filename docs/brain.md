# Project Summary

- Project name: PastelTasks.
- Purpose: a calm, fast, offline-first Flutter task manager.
- Goal: help users capture, organize, complete, and review tasks without mandatory accounts or cloud dependency.
- Philosophy: local-first privacy, minimal friction, smooth UX, and optional backup only when the user chooses it.
- Normal usage must work fully offline.
- Google Sign-In is optional and only for Google Drive backup and restore.

# Architecture

- **Current Milestone**: UI Overhaul & Fixes (Calendar & Completed Tasks)
- **Progress**: Implemented speech-to-text in the Add Task bottom sheet and fixed time clearing logic. Redesigned TaskDetailsScreen for inline editing, attachment picking, and Category selection. Added a delete all button to CompletedTasksScreen. Enhanced CalendarScreen with a customizable expanded view containing horizontally scrollable tasks, and removed the side drawer.
- **Active Architecture**: Feature-First, Clean Architecture, MVVM, Riverpod, GoRouter, Isar. Data-driven UI for Settings module.

- Feature First project organization.
- Clean Architecture boundaries.
- MVVM presentation pattern.
- Repository Pattern for data access.
- `lib/app/` owns app configuration, environment, router, theme, and app shell setup.
- `lib/bootstrap/` owns startup wiring.
- `lib/core/` owns reusable infrastructure.
- `lib/shared/` owns reusable presentation building blocks.
- `lib/features/` stays empty until feature milestones begin.

# Technology Stack

- Flutter.
- Dart.
- Riverpod.
- GoRouter.
- Isar.
- Logger.
- Flutter Quill.
- WorkManager.
- flutter_local_notifications.
- Google Drive Backup.
- Minimum Android API: Android 12, API 31.

## Current Milestone
**UI Overhaul & Fixes**
- Status: Completed.
- Next milestone: TBD
- Focus: Implemented inline title/note editing, inline bottom sheets for category, date, time and repetition, added an attachment picker, integrated speech-to-text for task titles, fixed reminder clear logic. Added delete all completed tasks feature and revamped the Calendar screen with an expanded tasks grid view.

# Completed

## Phase 4: Organization Complete
- M4.1 Tags
- M4.2 Filters
- M4.3 Search
- M4.4 Sorting
- M4.5 Bulk Selection & Bulk Actions
- M4.6 Smart Lists (Post-validation polish completed)
- M4.7 Organization Validation & Freeze

# Completed

- M0.1 Project Foundation.
- M0.2 Application Bootstrap.
- M0.3 Core Infrastructure (implementation and validation complete).
- M1.1 Theme Foundation (implementation complete).
- M1.2 Component Library (implementation complete).
- M1.3 Application Shell (implementation complete).
- M1.4 Developer Preview & Validation (implementation complete).
- M1.5 Device Validation & UX Polish (implementation complete).
- M2.1 Domain Architecture (implementation complete).
- M3.1 to M3.12 Home & Task interaction (implementation & validation complete).
- `main.dart` calls `bootstrap()` only.
- `bootstrap.dart` initializes Flutter bindings, logger, Isar setup, notification service structure, ProviderScope, and App.
- `App` uses `MaterialApp.router`.
- GoRouter has a single bootstrap splash route only.
- Minimal theme/config/environment structure exists.
- Single global logger service exists.
- Generic `Result<T>`, `Success`, and `Failure` exist.
- Base `AppException`, `ValidationException`, `StorageException`, and `NetworkException` exist.
- Reusable app configuration and package build information abstractions exist.
- Date/time, UUID, connectivity, and haptic services exist.
- Secure storage and application preferences abstractions exist.
- General validators, extensions, debouncing, throttling, constants, and formatting helpers exist.
- A common repository marker and typed result failures exist.
- Release logging suppresses debug and informational output.
- `AppTheme` implements Material 3 theme injection for the design system.
- `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadows`, and `PastelThemeExtension` tokens exist.
- `assets/fonts/` contains the Outfit variable font.
- `lib/features/` contains tasks, home, and presentation components.

# Not Started

- M2.5 Domain Validation.
- M4 Organization.
- M5 Time Management.
- M6 Notes & Rich Content.
- M7 Statistics.
- M8 Backup.
- M9 Settings.
- M10 Performance.
- M11 Release Candidate.

# Coding Rules

- No business logic in UI widgets.
- Riverpod only for state management and dependency injection.
- GoRouter only for navigation.
- Repository Pattern for data access.
- One responsibility per class.
- Keep domain logic independent of Flutter.
- Do not let `core` or `shared` depend on features.
- Avoid direct feature-to-feature dependencies.
- Use explicit error handling.
- Update living documentation after every milestone.

# Important Decisions

- Offline First: local data is the source of truth.
- No account is required for normal usage.
- Google Sign-In is optional and limited to backup and restore.
- Google Drive is backup storage, not a live cloud database.
- Completed tasks remain visible for 24 hours before archive.
- Manual drag-and-drop order must persist.
- Isar, Riverpod, and GoRouter are selected foundation technologies.
- Database initialization is deferred until M2 because no collections currently exist.
- Documentation is split because Windows cannot reliably store names like `API.md` and `api.md` in one directory.

# Current Folder Structure

- Root contains Flutter platform folders, assets, design references, docs, tests, tooling, and project metadata.
- `lib/` contains app, bootstrap, core, shared, features, and main entrypoint areas.
- `lib/app/` contains config, constants, environment, router, theme, and App shell.
- `lib/core/` contains errors, logging, result, services, storage, and other reusable infrastructure.
- `assets/` is organized by asset type.
- `design/stitch/` stores design reference assets, HTML, and screenshots.
- `docs/` contains living project documents.
- `docs/specs/` contains approved frozen specifications.

# Documentation Structure

- `docs/brain.md`: compact AI memory and current project context.
- `docs/project_status.md`: milestone status and remaining work.
- `docs/decision_log.md`: accepted project and architecture decisions.
- `docs/changelog.md`, `bugs.md`, and `todos.md`: active project tracking.
- `docs/specs/`: frozen PRD, TRD, UX, API, database, and roadmap specifications.
- Living docs may change during development.
- Frozen specs change only through an intentional decision.

# Important Dependencies

- Architecture: flutter_riverpod, riverpod_annotation, go_router.
- Database: isar, isar_flutter_libs.
- Utilities: logger, uuid, equatable, intl, collection.
- Scheduling: flutter_local_notifications, workmanager.
- Backup: google_sign_in, googleapis, googleapis_auth, flutter_secure_storage.
- Rich text and UI: flutter_quill, flutter_svg, animations, lottie.
- System: connectivity_plus, device_info_plus, path_provider, path, share_plus, package_info_plus, url_launcher.
- Preferences: shared_preferences.

# Current Phase: Phase 5 (Time Management)
Current Milestone: Post-M5.3 Bug Fixes - Completed

Completed Milestones:
- M0.1 - M0.3
- M1.1 - M1.3
- M2.1 - M2.4
- M3.1 Home Layout
- M3.2 Task Card
- M3.3 Empty State
- M3.4 Add Task
- M3.5 Create Task
- M3.6 Edit Task
- M3.7 Complete Task
- M3.8 Swipe Actions
- M3.9 Delete Task
- M3.10 Archive Task
- M3.11 Drag & Drop Reordering
- M3.12 Home Validation
- M4.1 Tag Management
- M4.2 Advanced Task Filtering
- M4.3 Intelligent Task Search
- M4.4 Smart Sorting
- M4.5 Bulk Selection & Bulk Actions
- M4.6 Smart Lists
- M4.7 Organization Validation & Freeze
- M5.1 Premium Calendar
- M5.2 Smart Notifications
- M5.3 Advanced Statistics Dashboard
- M5.4 Backup & Restore System
- M5.5 Personalization & Settings

# Current Blockers

- None.

- Next milestone: Waiting for user instruction.
- Scope: TBD

# Notes

- Stitch HTML files are design references only.
- Never convert Stitch HTML directly into Flutter.
- Use Stitch references only to reproduce layout, spacing, visual hierarchy, and design intent in native Flutter.
- Future AI sessions should read this file first, then `docs/project_status.md`, `docs/README.md`, and `docs/specs/` only when needed.
