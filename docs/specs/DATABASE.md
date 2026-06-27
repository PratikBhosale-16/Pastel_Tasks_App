# Database Design Document (DATABASE)

**Project:** PastelTasks
**Version:** 1.0.0
**Status:** Approved
**Database:** Isar Database
**Last Updated:** 2026-06-26

---

# 1. Purpose

This document defines the complete database architecture for the PastelTasks application.

The application follows an **Offline-First** approach where all user data is stored locally using **Isar**.

Google Drive is used only for backup and restore.

---

# 2. Database Overview

Database Engine

**Isar**

Characteristics

* Fast NoSQL Database
* ACID Transactions
* Reactive Queries
* Index Support
* Zero SQL
* Flutter Optimized

---

# 3. Collections

The database consists of the following collections.

| Collection  | Purpose                        |
| ----------- | ------------------------------ |
| Task        | Stores all active tasks        |
| Tag         | User-defined categories        |
| ArchiveTask | Archived completed tasks       |
| Reminder    | Reminder metadata              |
| Settings    | Application settings           |
| Statistics  | Cached productivity statistics |
| BackupInfo  | Backup metadata                |

---

# 4. Entity Relationship Diagram

```text
Tag
 │
 │ Many-to-Many
 │
 ▼
Task
 │
 │ One-to-One
 ▼
Reminder

Task
 │
 │ After 24 Hours
 ▼
ArchiveTask

Settings
Independent

Statistics
Generated from Tasks

BackupInfo
Stores backup metadata
```

---

# 5. Task Collection

## Purpose

Stores all active tasks.

### Fields

| Field            | Type                     |
| ---------------- | ------------------------ |
| id               | long                     |
| uuid             | String                   |
| title            | String                   |
| description      | String                   |
| richText         | String (HTML/Delta JSON) |
| priority         | Enum                     |
| status           | Enum                     |
| createdAt        | DateTime                 |
| updatedAt        | DateTime                 |
| dueDate          | DateTime?                |
| reminderId       | long?                    |
| isPinned         | bool                     |
| isArchived       | bool                     |
| orderIndex       | double                   |
| color            | String                   |
| estimatedMinutes | int?                     |
| completedAt      | DateTime?                |

---

## Relationships

* Many Tags
* One Reminder

---

## Indexes

* uuid
* dueDate
* status
* priority
* orderIndex
* completedAt

---

# 6. Tag Collection

## Fields

| Field     | Type     |
| --------- | -------- |
| id        | long     |
| uuid      | String   |
| name      | String   |
| color     | String   |
| icon      | String   |
| createdAt | DateTime |

---

Indexes

* name
* uuid

---

# 7. Reminder Collection

## Fields

| Field          | Type     |
| -------------- | -------- |
| id             | long     |
| taskId         | long     |
| reminderDate   | DateTime |
| notificationId | int      |
| repeatType     | Enum     |
| repeatInterval | int      |
| isEnabled      | bool     |

---

Repeat Types

* None
* Daily
* Weekly
* Monthly
* Yearly
* Weekdays
* Custom

---

Indexes

* reminderDate
* taskId

---

# 8. Archive Collection

Stores completed tasks after 24 hours.

Same structure as Task.

Additional Fields

| Field         | Type     |
| ------------- | -------- |
| archivedAt    | DateTime |
| archiveReason | Enum     |

Archive Reasons

* Completed
* User Archived
* Auto Archived

---

# 9. Settings Collection

Only one record exists.

Fields

| Field                | Type      |
| -------------------- | --------- |
| theme                | String    |
| darkMode             | bool      |
| notificationsEnabled | bool      |
| archiveAfterHours    | int       |
| defaultPriority      | Enum      |
| defaultReminder      | Duration  |
| hapticsEnabled       | bool      |
| fontScale            | double    |
| googleBackupEnabled  | bool      |
| lastBackup           | DateTime? |

---

# 10. Statistics Collection

Cached values

| Field            | Type     |
| ---------------- | -------- |
| totalTasks       | int      |
| completedTasks   | int      |
| pendingTasks     | int      |
| streak           | int      |
| completionRate   | double   |
| weeklyCompleted  | int      |
| monthlyCompleted | int      |
| updatedAt        | DateTime |

---

# 11. BackupInfo Collection

Stores metadata only.

| Field         | Type     |
| ------------- | -------- |
| lastBackup    | DateTime |
| backupVersion | String   |
| checksum      | String   |
| googleAccount | String?  |

---

# 12. Enumerations

## TaskStatus

* Inbox
* Today
* Upcoming
* Completed
* Archived

---

## Priority

* Low
* Medium
* High
* Critical

---

## ReminderRepeat

* None
* Daily
* Weekly
* Monthly
* Yearly
* Weekdays
* Custom

---

## ArchiveReason

* Completed
* Manual
* Auto

---

# 13. Validation Rules

## Task

Title

* Required
* Maximum 150 characters

Description

* Optional
* Maximum 5000 characters

Rich Text

* Optional

Priority

* Required

Due Date

* Cannot be before creation date

Reminder

* Cannot be scheduled in the past

---

## Tag

Name

* Required
* Unique
* Maximum 30 characters

---

# 14. Soft Delete Strategy

Tasks are **never permanently deleted immediately**.

Flow

```text
Delete

↓

Recycle Bin (Future)

↓

Permanent Delete
```

Completed tasks follow:

```text
Pending

↓

Completed

↓

24 Hours

↓

Archive
```

---

# 15. Ordering Strategy

Manual drag-and-drop order is stored using `orderIndex`.

Advantages

* Fast reordering
* Minimal database writes
* Smooth drag performance

---

# 16. Transactions

All multi-step operations use Isar transactions.

Examples

* Create Task
* Update Task
* Archive Task
* Restore Task
* Backup Restore

---

# 17. Database Migrations

Migration policy

* Never delete user data
* Automatic migration
* Versioned schema
* Backup before major migration

---

# 18. Backup Serialization

JSON Structure

```json
{
  "version": "1.0.0",
  "backupDate": "...",
  "tasks": [],
  "tags": [],
  "settings": {},
  "statistics": {}
}
```

Excluded

* Temporary cache
* Notification IDs
* Generated statistics cache

---

# 19. Performance Strategy

* Indexed frequently queried fields
* Use lazy loading for large lists
* Avoid duplicate records
* Batch writes inside transactions
* Reactive queries for UI updates

Target

* Query response < 20 ms
* Reorder updates < 50 ms
* Database open < 100 ms

---

# 20. Data Integrity Rules

* Every task must have a unique UUID.
* Every tag name must be unique.
* Reminder must reference an existing task.
* Archived tasks retain original IDs and metadata.
* Backup version must match application schema.

---

# 21. Future Extensions

The schema is designed to support:

* AI-generated task metadata
* Habit tracking
* File attachments
* Shared lists
* Subtasks
* Pomodoro sessions
* Location reminders
* Cloud synchronization
* Cross-device sync

No breaking schema changes should be required.

---

# 22. Approval

**Status:** ✅ Approved

This document defines the official database schema for the PastelTasks application. All repositories, data sources, migrations, and backup operations must conform to this specification.
