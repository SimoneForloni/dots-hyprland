# Versioning Strategy (0.x Milestones)

## Overview

The project roadmap is structured into **macro-versions** (`0.0`, `0.1`, `0.2`, etc.). To keep development manageable and incremental, macro-versions are broken down into **sub-versions** (`0.x.y`).

The distinction is:

- **Macro-version (`0.x`)**: Represents a major architectural milestone or functional phase.
- **Sub-version (`0.x.y`)**: Represents a complete, tangible, and testable increment within a macro-version.
- **Git Commit**: Represents an atomic code modification and does not require a version bump.

---

## The Golden Rule for Sub-versions

Before tagging a sub-version (`0.x.y`), ask:

> _"Is this state testable, cohesive, and usable as a milestone checkpoint?"_

If **yes**, create a sub-version.
If **no** (e.g., just added a single component or fixed a typo), it belongs in a regular Git commit.

### Examples

- **Good Sub-version**: `0.2.7 — Completed primitive Material widgets` (Provides a full set of reusable UI components).
- **Too Small**: `0.2.7 — Added MaterialButton.qml` (Better suited as a single commit inside a milestone).

---

## When to Bump

### Increment `0.x.y` (Sub-version)

Bump `0.x.y` when:

- A coherent functional chunk of a macro-phase is completed.
- A testable checkpoint is reached.
- An architectural layer stabilizes.

### Increment `0.x` (Macro-version)

Bump `0.x` when:

- The main goal and definition of done ("Fatto quando") for the current macro-stage is achieved[cite: 1, 2].
- The project is ready to transition to the next feature area.

### Do NOT Bump Version

Do not create a version bump for:

- Updating a single file or line.
- Small internal bugfixes or minor refactoring without behavioral changes.
- Renaming files or internal variables.

---

## Git Tags & Changelog Integration

1. **Git Tags**: Sub-versions (`v0.x.y`) and macro-versions (`v0.x`) SHOULD be tagged in Git at meaningful checkpoints.
2. **`CHANGELOG.md`**: Tracks notable sub-versions and macro-releases. Individual commits do not need individual entries in the changelog.

---

## Summary

- **Macro-version (`0.x`)**: Defines where we want to go.
- **Sub-version (`0.x.y`)**: Defines a verifiable checkpoint along the way.
- **Commit**: Describes the technical change required to get there.
