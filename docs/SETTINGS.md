# Settings Architecture

The PastelTasks settings page is entirely data-driven, allowing easy addition, removal, reordering, and modification of settings without writing new UI code.

## Core Concepts

### SettingsItem
The base model for all settings (`features/settings/domain/models/settings_item.dart`).
Every setting item has:
- `id`: Unique identifier
- `title`: Display title
- `subtitle`: Optional descriptive text
- `icon`: Optional icon
- `storageKey`: Key used for `SharedPreferences` persistence
- `defaultValue`: Default state if not found in storage
- `keywords`: Array of terms used for instantaneous client-side search filtering
- `isVisible`: Optional callback returning bool to conditionally hide items

### Types of Settings
- `SettingsItemSwitch`: Boolean toggle.
- `SettingsItemNavigation`: Navigates to a sub-route on tap.
- `SettingsItemAction`: Executes a callback function on tap.
- `SettingsItemDropdown<T>`: Displays a dropdown selection of type `T`.
- `SettingsItemInfo`: Displays static text/value (e.g. App Version).
- `SettingsItemColorPicker`: Displays a modal to choose theme/accent colors.

### Providers
All settings are registered in `features/settings/presentation/providers/settings_provider.dart`.
- `settingsSectionsProvider`: Exposes the definitive list of `SettingsSection` (which contain `SettingsItem`s).
- `settingsSearchQueryProvider`: Holds the current string from the search bar.
- `filteredSettingsSectionsProvider`: Derives from the sections and the query. Filters out non-matching items and hides empty sections.

### Extending
To add a new setting:
1. Identify the appropriate section in `settings_provider.dart`.
2. Instantiate the relevant `SettingsItem` subclass as a top-level constant.
3. Add the constant to the `items` array of that section.
4. If it requires custom interaction not supported by the existing types, create a new `SettingsItem` subclass and a corresponding widget in `settings_tiles.dart`, then handle it in `_buildSettingsTile` within `settings_screen.dart`.
