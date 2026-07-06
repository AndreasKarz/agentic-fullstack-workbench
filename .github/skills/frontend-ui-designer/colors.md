#  Brand Color Palette

All colors are defined as CSS custom properties in `src/frontend/app/_globals.css` under `:root`.
Always reference `var(--sl-*)` variables — never use raw hex values.

---

## Primary Colors

| Name            | Variable         | Hex       | Usage                                    |
|-----------------|------------------|-----------|------------------------------------------|
|  Red  | `--sl-red`       | `#E1001A` | Brand accent, primary CTAs, active states |
| Black           | `--sl-black`     | `#000000` | Headlines on images only                 |
| White           | `--sl-white`     | `#FFFFFF` | Backgrounds, cards, elevated surfaces    |

## Grey Tones (UI Structure)

Grey 06 is the main page background. Anthracite is the primary text color.

| Name        | Variable         | Hex       | Usage                                    |
|-------------|------------------|-----------|------------------------------------------|
| Anthracite  | `--sl-anthracite`| `#3C3C3C` | Primary text, headings                   |
| Dark        | `--sl-dark`      | `#4D4D4D` | Secondary text                           |
| Grey 15     | `--sl-grey-15`   | `#5E5E5E` | Tertiary text                            |
| Grey 25     | `--sl-grey-25`   | `#6E6E6E` | Placeholder text                         |
| Grey 35     | `--sl-grey-35`   | `#808080` | Disabled text                            |
| Grey 45     | `--sl-grey-45`   | `#919191` | Subtle labels                            |
| Grey 55     | `--sl-grey-55`   | `#A3A3A3` | Borders (strong)                         |
| Grey 65     | `--sl-grey-65`   | `#B5B5B5` | Borders (medium)                         |
| Grey 75     | `--sl-grey-75`   | `#C8C8C8` | Borders (light)                          |
| Grey 85     | `--sl-grey-85`   | `#DFDFDF` | Dividers, subtle borders                 |
| Grey 95     | `--sl-grey-95`   | `#F0F0F0` | Light backgrounds, hover states          |
| Grey 06     | `--sl-grey-06`   | `#F5F5F5` | Main background color                    |

## System Colors (Status Only)

| Name   | Variable      | Hex       | Usage                          |
|--------|---------------|-----------|--------------------------------|
| Blue   | `--sl-blue`   | `#1B0097` | Status indicators, info states |
| Green  | `--sl-green`  | `#2E8540` | Success status only            |

## Secondary Colors

Each secondary family has three levels: **base** (saturated), **light** (muted), **lightest** (subtle background).
Use for visual hierarchy, tags, badges, charts — never for structural UI.

### Bordeaux (warm accents)
| Level    | Variable                | Hex       |
|----------|-------------------------|-----------|
| Base     | `--sl-bordeaux`         | `#8D0226` |
| Light    | `--sl-bordeaux-light`   | `#E2A0B0` |
| Lightest | `--sl-bordeaux-lightest`| `#F5E5EC` |
Full ramp: `#8D0226` → `#A61538` → `#B83350` → `#C95169` → `#D7758A` → `#E2A0B0` → `#ECCAD5` → `#F5E5EC`

### Fig (purple)
| Level    | Variable            | Hex       |
|----------|---------------------|-----------|
| Base     | `--sl-fig`          | `#6D2077` |
| Light    | `--sl-fig-light`    | `#C1A4C8` |
| Lightest | `--sl-fig-lightest` | `#EBE3EE` |
Full ramp: `#6D2077` → `#83408E` → `#9960A2` → `#AD82B5` → `#C1A4C8` → `#D6C6DB` → `#EBE3EE`

### Rosemary (sage green)
| Level    | Variable                 | Hex       |
|----------|--------------------------|-----------|
| Base     | `--sl-rosemary`          | `#8AA282` |
| Light    | `--sl-rosemary-light`    | `#D4DACC` |
| Lightest | `--sl-rosemary-lightest` | `#F0F3EE` |
Full ramp: `#8AA282` → `#9BAF95` → `#ADBDA6` → `#C0CBB8` → `#D4DACC` → `#E4E8DF` → `#F0F3EE`

