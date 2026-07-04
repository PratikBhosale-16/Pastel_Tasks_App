# Android Home Screen Widgets (M5.6)

PastelTasks uses the `home_widget` package to implement 7 premium Android home screen widgets, utilizing Material You dynamic colors.

## Architecture

The system is split into two parts:

### 1. Flutter Data Syncing (`WidgetSyncService`)
Located at `lib/features/widgets/services/widget_sync_service.dart`.
This service listens to Isar `taskCollections` using `watchLazy()`. Whenever a task is created, updated, completed, deleted, or restored, the service automatically fetches the latest data (today's tasks, upcoming tasks, progress stats) and saves it as JSON strings or integer primitives into Android's `SharedPreferences` via the `home_widget` plugin. 

After updating the data, it triggers a widget redraw using `HomeWidget.updateWidget(androidName: "...")`.

### 2. Native Android Rendering
Located in `android/app/src/main/kotlin/com/example/pastel_tasks/` and `android/app/src/main/res/`.
The Android app defines 7 `AppWidgetProvider` classes in Kotlin. When triggered, these providers:
1. Load their respective XML layouts via `RemoteViews`.
2. Extract the updated data from `SharedPreferences`.
3. Set up `PendingIntent`s using `HomeWidgetLaunchIntent.getActivity()` to deep link back into the Flutter app.
4. Render the UI using `@android:color/system_accent1_100` for dynamic colors on Android 12+, with static pastel fallbacks in `res/values/colors.xml` and `res/values-night/colors.xml`.

## Widget Types

1. **Quick Add Widget (2x2)**: Instantly opens the app to add a new task.
2. **Today's Tasks Widget (2x2)**: Shows a summary of tasks due today.
3. **Upcoming Tasks Widget (4x2)**: Displays the next 5 upcoming tasks.
4. **Progress Widget (2x2)**: Shows today's task completion progress.
5. **Calendar Widget (4x4)**: A mini monthly calendar.
6. **Smart Lists Widget (4x2)**: Quick access shortcuts to Today, Overdue, and Pinned lists.
7. **Statistics Widget (2x2)**: Displays current streak and productivity score.

## Adding a New Widget
1. Add a new Kotlin class extending `HomeWidgetProvider`.
2. Add its XML layout in `res/layout/`.
3. Add its provider info XML in `res/xml/`.
4. Register the receiver in `AndroidManifest.xml`.
5. Update `WidgetSyncService.dart` to calculate the data for it and call `updateWidget()`.
