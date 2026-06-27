# Technical Requirements Document (TRD)

**Project:** PastelTasks
**Version:** 1.0.0
**Status:** Approved
**Based On:** PRD v1.0.0
**Last Updated:** 2026-06-26

---

# 1. Purpose

This document defines the technical architecture, engineering standards, technology stack, development workflow, testing strategy, security practices, and deployment plan for the PastelTasks mobile application.

The objective is to build a scalable, maintainable, offline-first Flutter application using modern software engineering practices.

---

# 2. Technical Objectives

* Offline-first architecture
* Modular codebase
* High performance
* Easy maintenance
* Scalable architecture
* Strong separation of concerns
* Testable components
* Clean UI architecture
* Efficient local storage
* Minimal rebuilds
* Smooth animations
* AI-friendly project structure

---

# 3. Technology Stack

| Category             | Technology                                 |
| -------------------- | ------------------------------------------ |
| Framework            | Flutter (Latest Stable)                    |
| Language             | Dart 3                                     |
| UI Toolkit           | Material Design 3                          |
| Architecture         | Clean Architecture                         |
| Design Pattern       | MVVM + Repository Pattern                  |
| State Management     | Riverpod (Code Generation)                 |
| Navigation           | GoRouter                                   |
| Dependency Injection | Riverpod Providers                         |
| Database             | Isar                                       |
| Serialization        | Freezed + json_serializable                |
| Local Notifications  | flutter_local_notifications                |
| Background Jobs      | WorkManager                                |
| Authentication       | Google Sign-In (Optional)                  |
| Backup               | Google Drive REST API                      |
| Logging              | logger                                     |
| Secure Storage       | flutter_secure_storage                     |
| Shared Preferences   | shared_preferences                         |
| Testing              | flutter_test + mocktail + integration_test |
| Linting              | flutter_lints                              |

---

# 4. High-Level Architecture

```
+---------------------------+
|     Presentation Layer    |
| (Widgets, Screens, Theme) |
+-------------+-------------+
              |
              ▼
+---------------------------+
| ViewModels (Riverpod)     |
+-------------+-------------+
              |
              ▼
+---------------------------+
|      Domain Layer         |
|  UseCases / Entities      |
+-------------+-------------+
              |
              ▼
+---------------------------+
| Repository Interfaces     |
+-------------+-------------+
              |
              ▼
+---------------------------+
| Repository Implementations|
+-------------+-------------+
              |
      +-------+--------+
      |                |
      ▼                ▼
+-----------+   +------------------+
|   Isar    |   | Google Drive API |
+-----------+   +------------------+
```

---

# 5. Architecture Principles

The project follows:

* Clean Architecture
* MVVM
* Repository Pattern
* SOLID Principles
* DRY
* KISS
* YAGNI
* Single Responsibility Principle
* Dependency Inversion Principle

Business logic must never reside inside UI widgets.

---

# 6. Feature-First Modular Structure

```
lib/

app/
core/
shared/
features/
```

Each feature is isolated.

Example:

```
features/

home/
calendar/
tasks/
tags/
completed/
profile/
settings/
statistics/
backup/
search/
onboarding/
```

Each feature contains:

```
feature/

data/
domain/
presentation/
```

---

# 7. Layer Responsibilities

## Presentation Layer

Contains:

* Screens
* Widgets
* Theme
* UI State
* Navigation

No business logic.

---

## Domain Layer

Contains:

* Entities
* Use Cases
* Repository Interfaces

Independent from Flutter.

---

## Data Layer

Contains:

* Isar Collections
* Repository Implementations
* Data Sources
* DTOs
* Mappers

---

# 8. State Management

Riverpod is used throughout the application.

Provider Types

* Provider
* StateProvider
* AsyncNotifierProvider
* NotifierProvider

Benefits

* Compile-time safety
* Minimal rebuilds
* Easy testing
* No BuildContext dependency

---

# 9. Navigation

GoRouter manages navigation.

Main Routes

```
Splash
Onboarding
Home
Calendar
Tags
Completed
Profile
Settings
Search
Statistics
Task Details
Add/Edit Task
```

Nested navigation will be used where appropriate.

---

# 10. Local Database

Database

Isar

Primary Collections

* Tasks
* Tags
* Settings
* Archive
* Statistics Cache

Advantages

* Extremely fast
* Native Flutter support
* Reactive queries
* No SQL required

---

# 11. Background Processing

## Reminder Service

Schedules local notifications.

Requirements

* Works offline
* Works after app restart
* Works when app is terminated

---

## Archive Service

Runs daily.

Workflow

Completed Task

↓

24 Hours

↓

Move to Archive

Implemented using WorkManager.

---

# 12. Backup Strategy

Normal Usage

Offline only.

Optional Backup

Settings

↓

Google Sign-In

↓

Google Drive

↓

JSON Backup

↓

Restore

