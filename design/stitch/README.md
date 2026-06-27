# Stitch Design Reference

## Purpose
This directory (design/stitch/) serves as the **UI Source of Truth** for the PastelTasks project. It contains design references generated using Stitch, organized by feature rather than flat screen names. These files exist to guide the implementation of the application's visual interface.

## Naming Conventions
- Folders are named logically by feature (e.g., home, calendar, onboarding/welcome).
- Each screen folder follows a strict structure:
  - README.md: Contains the screen purpose, primary components, and expected widgets.
  - eference.html: The generated markup (for structural/spacing context).
  - eference.png: The visual screenshot (the ultimate source of truth).
  - ssets/: A directory for any local image assets related to the screen.

## How AI Agents Should Use These Files
When tasked with implementing a screen or component, AI coding assistants must use this directory as a reference.

**CRITICAL RULES:**
1. Never translate HTML directly into Flutter.
2. HTML is a visual reference only.
3. Screenshot is the source of visual truth.
4. Follow DESIGN_SYSTEM.md.
5. Build reusable Flutter widgets instead of screen-specific widgets.
6. Compare Flutter implementation against the screenshot.
