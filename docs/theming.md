# Theming & Styling Guide

`valk-gui` styles every built-in component from `win.theme` (`gui.Theme`). You can switch themes at runtime by assigning `win.theme = ...` or pass an initial theme in `WindowOptions{ theme: ... }`.

## Built-in Theme Presets

```rust
win.theme = gui.Theme.dark()
win.theme = gui.Theme.light()
win.theme = gui.Theme.nord()
win.theme = gui.Theme.dracula()
win.theme = gui.Theme.catppuccin()
win.theme = gui.Theme.high_contrast()
```

### Following the OS Theme

Query the system color scheme at startup and subscribe to live OS appearance changes:

```rust
let initial = gui.system_theme() == .light ? gui.Theme.light() : gui.Theme.dark()
gui.run(app, .{
    theme: initial,
    on_system_theme_change: fn(mode) {
        // React when the user toggles OS light/dark mode
    }
}) ! {}
```

## Semantic Tokens

Every `Theme` exposes semantic color and metric tokens:

| Token | Purpose |
| --- | --- |
| `background` | Window canvas background |
| `surface` | Cards, inputs, sidebars |
| `elevated` | Menus, popovers, hover backgrounds |
| `border` | Hairline borders and dividers |
| `text` / `muted` | Primary and secondary foreground text |
| `accent` / `accent_hover` / `accent_text` | Primary actions, active indicators, focus borders |
| `ring` | Keyboard focus ring color |
| `success` / `warning` / `info` / `danger` | Status badges, toasts, destructive actions |
| `radius` | Base corner radius (logical px) |
| `font_size` | Base font size (logical px) |
| `font_scale` | Global text scale multiplier (`with_scale`) |
| `density` | Control height multiplier (`with_density`) |

### Scaling & Density

```rust
// Larger text + compact spacing
win.theme = gui.Theme.catppuccin().with_scale(1.15).with_density(0.9)
```

## State Styles, Disabled & Transitions

Use `.hover`, `.active`, `.focus`, `.focus_visible`, `.disabled`, and `.transition(seconds)` for responsive, accessible controls:

```rust
gui.div().px(12).h(32).rounded(win.theme.radius)
    .bg(win.theme.surface).border(1).border_color(win.theme.border)
    .transition(0.15)
    .hover(fn(s) { s.bg(win.theme.elevated) })
    .focus_visible(fn(s) { s.border_color(win.theme.ring) })
    .disabled(is_busy)
    .child("Save")
```

- `.focus_visible(...)` only activates when focus arrives via keyboard navigation (`Tab` / `Shift+Tab`), avoiding focus outlines on mouse clicks.
- `.disabled(true)` dims the subtree, sets the `not_allowed` cursor, and blocks clicks, focus, and keyboard events.

## Custom Themes

Construct a `gui.Theme` directly or start from a preset and override fields:

```rust
let brand = gui.Theme.dark()
brand.accent = gui.rgb(0x10b981)
brand.accent_hover = gui.rgb(0x34d399)
brand.radius = 10
```
