# PastelTasks

PastelTasks is an offline-first Flutter task management app focused on speed, privacy, and a calm productivity experience.

## Tech Stack

- Flutter and Dart
- Riverpod for state management
- GoRouter for navigation
- Isar for local persistence
- Google Sign-In and Google Drive APIs for optional backup
- Flutter Local Notifications and Workmanager for reminders and background work
- Very Good Analysis for static analysis

## Folder Structure

```text
lib/
  app/
    config/
    constants/
    environment/
    router/
    theme/
    app.dart
  bootstrap/
  core/
    errors/
    extensions/
    helpers/
    logging/
    services/
    storage/
    utils/
    validators/
  shared/
    animations/
    bottom_sheets/
    components/
    dialogs/
    icons/
    widgets/
  features/
  main.dart
```

Feature folders are intentionally not created during M0.1.

## Setup

1. Install Flutter stable.
2. Run `flutter pub get`.
3. Run `flutter analyze`.

## Development Workflow

- Keep frozen specifications in `docs/specs/`.
- Update living documentation in `docs/` as milestones progress.
- Add feature folders only when their milestone begins.
- Do not generate code unless the current milestone requires it.

## Documentation

- AI memory: `docs/brain.md`
- Project status: `docs/project_status.md`
- Documentation guide: `docs/README.md`
- Frozen specifications: `docs/specs/`
