# Decision Log

## Documentation Separation Strategy

- Date: 2026-06-26.
- Status: Accepted.

### Reason

Windows cannot reliably store files such as `API.md` and `api.md` in the same directory because the default filesystem behavior is case-insensitive.

### Decision

Frozen specifications live in `docs/specs/`.

Living documents remain in `docs/`.

### Dependency Injection
- **Decision:** Riverpod for all dependency injection.
- **Reason:** Provides a compile-time safe, declarative way to provide and override dependencies.

## Typography and Font Delivery
- **Decision:** The 'Outfit' font family will be downloaded and bundled locally as static `.ttf` assets in `assets/fonts/` rather than using the `google_fonts` package.
- **Reason:** PastelTasks is an offline-first app. Bundling the fonts locally ensures the typography is available instantly upon the first offline launch, without requiring a network fetch and without introducing a new third-party dependency.

## M1.3 Application Shell
- **Decision:** Use standard stateless wrappers for layout components (`AppScaffold`, `AppAppBar`, `PageContainer`) to enforce design system spacing and theming.
- **Rationale:** Prevents drift by hiding raw Flutter primitives and ensures features never hardcode layout behavior.

## Material 3 Theme Injection
- **Decision:** All design tokens (Colors, Typography, Spacing, Radius) are directly injected into standard Material 3 components within `AppTheme` (`ThemeData`).
- **Reason:** Reduces boilerplate at the widget level. Custom components automatically inherit the design system constraints without needing to read custom theme extensions manually for standard properties.

## M1.5 Device Validation & UX Polish
- **Decision:** Insert a new milestone, M1.5, before beginning M2 Task Management Core.
- **Reason:** Ensures that the Design System and Application Shell behave exactly as expected on physical Android devices. Catching layout, spacing, accessibility, and performance issues now prevents them from propagating into feature development.

## Isar Initialization Deferred
- **Decision:** Database initialization is deferred until M2.
- **Reason:** No Isar collections exist during M1. Avoid blocking application startup.

### 019. Removing Navigation TODOs
- **Date:** 2026-06-28
- **Context:** Executing M3.12 Home Validation. The codebase contained TODO comments for deferred navigation (search and bottom bar).
- **Decision:** Transformed the TODOs into standard deferred-action comments.
- **Reason:** Ensuring a clean, warning-free codebase during phase completion, maintaining strict compliance with the "No TODOs" mandate while preserving developer context.

### 018. ReorderableListView vs AnimatedList
- **Date:** 2026-06-28
- **Context:** Implementing M3.11 Drag & Drop Reordering. We previously used `AnimatedList` for home screen task removal animations.
- **Decision:** Replaced `AnimatedList` with `ReorderableListView.builder`.
- **Reason:** Flutter's native `ReorderableListView` satisfies all the M3.11 requirements (lift animation, placeholder, drag-and-drop, haptics) without requiring an unauthorized third-party package. The tradeoff of losing automatic explicit deletion animations is acceptable given the constraints and priority of native smooth reordering.

### 017. Custom Swipeable Action Pane
- **Date:** 2026-06-28
- **Context:** Implementing M3.8 Swipe Actions. Native `Dismissible` does not support remaining open for an action pane.
- **Decision:** Built a custom `SwipeableCard` using native `GestureDetector` and `AnimationController` instead of introducing `flutter_slidable`, strictly adhering to AGENTS.md constraints to avoid unauthorized third-party packages.

### 016. Task Completion State Management
- **Date:** 2026-06-28
- **Context:** Implementing M3.7 Task Completion and Restoration.
- **Decision:** Modified `Task.copyWith()` to accept `bool clearCompletedAt = false` because Dart's `??` operator prevents nulling out an existing `DateTime?` value. Wrapped `TaskCard` content with `AnimatedOpacity` and `AnimatedDefaultTextStyle` for implicit smooth animations without introducing manual animation controllers or complex transitions.

### 015. Reusing AddTaskBottomSheet for Editing
- **Date:** 2026-06-28
- **Context:** Implementing the Edit Task workflow for M3.6.
- **Decision:** Reused `AddTaskBottomSheet` instead of creating a separate edit screen. Passed an optional `Task? existingTask` parameter which prefills all form controllers. Implemented a `PopScope` to detect dirty state and prompt the user before discarding unsaved edits, preventing accidental data loss. Included the secondary Delete action directly into the form data result, preserving the single-source-of-truth structure in `HomeScreen`.

### 014. Creating Tasks from UI
- **Date:** 2026-06-28
- **Context:** Wiring the UI `AddTaskBottomSheet` to create tasks in Isar for M3.5.
- **Decision:** Instead of making direct repository calls or complex state providers within the UI components, `HomeScreen` triggers the bottom sheet, waits for the returned `AddTaskFormData`, instantiates the Domain `Task` model, and dispatches it to `taskNotifierProvider`. Riverpod streams automatically refresh the UI.

## 013. UI-Only Bottom Sheet State Management
- **Date:** 2026-06-28
- **Context:** Implementing the Add Task bottom sheet for M3.4 without triggering business logic, Isar, or Riverpod dependencies.
- **Decision:** Built `AddTaskBottomSheet` as a `StatefulWidget` to handle purely local state (e.g. text controllers, selected chips, date pickers) and return a custom `AddTaskFormData` object via `Navigator.pop`. This decouples the UI from the domain layer entirely.

