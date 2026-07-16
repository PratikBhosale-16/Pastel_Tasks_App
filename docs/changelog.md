# Changelog

## 2026-07-15

### Fixed
- Replaced the task completion tone toggle with a dropdown allowing users to select between "None", "Correct Answer", or "Long Pop".
- Fixed the task completion tone playback issue by transitioning from a local AudioPlayer instance to a static AudioPlayer, preventing the player from being prematurely destroyed by Dart garbage collection before the sound finishes playing.
- Updated audio file extensions from `.mp3` to `.wav` for custom tones.

### Added
- Added date and time format settings in the application settings. Allows overriding system date/time formatting globally (12/24 hour time, date formats). Moved formatting logic into a unified `DateTimeFormatter` provider injected into the app layer.

## 2026-07-14

### Completed

- UI Overhaul: Redesigned `AddTaskBottomSheet` to use a minimalist, keyboard-aware floating layout. Replaced descriptions with dynamic sub-tasks. Implemented smart auto-completion where completing all sub-tasks marks the parent task as complete. Expanded pastel color palette to 20 options and added color/tag/calendar action bar.
- Create Task Polish: Added advanced Repeat Ends At logic (by Date or Count) backed by Isar schema updates. Refined the time picker clock to allow exact minute selection. Auto-enabled reminders upon time selection and persisted last-used reminder mode. Added in-line Tag creation and a visual Priority selector.
- M5.6: Built production-quality Adaptive Android Home Screen Widgets using Jetpack Glance and Kotlin. Designed dynamic layouts for ExtraSmall (1x1), Small (4x1), Medium (2x2), and Large (4x4). Leveraged `home_widget` to seamlessly sync task data via Android SharedPreferences into the native widget without spinning up the Flutter engine. Replaced simple text characters with native Material Drawables for Add, Refresh, and Settings buttons, utilizing circular corner radius masks for perfect ripple effects.

## 2026-07-03

### Completed

- M5.5: Implemented data-driven Settings UI architecture. Replaced static screens with dynamic `SettingsSection` and `SettingsItem` rendering. Added `SettingsDropdownTile` and `SettingsInfoTile`. Created exhaustive settings configurations across 12 categories (Appearance, Calendar, Backup, etc.). Added instantaneous client-side search filtering. Connected application-wide `ThemeMode` and `AppAccent` customisation to the root `MaterialApp`. Restored `calendarShowCompletedSwitch` to maintain calendar compatibility. Updated `ProfileCard` to support robust Guest vs Signed-In logic, prompting users toward Google Drive backups.


## 2026-07-02

### Fixed (Post-M5.3 Bug Fixes & UX Polish)

- **Filter Clearing**: Added "Properties" filter section in `SortAndFilterBottomSheet` with chips for Archived, Repeating, No Due Date, and Pinned. Added corresponding dismissible chips in `ActiveFiltersRow`.
- **Task Date Removal**: Fixed `Task.copyWith` to support `clearDueDate` flag, allowing users to remove a due date from a task via the edit bottom sheet.
- **Status Bar Visibility**: Added `AppBarTheme` with `SystemUiOverlayStyle.dark` to ensure the system status bar (time, battery, signal) is visible on all screens with light backgrounds.
- **Stat Card Labels**: Improved `AnimatedStatCard` title visibility so "Today", "This Week", and "Total" labels are clearly distinguishable.

## 2026-06-29

### Completed

- M4.6 Post-Validation Bug Fixes & UX Polish:
  - Fixed `TagFormBottomSheet` Bottom Overflow by implementing a scrollable view for keyboard awareness.
  - Replaced static tag selections in `AddTaskBottomSheet` and `BulkActionsBottomSheet` with a dynamic horizontal scrolling tag selector driven by `tagNotifierProvider`.
  - Added "+ New Tag" inline functionality to the dynamic tag selectors.
  - Added "Critical" priority option, utilizing a deep red color indicator.
  - Expanded task color palette to 12 Material 3 compatible pastel shades.
  - Ensured selected task color accurately persists and pre-fills in the Create/Edit UI.
  - Ensured dynamically created tags are instantly available to Smart Lists, Filters, Search, and Task Editor logic.
  - Consolidate and polish Home Screen UI: integrated Sort and Filter actions into a unified `SortAndFilterBottomSheet`, added Pinned visual indicators to `TaskCard`, and ensured robust keyboard-aware layout for `AddTaskBottomSheet`.
  - Redesigned `TagsScreen` to Material 3 standard (flat cards, dynamic trailing menu, and floating FAB) and integrated real-time dynamic task counts for each tag.
  - Implemented dynamic Task Counts across all `SmartList` tiles and the new `Tags` section inside `SmartListsDrawer`.
  - Added real-time icon color preview synchronization within `TagFormBottomSheet`.
  - Persisted the initially-collapsed state of the Sorting panel in `SortAndFilterBottomSheet` via a dedicated state provider.
  - Fixed syntax and build errors stemming from `AddTaskBottomSheet` refactoring, resulting in a successful build.
  - Fixed archived task filtering pipeline to ensure they are visible on the home screen when filtering by Status: Archived, and that search, sorting, and tag filters correctly operate on them.
  - Fixed tag counts and tag filtering bugs by standardizing `task.tags` to correctly store `tag.id` instead of `tag.name` across the app (including Add Task, Edit Task, Task Card, Tags Screen, and Filters).
  - Updated `TaskCard` to conditionally show the due date year if it does not match the current year, and appended an alarm icon if a reminder is set.
  - Updated `TagGridCard` and `SmartListsDrawer` to visually indicate when a tag's task list is completely finished by rendering a green checkmark instead of the task count.