### Sand (warm neutral)
| Level    | Variable             | Hex       |
|----------|----------------------|-----------|
| Base     | `--sl-sand`          | `#BFA882` |
| Light    | `--sl-sand-light`    | `#E4DFCC` |
| Lightest | `--sl-sand-lightest` | `#F5F3ED` |
Full ramp: `#BFA882` → `#C9B695` → `#D2C3A6` → `#DBD1B8` → `#E4DFCC` → `#EDEADF` → `#F5F3ED`

### Sunflower (yellow)
| Level    | Variable                  | Hex       |
|----------|---------------------------|-----------|
| Base     | `--sl-sunflower`          | `#F1C832` |
| Light    | `--sl-sunflower-light`    | `#FAECB2` |
| Lightest | `--sl-sunflower-lightest` | `#FDF9E9` |
Full ramp: `#F1C832` → `#F3D14F` → `#F5D96E` → `#F8E28F` → `#FAECB2` → `#FCF3D1` → `#FDF9E9`

### Olive
| Level    | Variable              | Hex       |
|----------|-----------------------|-----------|
| Base     | `--sl-olive`          | `#807717` |
| Light    | `--sl-olive-light`    | `#C5C18F` |
| Lightest | `--sl-olive-lightest` | `#E9E7D8` |
Full ramp: `#807717` → `#968E30` → `#A59F4E` → `#B4AF6C` → `#C5C18F` → `#D6D4B4` → `#E9E7D8`

### Terracotta
| Level    | Variable                   | Hex       |
|----------|----------------------------|-----------|
| Base     | `--sl-terracotta`          | `#C1431B` |
| Light    | `--sl-terracotta-light`    | `#EDCFC8` |
| Lightest | `--sl-terracotta-lightest` | `#F4E5E0` |
Full ramp: `#C1431B` → `#CE6040` → `#D47B61` → `#DB9783` → `#E4B3A5` → `#EDCFC8` → `#F4E5E0`

### Thunderbird (red tones)
| Level    | Variable                     | Hex       |
|----------|------------------------------|-----------|
| Base     | `--sl-thunderbird`           | `#B1202C` |
| Light    | `--sl-thunderbird-light`     | `#D9A4AA` |
| Lightest | `--sl-thunderbird-lightest`  | `#F0E1E3` |
Full ramp: `#B1202C` → `#BC3E48` → `#C66169` → `#CF838A` → `#D9A4AA` → `#E5C6CA` → `#F0E1E3`

### Flamingo (pink)
`#F3A8AD` → `#F5B6BB` → `#F6C6CA` → `#F8D4D7` → `#FAE2E4` → `#FCEEF0`

### Almond (peach)
`#F3C3A1` → `#F5CFB4` → `#F7D9C4` → `#F8E2D3` → `#FAECE3` → `#FCF3EE`

### Pebble (gray-brown)
`#A19882` → `#AFA895` → `#BCB6A6` → `#C9C5B8` → `#D6D4CC` → `#E5E3DF` → `#F1F0ED`

---

## Rules
1. **Never use arbitrary hex colors** — always reference `var(--sl-*)` from `_globals.css`
2. ** Red** is the only strong accent — use sparingly for primary actions and active states
3. **Grey 06** (`#F5F5F5`) is the default page background
4. **White** (`#FFFFFF`) for content cards, panels, and elevated surfaces
5. **Anthracite** (`#3C3C3C`) for body text — never pure black for body text
6. **Grey 85** (`#DFDFDF`) for most borders and dividers
7. Secondary colors are for tags, badges, charts, selection states — not structural UI
8. Use **lightest** variants for backgrounds, **light** for subtle borders, **base** for text/icons