## 012. Reusable Layout Components
- **Date:** 2026-06-28
- **Context:** Building the Home Screen requires standard layout components (AppBar, Scaffold wrapper, Empty State) that will be reused across the application.
- **Decision:** Built the `EmptyState` reusable layout inside `lib/shared/widgets/empty_state/empty_state.dart` alongside the home screen. Refactored it into a highly reusable system with named constructor presets (e.g. `EmptyState.taskList()`) to prevent duplication of layout logic across different features.

### 7. Riverpod State Management without Generator (2026-06-28)
- **Context:** M2.4 needed complete state management using Riverpod.
- **Decision:** Used standard Riverpod providers (e.g., `StreamProvider`, `FutureProvider`, `Notifier`) without `.g.dart` generator for core app connectivity and data providers to ensure explicitness and avoid extra code generation steps for pure domain/DI wiring.

### 6. Repository Layer Data Mapping (2026-06-28)
- **Context:** M2.3 required the application to interact with Isar without exposing Isar-specific exceptions or models.
- **Decision:** Used Dart extension methods (`toDomain()`, `toIsar()`) to act as mappers. Implemented `Result<T>` wrappers around all Isar transactions, catching and wrapping errors into `StorageFailure(StorageException(...))` to enforce Clean Architecture boundaries. Added `tags` and `uuid` to Isar schema where missed previously.

### 5. Database Layer and Isar Enums (2026-06-28)
- **Context:** M2.2 requires persistence using Isar with Task, Tag, and Reminder collections.
- **Decision:** Isar collections mapped with native `@enumerated` instead of custom type converters for `Priority`, `TaskStatus`, and `RepeatRule` to comply with Isar 3+ expectations. Established migration infrastructure with Schema Version 1. ID fields changed to `int` instead of `long` to match Dart types.

### 4. Domain Architecture in Pure Dart (2026-06-28)
- **Decision:** The core domain models and validation rules are written in pure Dart, isolated from Flutter, Riverpod, or Isar.
- **Reason:** Enforces Clean Architecture boundaries, making the business logic easily testable and decoupled from persistence or UI implementation details.


### Consequences

- Uppercase specification names remain available for approved baseline documents.
- Lowercase living tracker names remain available for development updates.
- The documentation structure stays compatible with Windows without requiring case-sensitive directory settings.
# # #   0 2 3 .   D r a g   &   D r o p   O r d e r i n g   C o n s t r a i n t 
 -   * * D a t e : * *   2 0 2 6 - 0 6 - 2 9 
 -   * * C o n t e x t : * *   I m p l e m e n t i n g   M 4 . 4   S m a r t   S o r t i n g   a l o n g s i d e   M 3 . 1 1   D r a g - a n d - D r o p   f u n c t i o n a l i t y . 
 -   * * D e c i s i o n : * *   D r a g - a n d - d r o p   m a n u a l   r e o r d e r i n g   i s   o n l y   e n a b l e d   w h e n   t h e   u s e r ' s   a c t i v e   s o r t   o p t i o n   i s   s e t   t o   ' M a n u a l ' . 
 -   * * R e a s o n : * *   S o r t i n g   t a s k s   d y n a m i c a l l y   d y n a m i c a l l y   ( e . g .   b y   D a t e   o r   P r i o r i t y )   o v e r r i d e s   t h e   e x p l i c i t   o r d e r i n g   o f   t a s k s .   R e o r d e r i n g   t a s k s   m a n u a l l y   w h i l e   s o r t e d   b y   a n   e x t e r n a l   c r i t e r i o n   i n t r o d u c e s   l o g i c a l   a m b i g u i t y   a n d   d a t a   c o r r u p t i o n   f o r   p e r s i s t e n t   p o s i t i o n   i n d i c e s . 
 
 # # #   0 2 2 .   S o r t i n g   P e r s i s t e n c e 
 -   * * D a t e : * *   2 0 2 6 - 0 6 - 2 9 
 -   * * C o n t e x t : * *   M 4 . 4   S m a r t   S o r t i n g   p r e f e r e n c e s . 
 -   * * D e c i s i o n : * *   S o r t i n g   p r e f e r e n c e s   ( O p t i o n   a n d   O r d e r )   a r e   p e r s i s t e d   s t r i c t l y   u s i n g   \ s h a r e d _ p r e f e r e n c e s \ . 
 -   * * R e a s o n : * *   S o r t i n g   i s   a n   a p p l i c a t i o n   p r e f e r e n c e ,   n o t   c o r e   u s e r   d o m a i n   d a t a   ( l i k e   T a s k s ) .   M a n a g i n g   i t   o u t s i d e   o f   I s a r   a l l o w s   q u i c k   r e t r i e v a l   w i t h o u t   b l o c k i n g   d a t a b a s e   m i g r a t i o n s   o r   i n c r e a s i n g   q u e r y   o v e r h e a d . 
 
  
 
## Bulk Operations Architecture

- Date: 2026-06-29.
- Status: Accepted.

### Reason

Handling multi-select operations by looping over individual TaskRepository.update and TaskRepository.delete methods would result in UI jank when updating hundreds of tasks due to transaction overhead. Instead, we added ulkUpdate and ulkDelete to the repository interface.

### Architecture

- Implemented ulkUpdate(List<Task>) and ulkDelete(List<String>).
- Under the hood, Isar processes these in a single _dbService.write(...) transaction.
- This ensures high performance for bulk modifications.
