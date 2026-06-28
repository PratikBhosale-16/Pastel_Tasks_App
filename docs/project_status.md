# Project Status

## Current Milestone

- Milestone: M3.9
- Name: Delete Task
- Status: Completed
- Validation: The ConfirmationDialog manages deletion flows. An AnimatedList correctly diffs UI rendering. Undo restores to Isar with the exact same ID for 5 seconds. All entry points covered.
- Overall Progress: Task life cycle interaction is heavily polished.

## Completed

- M0.1 Project Foundation.
- M0.2 Application Bootstrap.
- M0.3 Core Infrastructure.
- M1.1 Theme Foundation.
- M1.2 Component Library.
- M1.3 Application Shell.
- M1.4 Developer Preview & Validation.
- M1.5 Device Validation & UX Polish.
- M2.1 Domain Architecture.
- M2.2 Database Layer.
- `lib/main.dart` calls `bootstrap()` only.
- `lib/bootstrap/bootstrap.dart` initializes Flutter bindings, logger, Isar setup, notification service structure, ProviderScope, and App.
- `lib/app/app.dart` provides `MaterialApp.router` with title, theme, and router config.
- `lib/app/config`, `lib/app/constants`, and `lib/app/environment` contain minimal app configuration.
- `lib/app/router` contains a single bootstrap splash route.
- `lib/app/theme` contains minimal working theme tokens and theme setup.
- `lib/core/logging` contains the single global logger service.
- `lib/core/result` contains `Result<T>`, `Success`, and `Failure`.
- `lib/core/errors` contains the base application exception hierarchy.
- `lib/infrastructure/database/isar` contains Isar collections, single service, and migration setup (Schema version 1).
- `lib/features/tasks/domain/repositories` contains the repository interfaces for data access.
- `lib/features/tasks/data/repositories` contains Isar implementations for the repositories.
- `lib/features/tasks/presentation/providers` contains Riverpod providers for state exposure and mutation.
- `lib/core/providers` contains application-wide Riverpod dependency injection definitions.
- `lib/core/services` retains the notification service structure from M0.2.
- `lib/core/config` contains reusable application environment and build metadata configuration.
- `lib/core/services` contains date/time, UUID, connectivity, and haptic abstractions.
- `lib/infrastructure/local_storage` contains secure storage and application preferences abstractions.
- `lib/core/validators` contains general email, required, string length, and date validators.
- `lib/core/extensions` contains small reusable String and DateTime helpers.
- `lib/core/utils` contains debounce, throttle, timing constants, and formatter helpers.
- `lib/core/repositories` contains the common repository marker contract.
- `lib/core/errors` contains typed validation, storage, network, and unknown failures integrated with `Result<T>`.
- Release builds suppress verbose logger output.
- Added `shared_preferences` for non-sensitive application preferences.
- No features, screens, feature repositories, models, collections, task logic, backup, or authentication were implemented.

## Phase 1: Presentation Foundation (In Progress)
- [x] M1.1: Theme Foundation (Colors, typography, spacing, radius, and Material 3 AppTheme injection)
- [x] M1.2: Component Library (Reusable buttons, inputs, cards)
- [x] M1.3: Application Shell (Scaffolds, app bars, nav bars)
- [x] M1.4: Developer Preview & Validation
- [x] M1.5: Device Validation & UX Polish

## Phase 2: Backend Foundation (In Progress)
- [x] M2.1: Domain Architecture
- [x] M2.2: Database Layer
- [x] M2.3: Repository Layer
- [x] M2.4: State Management
- [ ] M2.5: Validation

## Phase 3: Home Experience (In Progress)
- [x] M3.1: Home Screen
- [x] M3.2: Task Card
- [x] M3.3: Empty State
- [x] M3.4: Add Task Bottom Sheet
- [x] M3.5: Create Task Flow
- [x] M3.6: Edit Task
- [x] M3.7: Complete / Restore
- [x] M3.8: Swipe Actions
- [x] M3.9: Delete
- [x] M3.10: Archive
- [x] M3.11: Reorder (Drag & Drop)
- [ ] M3.12: Home Validation
- [ ] M3.13: UX Polish

## Pending

- [ ] M4: Organization (M4.1 Tags, M4.2 Filters, M4.3 Search, M4.4 Sorting, M4.5 Bulk Actions, M4.6 Validation)
- [ ] M5: Time Management (M5.1 Calendar, M5.2 Due Dates, M5.3 Reminders, M5.4 Repeat Rules, M5.5 WorkManager, M5.6 Validation)
- [ ] M6: Notes & Rich Content (M6.1 Rich Notes, M6.2 Flutter Quill, M6.3 Attachments, M6.4 Validation)
- [ ] M7: Statistics (M7.1 Dashboard, M7.2 Productivity, M7.3 Charts, M7.4 Insights)
- [ ] M8: Backup (M8.1 Google Sign In, M8.2 Drive Backup, M8.3 Restore, M8.4 Export, M8.5 Import)
- [ ] M9: Settings (Theme, Language, Notifications, Backup Settings, About)
- [ ] M10: Performance (Optimization, Animations, Accessibility, Memory, Battery, Startup)
- [ ] M11: Release Candidate (Bug fixing, QA, Play Store assets, Documentation, Release)

## Next Milestone

## Next Milestone

- Milestone: M3.10 — Archive

## Development Order

- M0 Foundation
- M1 Design System
- M1.5 Device Validation
- M2 Backend Foundation
- M3 Home Experience
- M4 Organization
- M5 Time Management
- M6 Notes & Rich Content
- M7 Statistics
- M8 Backup
- M9 Settings
- M10 Performance
- M11 Release Candidate

## Notes

- Frozen specifications are stored in `docs/specs/`.
- Living documents are stored directly in `docs/`.
- The documentation split exists for Windows case-insensitive filesystem compatibility.
- Flutter is available locally.
- `flutter pub get`, `flutter analyze`, and `flutter test` pass.
- The obsolete default `test/widget_test.dart` template has been replaced with a minimal root `App` smoke test.
- `flutter build apk --debug` succeeds due to configuration workarounds for `isar_flutter_libs` and core library desugaring in Gradle.
