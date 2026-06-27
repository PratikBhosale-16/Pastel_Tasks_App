# Design System Specification

**Project:** PastelTasks
**Version:** 1.0.0
**Status:** Approved

---

# 1. Design Philosophy

PastelTasks should feel:

* Calm
* Premium
* Minimal
* Friendly
* Modern

The interface should never feel crowded.

Whitespace is a design element.

Every animation should feel natural.

---

# 2. Design Principles

## Calm Productivity

Reduce cognitive load.

No unnecessary UI elements.

---

## Fast Interactions

Every important action should require as few taps as possible.

---

## Consistency

A component should always behave the same way throughout the app.

---

## Accessibility First

Large touch targets.

Readable typography.

Good contrast.

---

# 3. Color Palette

## Primary

Pastel Lavender

```text
#B8A8FF
```

---

## Secondary

Pastel Mint

```text
#A8E6CF
```

---

## Accent

Pastel Peach

```text
#FFD3B6
```

---

## Background

```text
#FAFAF8
```

---

## Surface

```text
#FFFFFF
```

---

## Success

```text
#A5D6A7
```

---

## Warning

```text
#FFE082
```

---

## Error

```text
#EF9A9A
```

---

## Information

```text
#81D4FA
```

---

## Primary Text

```text
#222222
```

---

## Secondary Text

```text
#666666
```

---

## Disabled Text

```text
#AAAAAA
```

---

# 4. Dark Theme

Background

```text
#121212
```

Surface

```text
#1E1E1E
```

Primary

Pastel Lavender

Text

```text
#F5F5F5
```

---

# 5. Typography

Font Family

Outfit

Scale

| Style    | Size | Weight   |
| -------- | ---- | -------- |
| Display  | 34   | Bold     |
| Headline | 28   | SemiBold |
| Title    | 22   | SemiBold |
| Subtitle | 18   | Medium   |
| Body     | 16   | Regular  |
| Caption  | 14   | Regular  |
| Small    | 12   | Regular  |

---

# 6. Spacing System

Base Grid

8dp

Spacing Tokens

```text
4
8
12
16
20
24
32
40
48
64
80
```

Never use arbitrary spacing.

---

# 7. Border Radius

| Token  | Radius |
| ------ | ------ |
| XS     | 8      |
| Small  | 12     |
| Medium | 18     |
| Large  | 24     |
| XL     | 32     |

---

# 8. Elevation

| Level  | Elevation |
| ------ | --------- |
| Flat   | 0         |
| Low    | 2         |
| Medium | 4         |
| High   | 8         |

Shadows should remain soft.

---

# 9. Iconography

Material Symbols Rounded

Standard Sizes

16

20

24

32

40

Never stretch icons.

---

# 10. Buttons

Primary

Filled

Secondary

Outlined

Tertiary

Text

Danger

Filled Red

Icon Button

Rounded

Loading Button

Integrated spinner

---

# 11. Floating Action Button

Large rounded rectangle

Contains

*

Quick Add

Shadow

Low

---

# 12. Task Card

Contains

Checkbox

Title

Tags

Priority

Reminder

Due Date

Drag Handle

Pinned Icon

Maximum height

Adaptive

Corner Radius

24dp

---

# 13. Chips

Rounded

Soft background

Minimum height

36dp

Padding

16dp

---

# 14. Search Bar

Rounded

Leading Search Icon

Trailing Filter Button

Elevation

0

Border

1dp

---

# 15. Dialogs

Rounded

28dp

Primary Action

Filled

Secondary

Text

---

# 16. Bottom Sheets

Rounded Top

28dp

Drag Handle

Visible

Scrollable

Yes

---

# 17. Snackbars

Floating

Rounded

Action Button

UNDO

---

# 18. Animations

Duration

| Type   | Duration |
| ------ | -------- |
| Fast   | 150ms    |
| Normal | 250ms    |
| Slow   | 350ms    |

Curves

* Ease In Out
* Fast Out Slow In

---

# 19. Microinteractions

Complete Task

Checkbox scales slightly.

Card fades.

Undo Snackbar appears.

Drag

Card lifts with shadow.

Save

Button ripple + haptic.

Delete

Slide animation.

---

# 20. Empty States

Every empty screen should include:

* Illustration
* Friendly message
* Primary action

---

# 21. Loading States

Use shimmer placeholders.

Avoid blocking loaders unless necessary.

---

# 22. Error States

Friendly language.

Include retry action where appropriate.

---

# 23. Accessibility

Minimum touch target

48 × 48 dp

Support

* Screen readers
* Dynamic font scaling
* High contrast

---

# 24. Responsive Rules

Phone

Single column

Tablet

Adaptive width

Foldable

Responsive layout

---

# 25. Component Naming

Buttons

```text
PrimaryButton
SecondaryButton
IconButton
```

Cards

```text
TaskCard
ProgressCard
StatisticCard
```

Inputs

```text
SearchField
RichTextEditor
TagSelector
```

---

# 26. Design Tokens

No hardcoded values inside widgets.

All values must come from:

* AppColors
* AppTypography
* AppSpacing
* AppRadius
* AppShadows
* AppAnimations

---

# 27. Approval

**Status:** ✅ Approved

This document defines the visual language of PastelTasks. All screens, widgets, and components must adhere to these tokens to ensure a consistent, premium user experience.
