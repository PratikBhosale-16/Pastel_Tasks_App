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
- **Deletion**: The Delete secondary action successfully removes the task from the database.
