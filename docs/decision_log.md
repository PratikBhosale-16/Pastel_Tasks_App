# Decision Log

## Documentation Separation Strategy

- Date: 2026-06-26.
- Status: Accepted.

### Reason

Windows cannot reliably store files such as `API.md` and `api.md` in the same directory because the default filesystem behavior is case-insensitive.

### Decision

Frozen specifications live in `docs/specs/`.

Living documents remain in `docs/`.

### Dependency Injection
- **Decision:** Riverpod for all dependency injection.
- **Reason:** Provides a compile-time safe, declarative way to provide and override dependencies.

## Typography and Font Delivery
- **Decision:** The 'Outfit' font family will be downloaded and bundled locally as static `.ttf` assets in `assets/fonts/` rather than using the `google_fonts` package.
- **Reason:** PastelTasks is an offline-first app. Bundling the fonts locally ensures the typography is available instantly upon the first offline launch, without requiring a network fetch and without introducing a new third-party dependency.

## Material 3 Theme Injection
- **Decision:** All design tokens (Colors, Typography, Spacing, Radius) are directly injected into standard Material 3 components within `AppTheme` (`ThemeData`).
- **Reason:** Reduces boilerplate at the widget level. Custom components automatically inherit the design system constraints without needing to read custom theme extensions manually for standard properties.

### Consequences

- Uppercase specification names remain available for approved baseline documents.
- Lowercase living tracker names remain available for development updates.
- The documentation structure stays compatible with Windows without requiring case-sensitive directory settings.