No cloud database.

No user account required.

---

# 13. Security

* No unnecessary permissions
* Offline-first storage
* Secure storage for authentication tokens
* Sensitive preferences encrypted
* Backup authentication isolated from application usage

---

# 14. Error Handling

Every repository returns a Result type representing either Success or Failure.

UI must handle four states:

* Loading
* Success
* Empty
* Error

No uncaught exceptions should reach the presentation layer.

---

# 15. Logging

Logging Levels

* Debug
* Info
* Warning
* Error

Logging disabled in Release builds except critical errors.

---

# 16. Performance Strategy

* Const constructors wherever possible
* Immutable state
* Efficient Riverpod providers
* Lazy loading
* Optimized Isar indexes
* Image caching
* Minimal widget rebuilds
* Background processing for heavy operations

Target

* 60 FPS animations
* Cold start under 2 seconds
* Low memory usage

---

# 17. Accessibility

Support

* Dynamic font scaling
* Screen readers
* Large touch targets
* High contrast compatibility
* Haptic feedback
* Semantic labels

---

# 18. Dependency Management

All packages managed through `pubspec.yaml`.

Rules

* Use stable packages only
* Avoid unnecessary dependencies
* Document every new dependency
* Review package maintenance before adoption

---

# 19. Coding Standards

Naming

* PascalCase → Classes
* camelCase → Variables & Methods
* snake_case → Files
* SCREAMING_SNAKE_CASE → Constants

Rules

* No magic numbers
* No duplicated code
* Meaningful naming
* Small focused classes
* Single responsibility
* Explicit error handling
* Consistent formatting

---

# 20. Testing Strategy

## Unit Tests

Cover

* Use Cases
* Repositories
* Services
* Utility Functions

Target Coverage

80%+

---

## Widget Tests

Cover

* Task Cards
* Calendar
* Bottom Sheets
* Dialogs
* Progress Indicators

---

## Integration Tests

Cover

* Task Creation
* Editing
* Drag & Drop
* Reminder Scheduling
* Archive Workflow
* Backup & Restore

---

# 21. CI/CD Strategy

GitHub Actions pipeline

```
Analyze

↓

Format Check

↓

Run Unit Tests

↓

Run Widget Tests

↓

Run Integration Tests

↓

Build APK

↓

Generate Release
```

---

# 22. Release Strategy

Development

↓

Internal Testing

↓

Beta

↓

Stable Production Release

Versioning follows Semantic Versioning.

Example

```
1.0.0
```

---

# 23. Documentation Strategy

Every development session updates:

```
docs/

brain.md
project_status.md
decision_log.md
architecture.md
features.md
database.md
api.md
bugs.md
roadmap.md
todos.md
changelog.md
```

Documentation must remain synchronized with implementation.

---

# 24. Definition of Done

A feature is considered complete only if:

* Builds successfully
* No compilation errors
* Lint passes
* Unit tests pass
* Widget tests pass
* Integration tests pass
* Error handling implemented
* Loading state implemented
* Empty state implemented
* Accessibility reviewed
* Performance reviewed
* Documentation updated
* brain.md updated
* project_status.md updated

---

# 25. Technical Constraints

* Android 12+ (API 31)
* Offline-first operation
* No mandatory login
* Google authentication only for backup
* No advertisements
* No premium features
* All features available free

---

# 26. Architectural Decisions (ADR-001)

| Decision         | Selected Option         |
| ---------------- | ----------------------- |
| Framework        | Flutter                 |
| Language         | Dart                    |
| Architecture     | Clean Architecture      |
| Pattern          | MVVM + Repository       |
| State Management | Riverpod                |
| Navigation       | GoRouter                |
| Database         | Isar                    |
| Authentication   | Optional Google Sign-In |
| Notifications    | Local Notifications     |
| Background Jobs  | WorkManager             |
| Backup           | Google Drive JSON       |
| Offline Support  | Offline First           |
| Monetization     | None                    |

---

# 27. Risks & Mitigation

| Risk                     | Mitigation                                     |
| ------------------------ | ---------------------------------------------- |
| Large database           | Isar indexing and optimized queries            |
| Notification reliability | WorkManager + Local Notifications              |
| Backup failures          | JSON validation and retry mechanism            |
| UI performance           | Riverpod, immutable state, widget optimization |
| Data corruption          | Atomic transactions and backup support         |

---

# 28. Future Scalability

The architecture is designed to support future enhancements without major refactoring, including:

* AI task assistant
* Natural language task creation
* Voice input
* Pomodoro timer
* Habit tracking
* Widgets
* Wear OS companion
* Shared task lists
* Cross-device synchronization
* Web application
* iOS support

---

# 29. Approval

**Status:** ✅ Approved

This TRD establishes the official technical blueprint for the PastelTasks application. All implementation, testing, deployment, and documentation activities must conform to the architecture and standards defined in this document.
