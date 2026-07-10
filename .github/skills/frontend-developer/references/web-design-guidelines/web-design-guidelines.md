---
name: frontend-web-design-guidelines
description: "Use when reviewing UI code, checking accessibility, auditing UX/design, or validating a page against web interface best practices. Triggers on: a11y, ARIA, focus state, keyboard navigation, forms, animation, color contrast, responsive, i18n, typography, touch, dark mode."
---

# Web Design Guidelines

Audit UI code against 100+ web interface best practices.

## How It Works

1. Fetch the latest guidelines from the source URL below
2. Read the specified files (or ask the user for files/pattern)
3. Check against all rules in the fetched guidelines
4. Output findings in `file:line` format

## Guidelines Source

Fetch fresh guidelines before each review:

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

Use `fetch_webpage` to retrieve the latest rules. The fetched content contains all rules and output format instructions.

## Usage

When a file or pattern argument is provided:
1. Fetch guidelines from the source URL above
2. Read the specified files
3. Apply all rules from the fetched guidelines
4. Output findings using the format specified in the guidelines

If no files are specified, ask the user which files to review.

## Categories Covered

| Category | Examples |
|----------|----------|
| **Accessibility** | `aria-label`, semantic HTML, keyboard handlers |
| **Focus States** | Visible focus, `focus-visible` patterns |
| **Forms** | Autocomplete, validation, error handling |
| **Animation** | `prefers-reduced-motion`, compositor-friendly transforms |
| **Typography** | Curly quotes, ellipsis, `tabular-nums` |
| **Images** | Dimensions, lazy loading, alt text |
| **Performance** | Virtualization, layout thrashing, preconnect |
| **Navigation & State** | URL reflects state, deep-linking |
| **Dark Mode & Theming** | `color-scheme`, `theme-color` meta |
| **Touch & Interaction** | `touch-action`, tap highlight |
| **Locale & i18n** | `Intl.DateTimeFormat`, `Intl.NumberFormat` |

## Related Skills
- Load `frontend-ux-designer` for UX principles and interaction design
- Load `frontend-react-performance` for React-specific performance rules
- Load `frontend-playwright-test-creator` for automating accessibility regression tests
