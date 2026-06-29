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
- M4.3: Completed Intelligent Task Search. Implemented fast, local in-memory task searching. Created `debouncedSearchQueryProvider` for 300ms debounce handling. Created `searchedTasksProvider` to stack on top of `filteredTasksProvider`, scanning task title, description, tags, reminder trigger time, and repeat rules (case-insensitive). Built reusable `TaskSearchBar` with integrated clear button and focus management, and added to the top of `HomeScreen`. Created `HighlightText` widget to visually emphasize matched query substrings within `TaskCard` title and description using the primary theme color. Added full test coverage for search matching logic.
- M4.2: Completed Advanced Task Filtering. Added reusable filter models and persistence via `FilterRepository`. Added Riverpod state management `FilterNotifier` and `filteredTasksProvider` for non-destructive, in-memory list filtering. Built `FilterBottomSheet` and `ActiveFiltersRow` UI components and integrated them natively into `HomeScreen`.
- M4.1: Completed Tag Management. Implemented tag models, Isar persistence logic, state notifier, and reusable `TagFormBottomSheet`. Built a standalone `TagsScreen` to manage (CRUD) list of tags, including manual drag-and-drop tag ordering via a `ReorderableListView`.
- M3.12: Completed Home Experience Validation & Polish. Fixed critical bug where undoing a deleted or archived task failed because the SnackBar's callback used a detached `WidgetRef`. Removed TODO comments in `home_screen.dart` and validated CRUD operations, swipe gestures, reordering, accessibility, and app persistence on physical devices. Fixed Archive screen list initialization to render correctly on first load. Fixed snackbar accessibility durations by embedding inline action buttons. Rewrote `HomeScreen` list layout using `CustomScrollView` and separate `SliverReorderableList` sections to isolate Pinned, Pending, and Completed tasks with correct persistence and styling. Fixed drag-and-drop gesture conflicts in `TaskCard`. Implemented dynamic time-based greetings on Home screen. Fixed drag and drop visual distortions by adding a custom `proxyDecorator` to `SliverReorderableList`. Corrected task card indicator dot to always map to task priority (High: Red, Medium: Orange, Low: Green) while using task color as a subtle background tint. Standardized default task accent border to neutral outline variant when no custom color is selected. Fixed archive screen swipe actions to correctly restore archived tasks on right swipe. Added formatted reminder string display to bottom row of task card. Updated Archive screen visuals for muted text, and correctly mapped right-swipes inside the archive list to perform an unarchive/restore operation. Finalized UX polish for TaskCard metadata layout (Tags left, Dates/Repeat right), default accent borders, repeat indicators. Completed final performance optimization pass: extracted `_KeyboardPadding` to isolate `MediaQuery` rebuilds during bottom sheet interactions, and converted `TaskCard` to a stateless `const` widget using localized `ConsumerWidget` access to prevent 60-FPS full-list widget tree rebuilds during scrolling and animation.
- M3.11: Implemented smooth drag-and-drop task reordering on the Home Screen using `ReorderableListView.builder`. Added explicit Move Up/Down accessibility actions in the Task Card's long-press menu to ensure compliance with inclusive UX guidelines. Connected reordering updates dynamically with the `TaskNotifier` and Isar `TaskRepository`.
- M3.10: Implemented task archiving functionality. Built a dedicated `ArchiveScreen` utilizing `AnimatedList` for smooth entry/exit animations. Updated `TaskCard` to display archived state without checkboxes. Added integrated Archive and Restore buttons directly into the `AddTaskBottomSheet`. Ensured archived tasks are excluded from the `HomeScreen` via `taskListProvider(isArchived: false)` while preserving underlying data. Undo support remains robust across swipe, menu, and bottom sheet entry points.
- M3.9: Implemented permanent task deletion. Built a reusable `ConfirmationDialog`. Updated `AddTaskBottomSheet` to use secondary delete actions natively. Transformed `HomeScreen` ListView to an `AnimatedList` with an automatic list-diffing algorithm for robust Material motion removal. Integrated Undo via SnackBar that leverages the underlying Isar auto-increment ID to restore a task without breaking domain identities.
- M3.8: Implemented native `SwipeableCard` to replace `Dismissible` in `TaskCard`. Supports non-destructive left-swipe action pane (Edit, Archive, Delete) requiring explicit tap. Maintained right-swipe completion. Added long press menu as an accessibility fallback for all swipe actions.
- M3.7: Implemented task completion and restoration via the existing `TaskCard` checkbox. Added smooth `AnimatedOpacity` and `AnimatedDefaultTextStyle` Material transitions. Used `SemanticsService` to broadcast accessibility announcements on state change. `Task` domain entity updated to properly support clearing `completedAt`.
- M3.6: Implemented full task editing by reusing `AddTaskBottomSheet`. Added pre-filled fields logic, a discard changes dialog to prevent accidental data loss, and a secondary action button to delete tasks directly from the edit view.
- M3.5: Connected `AddTaskBottomSheet` to the backend. Created tasks now map local form data to `Task` entities and persist in the local Isar database. The `HomeScreen` reacts automatically via `taskListProvider` stream.
- M3.4: Added `AddTaskBottomSheet` UI component with local validation, layout structure for task metadata (priority, tags, dates, reminder, repeat rules, color, pinned), and responsive keyboard support.
- M3.3: Rebuilt the reusable `EmptyState` component with comprehensive named constructor presets (taskList, search, tag, etc.) and Material motion.
- M3.2: Implemented the reusable `TaskCard` component with Swipe Actions (Dismissible) and integrated it into the `HomeScreen`.
- M3.1: Completed Home Screen implementation. Introduced EmptyState reusable widget, created initial app bar, navigation bar, and hooked up the Home Screen to `taskListProvider`.
- Updated overarching project roadmap in living documentation to outline M3 (Home Experience) through M11 (Release Candidate) granular milestones.
- M2.4: Completed State Management layer. Introduced Riverpod for repository dependency injection, state filtering, and mutation (Notifiers).
- M2.3: Completed Repository Layer. Created pure Dart interfaces for Tasks, Tags, and Reminders, implemented with Isar.
- M2.2: Completed Database Layer. Implemented Isar database service, Task/Tag/Reminder collections, indexes, and migration infrastructure (Schema version 1).
- M2.1: Completed Domain Architecture. Created pure Dart entities, enums, value objects, and domain validators for the Task domain.
- M1.5: Completed Device Validation & UX Polish.
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
- Android build validation completed successfully.
  Validated:
  ✓ flutter pub get
  ✓ flutter analyze
  ✓ flutter test
  ✓ flutter build apk --debug
- Fixed startup crash caused by Isar initialization before any collections existed.
- Database initialization is intentionally deferred until M2 because no collections currently exist.

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
