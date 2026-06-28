# M2 Task Management Core - Implementation Plan

## 1. Domain Model
The domain model establishes the core business entities of PastelTasks without any external dependencies (No Flutter, No Isar).
- **Entities**: `Task`, `Tag`, `Reminder`
- **Value Objects / Enums**: `Priority`, `TaskStatus`, `RepeatRule`
- **Validation**: Domain-level validation resides in `TaskValidator` to enforce business rules (e.g., Title length, date constraints) before any data persistence occurs.

## 2. Repository Architecture
The repository layer will abstract data access from the rest of the application.
- **Interfaces**: Domain repository interfaces (`TaskRepository`, `TagRepository`) will be defined in `lib/features/tasks/domain/repositories/`.
- **Implementations**: The concrete implementations will reside in `lib/features/tasks/data/repositories/` and will depend on Isar for local persistence.
- **Result Type**: All repository methods will return a `Result<T>` wrapper to ensure explicit error handling in the presentation layer.

## 3. Isar Strategy
Isar will be used as the exclusive offline-first local database.
- **Architecture**: Isar setup is located at `lib/infrastructure/database/isar/` instead of `lib/core/` to ensure a clean architectural separation.
- **Collections**: We will map our domain entities to Isar collections (`TaskCollection`, `TagCollection`, `ReminderCollection`) in `lib/features/tasks/data/collections/`.
- **Mappers**: Data Transfer Objects (DTOs) or extension methods will bridge the gap between pure Dart domain models and Isar annotated classes.
- **Initialization**: Once the first Isar collections are created in M2.2, the temporary initialization bypass in `IsarService` will be removed.

## 4. Provider Strategy
State management will rely exclusively on Riverpod.
- **Data Providers**: Providers for repositories and use cases will be scoped cleanly.
- **State Providers**: UI state will be driven by `AsyncNotifierProvider` or `NotifierProvider` to handle loading, success, and error states gracefully.

## 5. Migration Strategy
Database migrations are handled by Isar's automatic migration for structural changes.
- Ensure that `uuid` is generated consistently.
- For more complex migrations (e.g., schema breaking changes), manual migration scripts will be placed in the initialization flow before opening Isar.

## 6. Testing Strategy
- **Unit Tests**: Domain models, validators, and mapping logic will have extensive unit tests covering success paths and edge cases (e.g., validation throws).
- **Integration Tests**: Repository implementations will be tested using a localized in-memory or temporary Isar instance to ensure data persistence works correctly.
