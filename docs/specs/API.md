# API Design Document (API)

**Project:** PastelTasks
**Version:** 1.0.0
**Status:** Approved
**Last Updated:** 2026-06-26

---

# 1. Purpose

This document defines all external and internal service interfaces used by the PastelTasks application.

Since PastelTasks follows an **Offline-First Architecture**, the application does **not** communicate with a backend server during normal operation.

Instead, it interacts with:

* Local Database (Isar)
* Google Authentication
* Google Drive API
* Local Notification Service
* Background Scheduler

The architecture is designed so future cloud synchronization can be added without major refactoring.

---

# 2. Architecture

```text
                 Flutter App
                      │
         ┌────────────┼────────────┐
         │            │            │
         ▼            ▼            ▼
     Local DB   Notification   Background
      (Isar)      Service        Worker
         │
         ▼
   Backup Service
         │
         ▼
 Google Authentication
         │
         ▼
 Google Drive API
```

---

# 3. Internal Service Contracts

## Task Service

Responsible for all task operations.

### Methods

```text
createTask()

updateTask()

deleteTask()

archiveTask()

restoreTask()

duplicateTask()

reorderTasks()

completeTask()

getTasks()

searchTasks()

filterTasks()
```

---

## Tag Service

```text
createTag()

updateTag()

deleteTag()

getTags()

assignTag()

removeTag()
```

---

## Reminder Service

```text
scheduleReminder()

cancelReminder()

updateReminder()

rescheduleReminder()
```

---

## Statistics Service

```text
calculateDailyStats()

calculateWeeklyStats()

calculateMonthlyStats()

calculateStreak()

refreshStatistics()
```

---

## Backup Service

```text
createBackup()

restoreBackup()

exportJson()

importJson()

uploadToGoogleDrive()

downloadFromGoogleDrive()
```

---

# 4. Google Authentication API

Purpose

Authenticate only when the user chooses Google Drive Backup.

---

### Login

```http
POST /google/login
```

Internal Response

```json
{
  "success": true,
  "accessToken": "...",
  "email": "user@gmail.com"
}
```

---

### Logout

```http
POST /google/logout
```

Response

```json
{
  "success": true
}
```

---

# 5. Google Drive Backup API

### Upload Backup

```http
POST /drive/upload
```

Payload

```json
{
  "fileName": "PastelTasks_Backup.json",
  "version": "1.0.0",
  "createdAt": "2026-06-26T10:30:00Z"
}
```

Response

```json
{
  "success": true,
  "fileId": "drive_file_id",
  "uploadedAt": "2026-06-26T10:31:00Z"
}
```

---

### Download Backup

```http
GET /drive/download
```

Response

```json
{
  "success": true,
  "backupVersion": "1.0.0",
  "fileSize": 204800
}
```

---

### Delete Backup

```http
DELETE /drive/delete
```

Response

```json
{
  "success": true
}
```

---

# 6. Local Backup

Export Format

JSON

Destination

* Device Storage
* User-selected folder

Methods

```text
exportBackup()

importBackup()
```

---

# 7. Notification Service

### Schedule Reminder

Input

```json
{
  "taskId": 15,
  "title": "Study Flutter",
  "time": "2026-07-01T19:00:00",
  "repeat": "Daily"
}
```

Response

```json
{
  "scheduled": true,
  "notificationId": 225
}
```

---

### Cancel Reminder

Input

```json
{
  "notificationId": 225
}
```

Response

```json
{
  "success": true
}
```

---

# 8. Background Worker

Runs automatically.

Responsibilities

* Archive completed tasks older than 24 hours
* Refresh statistics
* Clean expired notification references
* Verify scheduled reminders

---

# 9. Error Model

Every service returns a unified result.

```json
{
  "success": false,
  "errorCode": "TASK_NOT_FOUND",
  "message": "Task does not exist."
}
```

---

# 10. Standard Success Response

```json
{
  "success": true,
  "message": "Operation completed successfully."
}
```

---

# 11. Error Codes

| Code                 | Description                |
| -------------------- | -------------------------- |
| TASK_NOT_FOUND       | Task does not exist        |
| TAG_NOT_FOUND        | Tag not found              |
| INVALID_INPUT        | Validation failed          |
| BACKUP_FAILED        | Backup operation failed    |
| RESTORE_FAILED       | Restore operation failed   |
| GOOGLE_SIGNIN_FAILED | Authentication failed      |
| NETWORK_ERROR        | Network unavailable        |
| NOTIFICATION_ERROR   | Reminder scheduling failed |
| UNKNOWN_ERROR        | Unexpected error           |

---

# 12. Retry Policy

Google Drive Operations

* Retry up to 3 times
* Exponential backoff
* Display friendly error after final failure

Notification Scheduling

* Retry once if scheduling fails

Database Transactions

* Automatic rollback
* No partial writes

---

# 13. Validation Rules

Before creating a task:

* Title is required
* Title ≤ 150 characters
* Due date cannot be before creation date
* Reminder cannot be in the past
* Duplicate tag names are rejected

Before backup:

* User must be signed in
* JSON schema version must match

---

# 14. Security

* OAuth 2.0 for Google Sign-In
* Tokens stored in `flutter_secure_storage`
* HTTPS required for all Google API requests
* No sensitive data written to logs

---

# 15. API Versioning

Current Version

```text
v1.0.0
```

Future versions will remain backward compatible whenever possible.

---

# 16. Future Cloud API

Reserved endpoints for future expansion.

```http
POST   /sync/upload

GET    /sync/download

POST   /ai/suggestions

POST   /collaboration/share

GET    /habits

POST   /attachments/upload
```

These endpoints are **not implemented in the MVP**.

---

# 17. Logging

Every service operation should log:

* Start time
* Completion time
* Duration
* Result
* Error (if any)

Debug logs are disabled in release builds.

---

# 18. Performance Targets

| Operation         | Target   |
| ----------------- | -------- |
| Create Task       | < 20 ms  |
| Update Task       | < 20 ms  |
| Delete Task       | < 20 ms  |
| Search Tasks      | < 100 ms |
| Backup Export     | < 2 sec  |
| Backup Restore    | < 3 sec  |
| Reminder Schedule | < 50 ms  |

---

# 19. Testing Requirements

Each service must include:

* Unit tests
* Mocked dependency tests
* Failure scenario tests
* Integration tests (where applicable)

---

# 20. Approval

**Status:** ✅ Approved

This API document defines the service contracts and external integrations for the PastelTasks application. All repository implementations, background services, backup features, and future integrations must conform to these interfaces.
