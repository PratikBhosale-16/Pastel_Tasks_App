# Project Status

## Current Milestone

- Milestone: M2.4
- Name: State Management
- Status: Completed
- Validation: Implemented core Riverpod providers and domain Notifiers bridging the Repository Layer without UI logic.
- Overall Progress: Data access patterns and reactive state management established.

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

## Phase 2: Domain & Persistence (In Progress)
- [x] M2.1: Domain Architecture
- [x] M2.2: Database Layer
- [x] M2.3: Repository Layer
- [x] M2.4: State Management

## Pending

- M2 Task Management Core.
- M3 Task Organization.
- M4 Calendar and Reminders.
- M5 Search and Statistics.
- M6 Backup and Restore.
- M7 Settings and Personalization.
- M8 Performance and Polish.
- M9 Testing and QA.
- M10 Release Candidate.

## Next Milestone

- Milestone: M2.2 — Database Layer

## Development Order

- M0.1 Project Foundation.
- M0.2 Application Bootstrap.
- M0.3 Core Infrastructure.
- M1.1 Theme Foundation.
- M1.2 Component Library.
- M1.3 Application Shell.
- M1.4 Developer Preview & Validation.
- M1.5 Device Validation & UX Polish.
- M2 Task Management Core.
- M3 Task Organization.
- M4 Calendar & Reminders.
- M5 Search & Statistics.
- M6 Backup & Restore.
- M7 Settings.
- M8 Performance & Polish.
- M9 Testing & QA.
- M10 Release Candidate.

## Notes

- Frozen specifications are stored in `docs/specs/`.
- Living documents are stored directly in `docs/`.
- The documentation split exists for Windows case-insensitive filesystem compatibility.
- Flutter is available locally.
- `flutter pub get`, `flutter analyze`, and `flutter test` pass.
- The obsolete default `test/widget_test.dart` template has been replaced with a minimal root `App` smoke test.
- `flutter build apk --debug` succeeds due to configuration workarounds for `isar_flutter_libs` and core library desugaring in Gradle.