- M4.4: Implemented Smart Sorting. Created persistent sorting preferences via `SortPreferences` (saving to `shared_preferences`). Integrated `sortedTasksProvider` with the search/filter task chain. Sorted tasks can be ascending/descending by date, priority, or alphabetically. Maintained positional stability for identical sort keys. Disabled drag-and-drop manual ordering when sorting by non-manual options. Added `SortBottomSheet` for UI control.
- M4.3: Implemented Intelligent Task Search. Built `TaskSearchBar`, `HighlightText`, and integrated Riverpod `searchedTasksProvider`. Search runs locally across titles and descriptions and works seamlessly on top of applied filters.
- M4.2: Implemented Advanced Task Filtering. Added robust `TaskFilter` options including tag matching, status filtering, and priority filtering. Built `FilterBottomSheet` and `ActiveFiltersRow` to seamlessly toggle and visualize state. Integrated with Isar local queries via Riverpod.
- M4.1: Implemented Tag Management. Added complete tag creation, editing, color assignment, and deletion. Integrated tagging seamlessly into `AddTaskBottomSheet` and `TaskCard`. Tag metadata maps successfully to domain models and persists to Isar.
- M3.12: Executed M3 UX Polish. Completed final Home screen UI fixes, updated greeting text, unified priority dot colors, enforced default task left borders, restored Task lifecycle undo functionality correctly against the Isar store, and removed animation jank. Verified behavior locally via flutter analyze/test.

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
### Added
- **Pre-M5.5 Architectural Refactoring: Data-Driven Settings Module**:
  - Refactored the entire Settings module to be data-driven.
  - Implemented core domain models: `SettingsItem`, `SettingsSection`, and `ProfileModel`.
  - Refactored `SettingsScreen` into a unified list builder iterating over `settingsSectionsProvider`.
  - Created `AccountService` and `GoogleAccountService` to prepare for cloud backups and display user profiles at the top of the settings page.
  - Added persistent SharedPreferences integration via `LocalSettingsRepository`.
  - Refactored existing settings ("Calendar Accent Color", "Show Completed Tasks in Calendar") to map to the new dynamic layout without breaking domain behavior.
  - Decoupled `DriveBackupRepository` by injecting `AccountService` for Google Sign-In state and `http.Client`.
- **M5.4 Backup & Restore System**:
  - Implemented local `.json` (and encrypted `.enc.json`) backups.
  - Implemented Google Drive backups leveraging the hidden AppData folder.
  - Integrated `archive` and `encrypt` packages for ZIP compression and AES-GCM encryption of backup payloads.
  - Added background automatic backup jobs via `WorkManager`.
  - Built `BackupScreen` with options to Merge or Replace existing data during restoration.
  - Developed custom serializers inside `BackupMapper` to convert Isar domain collections and SharedPreferences directly into JSON.
  - Fixed `LateInitializationError` during backup restore by safely falling back to generate a new `uuid` when it is missing from legacy backup payloads.
- **M5.3 Advanced Statistics Dashboard**:
  - Transformed the placeholder Stats page into a premium productivity dashboard.
  - Implemented real-time on-device metrics calculation via `StatsProvider`.
  - Added visual insights including: completed today/week/month, total tasks completed, average completion time, and most productive weekday/hour.
  - Created an interactive GitHub-style contribution Heatmap representing 14 weeks of activity.
  - Integrated `fl_chart` to display a bar chart of completions over the last 7 days and a pie chart detailing task priority breakdown.
  - Added animated progress gauges (using `TweenAnimationBuilder`) and streak indicators for Current and Longest Streak metrics.
