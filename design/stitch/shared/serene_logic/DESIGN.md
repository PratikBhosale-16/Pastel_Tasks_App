---
name: Serene Logic
colors:
  surface: '#f9f9f7'
  surface-dim: '#dadad8'
  surface-bright: '#f9f9f7'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f4f4f2'
  surface-container: '#eeeeec'
  surface-container-high: '#e8e8e6'
  surface-container-highest: '#e2e3e1'
  on-surface: '#1a1c1b'
  on-surface-variant: '#494552'
  inverse-surface: '#2f3130'
  inverse-on-surface: '#f1f1ef'
  outline: '#7a7583'
  outline-variant: '#cac4d4'
  surface-tint: '#674bb5'
  primary: '#674bb5'
  on-primary: '#ffffff'
  primary-container: '#a78bfa'
  on-primary-container: '#3c1989'
  inverse-primary: '#cebdff'
  secondary: '#006c4b'
  on-secondary: '#ffffff'
  secondary-container: '#64f9bc'
  on-secondary-container: '#00714e'
  tertiary: '#0060ac'
  on-tertiary: '#ffffff'
  tertiary-container: '#5a9ff4'
  on-tertiary-container: '#003563'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e8ddff'
  primary-fixed-dim: '#cebdff'
  on-primary-fixed: '#21005e'
  on-primary-fixed-variant: '#4f319c'
  secondary-fixed: '#68fcbf'
  secondary-fixed-dim: '#45dfa4'
  on-secondary-fixed: '#002114'
  on-secondary-fixed-variant: '#005137'
  tertiary-fixed: '#d4e3ff'
  tertiary-fixed-dim: '#a4c9ff'
  on-tertiary-fixed: '#001c39'
  on-tertiary-fixed-variant: '#004883'
  background: '#f9f9f7'
  on-background: '#1a1c1b'
  surface-variant: '#e2e3e1'
typography:
  display-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 40px
    fontWeight: '700'
    lineHeight: 48px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '600'
    lineHeight: 36px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  base: 8px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-padding: 20px
  gutter: 16px
---

## Brand & Style

The design system is centered on "Digital Feng Shui"—a philosophy of radical clarity and soft aesthetics designed to reduce cognitive load for high-achievers. It targets individuals who find typical productivity tools "noisy" or stressful, offering instead a sanctuary for focus.

The style is a synthesis of **Minimalism** and **Soft-Tactile Modernism**. It prioritizes breathability and "airy" layouts while maintaining the precision of high-performance tools. The emotional goal is to transform task management from a chore into a calming ritual. Visuals are defined by high-key lighting, generous negative space, and a refined use of pastel hues to categorize without overwhelming.

## Colors

The palette utilizes a high-brightness, low-saturation approach to ensure a soothing experience. 

- **Primary (Lavender):** Used for primary actions, focus states, and the Floating Action Button (FAB).
- **Secondary (Mint):** Reserved for "Success" states, completed tasks, and health-related habits.
- **Tertiary (Sky Blue):** Applied to calm informational cues and scheduling.
- **Accent (Peach):** Used sparingly for priority flags or urgent reminders.
- **Background (Light Cream):** A warm off-white `#FAFAF8` serves as the canvas, reducing the harshness of pure white while maintaining high legibility.
- **Surface (Pure White):** All interactive cards and containers use `#FFFFFF` to "pop" subtly against the cream background.

## Typography

This design system employs **Plus Jakarta Sans** for its friendly, modern, and slightly rounded geometric structure. 

- **Headlines:** Use semi-bold weights with tight letter-spacing to feel premium and grounded.
- **Body Text:** Standard weight with increased line-height (1.5x) to ensure the interface feels "airy" and readable.
- **Labels:** Used for tags and metadata; these use medium weight and slight tracking to maintain legibility at small scales.
- **Hierarchy:** Contrast is achieved through weight and color (e.g., using a soft charcoal for body text instead of pure black) rather than excessive size differences.

## Layout & Spacing

The system follows a strict **8pt grid** to ensure mathematical harmony. 

- **Margins:** Mobile screens utilize a 20px side margin. Desktop layouts transition to a centered fixed-width container (max 800px) to maintain the "task list" intimacy.
- **Rhythm:** Vertical rhythm is aggressive; sections are separated by `32px` to prevent visual clutter. 
- **Grouping:** Related items (like sub-tasks) use `8px` spacing, while distinct cards use `16px`.
- **Safe Areas:** Bottom navigation and FAB placement respect Android's system gestures, with a `24px` buffer from the bottom edge.

## Elevation & Depth

Depth is communicated through **Tonal Elevation** and **Ambient Shadows**.

- **Level 0 (Background):** The Light Cream `#FAFAF8` base.
- **Level 1 (Cards):** Pure White `#FFFFFF` surfaces with a very soft, diffused shadow. Shadow properties: `Y: 4px, Blur: 20px, Color: rgba(0, 0, 0, 0.04)`.
- **Level 2 (Active/Floating):** Used for the FAB and active dialogs. Shadow properties: `Y: 8px, Blur: 24px, Color: rgba(167, 139, 250, 0.15)`.
- **Interaction:** Upon press, cards should slightly scale down (98%) and the shadow should diminish, providing a tactile "press" sensation.

## Shapes

The design system embraces high-radius geometry to evoke a sense of safety and friendliness.

- **Small Components:** Checkboxes and small tags use an `8px` (rounded-md) radius.
- **Standard Components:** Task cards and input fields use a `16px` (rounded-lg) radius.
- **Large Components:** Bottom sheets, dialogs, and the FAB use a `24px` to `32px` (rounded-xl) radius.
- **Iconography:** Use "Rounded" variant outlined icons. Stroke weight should be 1.5pt to match the medium typography weights.

## Components

- **Buttons:** Primary buttons are pill-shaped, using the Pastel Lavender background with white text. Ghost buttons use a subtle Lavender border.
- **Cards:** White surfaces with 16px padding. Titles are `title-md`.
- **Checkboxes:** Custom rounded squares (8px radius). When checked, they should morph into a filled state using Pastel Mint with a spring animation.
- **FAB:** A large, circular Lavender button. It should remain persistent but dim slightly when the user scrolls to prioritize content.
- **Inputs:** Minimalist fields with a subtle 1px border in a darker cream hue. On focus, the border transitions to Pastel Lavender with a soft outer glow.
- **Bottom Sheets:** Utilize a "handle" indicator at the top. The background is pure white with a 32px top-corner radius.
- **Chips:** Used for categories (e.g., "Work," "Personal"). These use the pastel color set (Sky Blue, Peach) with a 10% opacity background and 100% opacity text of the same hue.
- **Snackbars:** Floating at the bottom, 16px above the navigation bar. Darker charcoal background with rounded-lg corners to provide high-contrast feedback.