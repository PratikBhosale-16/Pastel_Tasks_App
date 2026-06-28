# Project Summary

- Project name: PastelTasks.
- Purpose: a calm, fast, offline-first Flutter task manager.
- Goal: help users capture, organize, complete, and review tasks without mandatory accounts or cloud dependency.
- Philosophy: local-first privacy, minimal friction, smooth UX, and optional backup only when the user chooses it.
- Normal usage must work fully offline.
- Google Sign-In is optional and only for Google Drive backup and restore.

# Architecture

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

# Current Milestone

- Current milestone: M3.6 Edit Task
- Status: Completed.
- Validation: Successfully reused `AddTaskBottomSheet` for editing tasks. Wired pre-filled fields, discard changes dialog, and deletion actions to update Isar and refresh the UI automatically. Tested via APK build.

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
- `lib/features/` remains empty.

# Not Started

- M2.5 Domain Validation.
- M3 Home Experience.
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

# Current Blockers

- None.

# Next Milestone

- Next milestone: M3.7 Complete / Restore
- Scope: Not specified.
- Constraint: Do not implement M3.7 until authorized.

# Notes

- Stitch HTML files are design references only.
- Never convert Stitch HTML directly into Flutter.
- Use Stitch references only to reproduce layout, spacing, visual hierarchy, and design intent in native Flutter.
- Future AI sessions should read this file first, then `docs/project_status.md`, `docs/README.md`, and `docs/specs/` only when needed.