- **M5.2 Smart Notifications & Reminder System**:
  - Fixed a critical UI bug where reminders created via the bottom sheet were ignored and not assigned to the Task object, preventing notifications from being scheduled.
  - Implemented robust background and foreground notification service using `flutter_local_notifications`.
  - Added Android channel configurations with exact alarm and boot completed permissions.
  - Implemented WorkManager integration (`workmanager`) for periodic background data sync.
  - Built comprehensive Notification Settings UI allowing customization of sound, vibration, heads-up, content preview, and quiet hours.
  - Built Notification History UI showing a chronological list of snoozed, completed, and missed notifications.
  - Enabled "Complete" and "Snooze" rich actions for notifications directly from the device tray.
  - Enhanced `TaskNotifier` to seamlessly duplicate and auto-schedule repeating tasks (Daily, Weekly, Monthly, Yearly) upon completion without overwriting task history.
  - Configured persistent local storage for notification settings using `shared_preferences`.
  - Configured persistent history for notifications using Isar database collections (`NotificationHistoryCollection`).
- **M5.1 Premium Calendar Screen**:
  - Implemented a completely redesigned Calendar screen using a modern premium aesthetic inspired by Stitch but rooted in the Pastel Tasks design language.
  - Built custom `MonthCalendar` with smooth gesture swiping between months and custom dot indicators for task density.
  - Implemented `CalendarHeader` with animated Next/Previous month transitions and bold typography.
  - Added an interactive `AgendaList` synchronized with `selectedDateProvider`, dynamically surfacing tasks due on the selected day, sorted by priority and due time.
  - Implemented real-time dynamic rendering of repeating tasks onto the calendar grid without writing duplicates to the database by leveraging `RepeatRule` projections in `monthTasksProvider`.
  - Polished the Empty State for days without tasks using a smooth `AnimatedSwitcher` fading/sliding transition.
  - Cleaned up custom theme tokens to strictly use Material 3 `Theme.of(context)` equivalents to ensure robust build stability.
  - Completed Calendar module UI synchronization to align with Inbox design language and architecture (using StatefulShellRoute).
  - Configured modal bottom sheets with `useRootNavigator: true` to prevent UI bleeding under the calendar.
  - Integrated `calendarAccentColorProvider` from Settings to personalize the Calendar highlights.
- **M4 Tags UI Redesign**:
  - Redesigned `TagsScreen` to a responsive 2-column staggered grid layout.
  - Built interactive `TagGridCard` with inline task count, progress bars, and up to 3 task previews.
  - Replaced native reordering with smooth `reorderable_grid_view` to ensure jitter-free drag-and-drop.
  - Implemented dynamic trailing `TagContextMenuBottomSheet` supporting Pin, Edit, Color, Merge, and Delete actions.
  - Integrated tag merging via `MergeTagDialog` and new `mergeTags` logic in `TaskNotifier` & `IsarTaskRepository`.
- **M4.7 Organization Validation & Freeze**:
  - Removed duplicate repository methods and obsolete providers to consolidate processing into a single reactive Riverpod pipeline.
  - Profiled `taskListProvider` memory filtering ensuring smooth 60 FPS performance.
  - Successfully generated and filtered 1,000 tasks.
  - Cleared all TODOs/FIXMEs and finalized Phase 4 architecture.
- **M4.6 Smart Lists**:
  - Implemented `SmartDateFilter` enum and updated `TaskFilter` to support relative dynamic date checking for "Today", "Tomorrow", "Upcoming", "Overdue", and "Completed Today" natively via Riverpod evaluation.
  - Added `SmartList` domain model and predefined lists repository.
  - Implemented `SmartListsDrawer` offering easy access to predefined views and integrated it into `HomeScreen`.
- **M4.5 Bulk Selection & Bulk Actions**:
  - Selection mode via long press on tasks.
  - Multi-select tasks to perform bulk actions via an animated SelectionAppBar.
  - Generic `bulkUpdate` and `bulkDelete` operations added to IsarTaskRepository to ensure high performance through single-transaction batches.
  - Bulk actions bottom sheet with complete, archive, delete, priority, tags, color, pin/unpin options.
  - Undo snackbars for bulk destructive actions (Delete, Archive).
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

## [2026-07-14] M5.6 Adaptive Android Widgets
- Re-architected Android home screen widgets into a single `AdaptiveWidgetProvider` using Jetpack Glance and Compose natively in Kotlin.
- Ensured a single widget can adapt to multiple sizes intelligently.
- Replaced RemoteViews with Jetpack Glance for modern Declarative UI design matching the premium Pastel Tasks aesthetic.
- Setup `WidgetSyncService` in Flutter to persist Isar data directly to `home_widget` SharedPreferences, allowing the widget to read tasks natively without booting the Flutter Engine.
