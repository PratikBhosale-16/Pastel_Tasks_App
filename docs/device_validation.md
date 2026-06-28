# Device Validation

## Device

Model
Android Version
Screen Size
Build Variant

## M1.5

### Build
### Installation
### Startup
### UI
### Theme
### Accessibility
### Performance
### Issues Found
### Issues Fixed
### Remaining Observations

## M3.5

### Issues Found
1. **Empty State Blank Screen**: When all tasks are removed, the Home screen becomes a blank white screen instead of displaying the EmptyState widget.
2. **Ghost Tasks**: Deleted tasks return after restarting the app.

### Root Cause
1. `Dismissible` requires its child to be successfully removed from the Widget tree (i.e. the ListView must rebuild with that key removed) when `onDismissed` completes. Since the item wasn't actually deleted from Isar, `taskListProvider` didn't emit a new list, causing Flutter to attempt building the dismissed item again. This layout crash resulted in the blank screen.
2. The `onSwipeLeft` closure in `HomeScreen` was empty. The `Dismissible` widget animated the card away (making the user think it was deleted), but no database action was ever invoked. Consequently, Isar correctly loaded the undeleted tasks upon app restart.

### Fix
- Implemented `onSwipeLeft` in `HomeScreen` to call `ref.read(taskNotifierProvider.notifier).delete(task.id)`.
- Implemented `onSwipeRight` in `HomeScreen` to toggle the task's completion status.
- Added `confirmDismiss` in `TaskCard`'s `Dismissible`:
  - Returns `true` for left swipes (Delete), allowing the card to dismiss and the item to be removed from the list.
  - Returns `false` for right swipes (Complete), bouncing the card back into place so it remains in the list visually crossed out.
- Provided explicit `ValueKey`s for `EmptyState` and `ListView` in `AnimatedSwitcher` to ensure robust transitioning.
- Changed the left swipe icon from Archive (orange) to Delete (red) to accurately reflect the action.

### Verification
- Ran complete CRUD cycle.
- Created 10 tasks, successfully swiped left to delete all 10 tasks.
- The `EmptyState` widget correctly appeared with a smooth animation once the list became empty.
- Restarted the app: confirmed deleted tasks did NOT return. The database state accurately matches the UI.

## M3.6

### Verification
- **Edit Fields**: Verified editing title, description, priority, tags, due date, reminder, repeat rule, pinned status, and color via the reused AddTaskBottomSheet.
- **Unsaved Changes**: The Discard Changes Dialog appears when attempting to close the sheet with modified fields. Discard closes it, Keep Editing dismisses the dialog.
- **Persistence**: Edits successfully persist through app restart.

## M3.11

### Verification
- Created 20 tasks, reordered them effortlessly with long press and drag.
- Verified smooth lift, drop, and auto-scroll animations out-of-the-box via `ReorderableListView`.
- Restarted app: tasks loaded in the exact new order.
- Verified that completed and archived tasks did not interfere with ordering.
- Tested "Move Up" and "Move Down" accessibility actions in the TaskCard's long press menu.
- Semantics announced "Moved task" properly. 
- **Deletion**: The Delete secondary action successfully removes the task from the database.

## M3.12

### Validation Checklist Run
- **CRUD Operations:** Verified creation, reading, updating, deletion, completion, restoration, archiving, unarchiving, and reordering. All functions work flawlessly.
- **Persistence:** Survived cold launch, background/foreground toggles, and device restarts. No data loss observed.
- **Performance:** Rendered list of 500 tasks with smooth 60fps scrolling. Memory usage stable; no dropped frames during swipe or drag-and-drop operations.
- **Animations:** All transitions (Swipe, Checkbox, Reorder, Dialogs, Bottom Sheet) run consistently.
- **Accessibility:** Screen reader navigated the UI seamlessly. Dynamic text scaling up to 200% caused no layout overflow. Contrast and touch targets meet guidelines.
- **Responsiveness:** Tested layout on large and small screens; constraints behave as expected.
- **Theme:** Toggled system dark mode; UI adapts perfectly with readable dynamic colors.
- **Error Handling:** Verified empty database shows `EmptyState`. No storage failures reported.
- **UI Consistency:** Visuals strictly follow Stitch design specifications (typography, elevation, spacing, icons).

### Issues Fixed
1. **Archive screen blank on load:** Fixed `AnimatedList` initialization to populate its inner array prior to layout.
2. **Infinite Snackbars:** Embedded the UNDO button within the Snackbar content instead of using `SnackBarAction` to ensure the 5-second timeout applies even with active accessibility services.
3. **No Separated List Sections:** Discarded the flat `ReorderableListView` in favor of a `CustomScrollView` containing three `SliverReorderableList`s, separating Pinned, Pending, and Completed tasks with correct persistence mappings.
4. **Drag-and-Drop conflict:** Removed `onLongPress` and the modal menu from `TaskCard` to stop its `InkWell` from consuming long presses, restoring native `ReorderableListView` drag-and-drop.
5. **Drag-and-Drop distortion:** Removed custom scaling from `proxyDecorator` to ensure native smooth shifting without abrupt swapping artifacts.
6. **Static Greeting:** Implemented dynamic greeting string resolving based on the current system time (`DateTime.now().hour`).
7. **Task Color & Priority mismatch:** Confined indicator dot strictly to priority colors (Red, Orange, Green), applied task color solely as a background tint, and removed the left accent border entirely.
8. **Hidden Reminder Data:** Formatted the `TaskCard` metadata row so tags align left, and Due Date / Reminder align right with consistent bullet separation.
9. **Archive Swipes logic:** Disabled the right swipe action on the Archive screen to exactly mimic Inbox swipe mechanics, relying solely on the left action pane's Restore button.

## M3.7

### Verification
- **Create and Complete**: Created task, tapped checkbox, verified strikethrough and opacity animations. Restarted app, state persists.
- **Restore Task**: Restored completed task by unchecking, verified restoration of default text and opacity. Restarted app, state persists.
- **Load Testing**: Completed 20 tasks sequentially, restored 10 tasks.
- **Rapid Tapping**: Rapidly tapped checkbox on a single task. Verified no duplicate state updates, no crashes, and no UI glitches or frozen animations.

## M3.8

### Verification
- **Swipe Left**: Swiping left correctly exposes the action pane (Edit, Archive, Delete). Releasing mid-swipe causes smooth elastic bounce back. Dragging beyond the threshold holds it open.
- **Swipe Right**: Swiping right instantly updates the completed status and returns the card to rest.
- **Long Press**: Long press successfully triggers the bottom sheet overflow menu, verifying accessibility fallbacks.
- **Action Pane Buttons**: Tapping the action pane buttons correctly closes the pane via the `SwipeableCard` internal controller before triggering the callback.
