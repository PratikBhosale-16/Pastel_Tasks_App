# Backup & Restore System

The backup and restore system in PastelTasks provides users with the ability to safely export, secure, and restore their data across devices. It aligns with the local-first philosophy of the application.

## Features Supported
- **Local Backups:** Exports the data as a `.json` file (or encrypted `.enc.json` if a password is provided) to the device's storage.
- **Google Drive Backups:** Exports data securely to the user's hidden Google Drive AppData folder, ensuring privacy while offering seamless cloud recovery.
- **Encryption:** AES-GCM encryption is supported for local backups to secure sensitive data.
- **Import/Export:** Users can easily import an existing backup file or export/share generated backups.
- **Restore Options:** Choose between Merging the backup with current data or Replacing the existing data completely.
- **Auto Backups:** Workmanager periodically triggers automatic backups if configured by the user.

## Data Payload
A backup payload (`BackupPayload`) is a single JSON structure consisting of:
- App Version and Backup Schema Version.
- Backup Creation Timestamp.
- Tasks Collection.
- Tags Collection.
- Reminders Collection.
- SharedPreferences Key-Value store (includes settings, preferences, and filters).

## Architecture Details
- **Domain Layer:** `BackupRepository` interface and `BackupPayload` definition.
- **Data Layer:** 
  - `LocalBackupRepository` manages device-side file logic.
  - `DriveBackupRepository` handles OAuth with Google Drive APIs.
  - `BackupCryptoService` handles compression to ZIP and AES-GCM encryption.
  - `BackupMapper` serializes/deserializes Isar models and SharedPreferences into JSON maps.
- **Presentation Layer:** Riverpod state notifiers to manage UI state and handle progress, built on `BackupScreen`.
