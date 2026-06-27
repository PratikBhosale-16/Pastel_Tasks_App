# User Experience Design Document (UX)

**Project:** PastelTasks
**Version:** 1.0.0
**Status:** Approved
**Last Updated:** 2026-06-26

---

# 1. UX Vision

## Design Philosophy

PastelTasks is designed to make productivity feel calm rather than stressful.

The interface should be:

* Clean
* Minimal
* Elegant
* Friendly
* Soft
* Fast
* Intuitive

The user should never feel overwhelmed.

Every interaction should require the minimum number of taps possible.

---

# 2. Design Principles

## Calm Productivity

The interface should reduce cognitive load.

Avoid:

* clutter
* unnecessary icons
* excessive colors
* complicated menus

---

## One-Hand Friendly

All important actions should be reachable with one hand.

---

## Minimal Friction

Creating a task should take less than five seconds.

---

## Delightful Microinteractions

Animations should be subtle.

Never distracting.

---

# 3. Visual Style

Theme

Modern Minimal

Inspired by

* Material 3
* Apple Human Interface Guidelines
* Notion
* Todoist
* TickTick

---

# 4. Color System

## Background

Warm White

```
#FAFAF8
```

---

## Surface

```
#FFFFFF
```

---

## Primary

Pastel Lavender

```
#B8A8FF
```

---

## Secondary

Pastel Mint

```
#A8E6CF
```

---

## Accent

Pastel Peach

```
#FFD3B6
```

---

## Success

```
#A5D6A7
```

---

## Warning

```
#FFE082
```

---

## Error

```
#EF9A9A
```

---

## Text

Primary

```
#222222
```

Secondary

```
#666666
```

Disabled

```
#AAAAAA
```

---

# 5. Typography

Primary Font

Outfit

Weights

* Regular
* Medium
* SemiBold
* Bold

No extra-bold text.

---

# 6. Spacing System

Base Unit

8dp

Spacing

* 4
* 8
* 12
* 16
* 20
* 24
* 32
* 40
* 48

---

# 7. Border Radius

Small

12dp

Medium

18dp

Large

24dp

Cards

24dp

Bottom Sheet

28dp

FAB

22dp

---

# 8. Shadows

Very subtle.

Never harsh.

---

# 9. Iconography

Rounded Material Icons

Consistent stroke width.

---

# 10. Navigation Structure

```
Splash

↓

Onboarding

↓

Home
│
├── Calendar
├── Tags
├── Statistics
├── Completed
└── Settings
```

Bottom Navigation

* Home
* Calendar
* Tags
* Statistics
* Settings

Completed tasks are accessed from Home.

---

# 11. User Journey

## First Launch

Splash

↓

Onboarding

↓

Permissions

↓

Home

---

## Daily Flow

Open App

↓

Inbox

↓

Complete Tasks

↓

View Statistics

↓

Close App

---

## Reminder Flow

Reminder

↓

Notification

↓

Tap

↓

Task Details

↓

Complete

---

# 12. Screen Hierarchy

## Splash

Purpose

Brand recognition.

Duration

1.5 seconds.

---

## Onboarding

Three pages

1. Organize beautifully
2. Stay focused
3. Everything works offline

Button

Get Started

---

## Home

Contains

Greeting

Search

Task Filters

Inbox

Today's Tasks

Pinned Tasks

Floating Action Button

---

## Calendar

Monthly calendar.

Agenda below.

---

## Tags

Grid layout.

Shows

* Color
* Icon
* Task Count

---

## Task Details

Contains

Title

Rich Notes

Tags

Priority

Reminder

Recurring

Archive

Delete

---

## Statistics

Cards

* Completion Rate
* Weekly Progress
* Monthly Progress
* Streak

---

## Settings

Theme

Notifications

Backup

Export

Import

Archive Duration

About

---

# 13. Home Layout

```
Greeting

Search Bar

Quick Filters

Pinned Tasks

Inbox

Today

Upcoming

Completed Preview

Floating Action Button
```

---

# 14. Quick Add Bottom Sheet

Fields

Task Title

Tags

Priority

Reminder

Due Date

Save Button

Cancel Button

---

# 15. Task Card Design

Each card contains

Checkbox

Title

Tags

Priority Indicator

Due Date

Reminder Icon

Drag Handle

Rounded corners

Soft shadow

Swipe gestures

---

# 16. Swipe Actions

Swipe Right

Complete

Swipe Left

Archive

Long Press

Drag

---

# 17. Drag & Drop

Long press

↓

Lift animation

↓

Drag

↓

Drop

↓

Smooth reposition animation

---

# 18. Animations

Duration

200–300 ms

Animations

* Fade
* Scale
* Slide
* Hero
* Reorder
* Ripple

Never bounce excessively.

---

# 19. Haptic Feedback

Provide haptic feedback for

* Completing a task
* Dragging
* Long press
* Saving
* Archive

---

# 20. Empty States

Inbox Empty

"Nothing here yet."

Completed Empty

"No completed tasks."

Calendar Empty

"No tasks scheduled."

Statistics Empty

"Complete tasks to see insights."

---

# 21. Loading States

Use shimmer placeholders.

Avoid loading spinners where possible.

---

# 22. Error States

Friendly messages.

Examples

"Something went wrong."

"Unable to restore backup."

Provide retry actions.

---

# 23. Accessibility

Support

* Dynamic Text
* Screen Readers
* High Contrast
* Large Touch Targets
* Semantic Labels

---

# 24. Dark Theme

Soft dark palette.

Background

```
#121212
```

Cards

```
#1E1E1E
```

Primary

Pastel Lavender

Muted text.

---

# 25. Responsive Design

Support

* Phones
* Tablets
* Foldables

Adaptive layouts.

---

# 26. Component Library

Buttons

Cards

FAB

Bottom Sheet

Dialog

SnackBar

Search Bar

Calendar Cell

Task Card

Tag Chip

Progress Card

Statistic Card

Floating Menu

---

# 27. Design Tokens

Spacing

8dp grid

Radius

12–28dp

Animation

200–300ms

Icon Size

24dp

Card Elevation

2dp

---

# 28. UX Success Metrics

The experience is considered successful when:

* Users create a task in under five seconds.
* Navigation feels intuitive without onboarding repetition.
* Animations remain smooth at 60 FPS.
* All primary actions are reachable with one hand.
* Users can distinguish task priority, reminders, and tags at a glance.
* Empty, loading, and error states feel polished rather than unfinished.

---

# 29. Future UX Enhancements

* Interactive widgets
* AI task suggestions
* Voice task creation
* Smart recurring task suggestions
* Drag tasks directly onto calendar dates
* Custom pastel theme creator
* Multiple layout options (List, Compact, Kanban)

---

# 30. Approval

**Status:** ✅ Approved

This UX document defines the visual language, interaction patterns, navigation, and component behavior for the PastelTasks application. All future UI implementation must follow these guidelines to ensure a consistent and high-quality user experience.
