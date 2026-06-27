# Architecture Decision Records (ADR)

**Project:** PastelTasks
**Version:** 1.0.0

---

# What is an ADR?

An Architecture Decision Record (ADR) documents important technical decisions made during the project.

Each ADR answers:

* What was decided?
* Why was it chosen?
* What alternatives were considered?
* What are the consequences?

---

# ADR-001

## Title

Flutter as the Application Framework

### Status

Accepted

### Date

2026-06-26

### Decision

Use Flutter as the primary framework.

### Reason

* Excellent performance
* Material 3 support
* Strong community
* Fast development
* Future iOS support

### Alternatives

* Native Android
* React Native
* Kotlin Multiplatform

---

# ADR-002

## Title

Feature-First Clean Architecture

### Status

Accepted

### Decision

Organize the application using Feature-First Clean Architecture.

### Reason

* Better scalability
* Easier maintenance
* Independent modules
* Easier testing

### Alternatives

* Layer-first architecture
* MVC
* MVP

---

# ADR-003

## Title

Riverpod

### Status

Accepted

### Decision

Riverpod is the application's state management solution.

### Reason

* Compile-time safety
* Minimal rebuilds
* Excellent testing
* No BuildContext dependency

### Alternatives

* Bloc
* Provider
* GetX

---

# ADR-004

## Title

GoRouter

### Status

Accepted

### Decision

Use GoRouter.

### Reason

* Official recommendation
* Nested navigation
* Deep linking
* Better maintainability

---

# ADR-005

## Title

Isar Database

### Status

Accepted

### Decision

Use Isar for local storage.

### Reason

* Fast
* Offline-first
* Reactive
* Flutter optimized

### Alternatives

* Drift
* Hive
* SQLite

---

# ADR-006

## Title

Offline First

### Status

Accepted

### Decision

The application will work completely offline.

### Reason

* Better privacy
* Faster performance
* No account required
* Better user experience

---

# ADR-007

## Title

Google Authentication

### Status

Accepted

### Decision

Google Sign-In is optional.

Used only for backup.

### Reason

Users should never be forced to create an account.

---

# ADR-008

## Title

Google Drive Backup

### Status

Accepted

### Decision

Use Google Drive JSON backup.

### Reason

Simple

Reliable

No backend maintenance

---

# ADR-009

## Title

Notifications

### Status

Accepted

### Decision

Use Local Notifications + WorkManager.

### Reason

Works offline

Reliable

Battery efficient

---

# ADR-010

## Title

No Premium Features

### Status

Accepted

### Decision

Every feature remains free.

### Reason

Better user trust

Simple product philosophy

No subscription complexity

---

# ADR Template

Future decisions should use:

---

## ADR-XXX

### Title

### Status

Proposed / Accepted / Deprecated

### Date

### Decision

### Context

### Alternatives

### Consequences

### Reason

### References

---

# Approval

Status: Approved
