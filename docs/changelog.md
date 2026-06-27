# Changelog

## 2026-06-27

### Completed

- Completed M0.3 Core Infrastructure.
- Added reusable application configuration, environment, and build metadata abstractions.
- Added date/time, UUID, connectivity, and haptic services.
- Added secure storage and application preferences abstractions.
- Added general email, required, string length, and date validators.
- Added reusable String and DateTime extensions.
- Added debounce, throttle, timing constants, and formatting helpers.
- Added the common repository marker contract.
- Added typed validation, storage, network, and unknown failures integrated with `Result<T>`.
- Updated logger levels to suppress verbose output in release builds.

## [Unreleased]
- M1.4: Completed Developer Preview & Validation.
- Added `DevPreviewScreen` showcasing all typography, colors, layout components, and widgets.
- Updated `AppRouter` to default to developer preview route.
- Validated complete design system via passing widget tests.
- M1.3: Completed Application Shell.
- Added reusable layout components: `AppScaffold`, `AppAppBar`, `AppBottomNavigation`, `AppFab`, `SectionHeader`, and `PageContainer`.
- M1.2: Completed Component Library.
- Added base buttons, cards, chips, text fields, icons, and layout helpers to `lib/shared/`.
- Added `shared_preferences` for non-sensitive application preferences.
- Confirmed no features, screens, widgets, models, collections, providers, or feature repositories were added.

### Theme Foundation (M1.1)

- Completed Theme Foundation (AppColors, AppTypography, AppSpacing, AppRadius, AppShadows).
- Injected all tokens into a comprehensive Material 3 `AppTheme`.
- Bundled 'Outfit' variable font locally in `assets/fonts/`.
- Created developer-only `theme_preview_page.dart` for visual verification.
- Validated with `flutter build apk`, `flutter test`, and `flutter analyze`.

### Validation

- Confirmed all required M0.3 source files are present.
- Confirmed dependency keys are unique.
- Confirmed the changed source contains no `TODO`, `FIXME`, or `print()` placeholders.
- Confirmed Flutter tooling is available locally.
- `flutter pub get` passes.
- `flutter analyze` passes with no issues.
- `flutter test` passes.
- Updated the obsolete default `test/widget_test.dart` template to use the real root `App` widget.
- Added a minimal app shell smoke test so the test suite has an executable target.
- Confirmed YouTube playback is not required by the approved PRD, TRD, or roadmap.
- Removed `youtube_player_flutter` and `flutter_inappwebview` from the resolved dependency graph by updating approved `flutter_quill` to 11.5.1.
- Android build validation remains blocked: `flutter build apk --debug` reaches Gradle but fails while configuring `isar_flutter_libs` 3.1.0+1 because its Android module does not specify a namespace.

### Changed

- Cleaned foundation imports and analyzer issues required for M0.3 validation.
- Added the standard `flutter_test` SDK dev dependency.
- Recorded that M1 is split into M1.1 Theme Foundation, M1.2 Base Components, M1.3 Feedback Components, and M1.4 Validation.

## 2026-06-26

### Completed

- Completed M0.2 Application Bootstrap.
- Added `main.dart` entrypoint that calls `bootstrap()` only.
- Added application bootstrap with Flutter bindings, logger, Isar setup, notification service structure, ProviderScope, and App startup.
- Added `MaterialApp.router` app shell.
- Added minimal app config, environment, router, and theme structure.
- Added global logger service.
- Added generic result type and base exception hierarchy.
- Added Isar setup without collections.
- Confirmed no features, screens, repositories, models, collections, task logic, backup, or authentication were implemented.

### Documentation

- Restored milestone M0.3 Core Infrastructure between Application Bootstrap and Design System.
- Confirmed the development order as M0.1 Project Foundation, M0.2 Application Bootstrap, M0.3 Core Infrastructure, then M1 Design System.
