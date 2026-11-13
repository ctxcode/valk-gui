
# Documentation

Namespaces: [main](#main)

---

# main

## Enums for 'main'

```js
// How children are placed on the cross axis (`items_*`, `self_*`).
+ enum Align { start, center, end, stretch }
// The mouse cursor shown over an element.
+ enum Cursor { default, pointer, text, crosshair, not_allowed, resize_ew, resize_ns, move }
// The axis children are placed along.
+ enum Direction { row, column }
+ enum FontWeight { normal, medium, semibold, bold }
// How free space on the main axis is shared (`justify_*`).
+ enum Justify { start, center, end, between, around, evenly }
// A key on the keyboard, independent of the layout's characters. Typed text arrives through `on_input` instead.
+ enum Key { unknown, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, digit0, digit1, digit2, digit3, digit4, digit5, digit6, digit7, digit8, digit9, space, enter, escape, backspace, tab, delete, insert, left, right, up, down, home, end, page_up, page_down, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, minus, equal, comma, period, slash, semicolon, apostrophe, left_bracket, right_bracket, backslash, grave }
+ enum LengthKind { auto, px, fraction }
+ enum MouseButton { left, right, middle }
+ enum Overflow { visible, hidden, scroll }
+ enum Position { relative, absolute }
+ enum PrimitiveKind { quad, shadow, text, image, line, circle, ring, triangle, clip, unclip }
+ enum TextAlign { left, center, right }
```

## Functions for 'main'

```js
+ fn black() Color
// A button with a label. Add `on_click`.
+ fn button(win: Window, label: String) Div
// A button in the accent color, for the main action.
+ fn button_primary(win: Window, label: String) Div
// An element that paints itself with `paint`, which gets the element's bounds. Give it a size.
+ fn canvas(paint: fn(Painter, Bounds)()) Div
// A checkbox with a label. Toggle your state in `on_click`.
+ fn checkbox(win: Window, checked: bool, label: String) Div
// A new empty element.
+ fn div() Div
// A thin line between sections.
+ fn divider(win: Window) Div
// A window without a screen, for tests: `draw` fills `scene`, and `click`, `press`, `type_text` and the others simulate input. Text is measured as if every character were half the font size wide.
+ fn headless(root: Render, width: f32 (800), height: f32 (600), theme: Theme (Theme.dark())) Window
// A color from hue (0 to 360), saturation, lightness and alpha (0 to 1).
+ fn hsla(h: f32, s: f32, l: f32, a: f32) Color
// An image from a file (PNG, JPG, BMP, QOI). It is as large as the image unless sized.
+ fn img(path: String) Div
// A bar filled to `value` (0 to 1).
+ fn progress(win: Window, value: f32) Div
// A color from a hex number such as `0x3b82f6`, fully opaque.
+ fn rgb(hex: u32) Color
// A color from a hex number with alpha in the lowest byte, such as `0x3b82f680`.
+ fn rgba(hex: u32) Color
// Opens a window, shows `root` in it and handles input until the window closes.
+ fn run(root: Render, options: WindowOptions (WindowOptions{})) void
// A horizontal slider for a value from 0 to 1. `on_change` gets the new value while the track is pressed or dragged.
+ fn slider(win: Window, value: f32, on_change: fn(f32)()) Div
// An on/off switch. Toggle your state in `on_click`.
+ fn switch(win: Window, on: bool) Div
// A text element. It takes its color, size and weight from its parents unless set on it.
+ fn text(content: String) Div
+ fn transparent() Color
// A scrolling list of `count` rows of equal height that only builds the rows in view, so it stays fast with any number of rows. `row` builds the row at an index. `id` names the list; it must be unique in the window.
+ fn uniform_list(win: Window, id: String, count: uint, row_height: f32, row: fn(uint)(Div)) Div
+ fn white() Color
```

## Classes for 'main'

```js
// A rectangle in logical pixels, from its top-left corner.
+ struct Bounds {
    + h: f32
    + w: f32
    + x: f32
    + y: f32

    + get bottom: f32
    + get center: Point
    // Whether the point lies inside, counting the top and left edges but not the right and bottom.
    + fn contains(x: f32, y: f32) bool
    // The rectangle grown by `amount` on every side.
    + fn grow(amount: f32) Bounds
    // The rectangle moved inwards by `edges`.
    + fn inset(edges: Edges) Bounds
    // The overlap of two rectangles; zero-sized when they do not overlap.
    + fn intersect(other: Bounds) Bounds
    + get right: f32
}
```

```js
// An RGBA color, 8 bits per channel.
+ struct Color {
    + a: u8
    + b: u8
    + g: u8
    + r: u8

    // The color mixed with black by `amount` (0 to 1).
    + fn darken(amount: f32) Color
    // The color with its alpha multiplied by `factor` (0 to 1).
    + fn fade(factor: f32) Color
    + fn is_transparent() bool
    // The color mixed with white by `amount` (0 to 1).
    + fn lighten(amount: f32) Color
    // The color `t` of the way to `other` (0 gives this color, 1 gives `other`).
    + fn mix(other: Color, t: f32) Color
    // The same color with its alpha set to `alpha` (0 to 1).
    + fn opacity(alpha: f32) Color
}
```

```js
// The element everything is built from: a box with a style, children, and event handlers. `text`, `canvas` and `img` make the other kinds.
+ class Div {
    ~+ bounds: Bounds
    ~+ child_nodes: Array[Div]
    ~+ content: String
    ~+ content_h: f32
    ~+ content_w: f32
    ~+ key: u64
    ~+ kind: NodeKind
    ~+ name: ?String
    ~+ parent: ?Div
    ~+ scroll_x: f32
    ~+ scroll_y: f32
    + style: Style

    // Takes the element out of the flow, placed with `top`, `right`, `bottom` and `left` inside its parent. It is painted above its in-flow siblings.
    + fn absolute() Div
    // Style changes while the mouse button is held on the element.
    + fn active(refine: fn(Style)()) Div
    + fn bg(color: Color) Div
    // The border width on every side; `border_color` sets the color.
    + fn border(width: f32) Div
    + fn border_b(width: f32) Div
    + fn border_color(color: Color) Div
    + fn border_l(width: f32) Div
    + fn border_r(width: f32) Div
    + fn border_t(width: f32) Div
    + fn bottom(value: f32) Div
    // Centers children on both axes.
    + fn center() Div
    // Adds a child element, or a text when given a `String`.
    + fn child(item: String | Div) Div
    + fn children(items: Array[Div]) Div
    + fn cursor(cursor: Cursor) Div
    + fn cursor_pointer() Div
    + fn cursor_text() Div
    // Paints the element after everything else and without the clipping of its parents, and lets it take the mouse first: for menus, popovers and dialogs. Its layout is unchanged; combine it with `absolute`.
    + fn deferred() Div
    // Places children in a row.
    + fn flex() Div
    // Grows and shrinks from a zero base size, sharing space with its siblings.
    + fn flex_1() Div
    + fn flex_basis(value: f32) Div
    // Places children in a column, the default.
    + fn flex_col() Div
    // Grows into free space, from its content size.
    + fn flex_grow() Div
    // Neither grows nor shrinks.
    + fn flex_none() Div
    + fn flex_row() Div
    + fn flex_shrink_0() Div
    // Style changes while the element's focus handle has focus.
    + fn focus(refine: fn(Style)()) Div
    // A font family added with `Window.add_font` or `WindowOptions.fonts`.
    + fn font(name: String) Div
    + fn font_bold() Div
    + fn font_medium() Div
    + fn font_semibold() Div
    + fn font_weight(weight: FontWeight) Div
    // Space between children on both axes.
    + fn gap(value: f32) Div
    + fn gap_x(value: f32) Div
    + fn gap_y(value: f32) Div
    + fn h(value: f32) Div
    + fn h_auto() Div
    + fn h_frac(value: f32) Div
    + fn h_full() Div
    // Removes the element from layout and painting.
    + fn hidden() Div
    // Style changes while the mouse is over the element.
    + fn hover(refine: fn(Style)()) Div
    // Names the element. An id keeps the element's scroll position and pressed state while the tree around it changes, and lets tests find it with `Window.bounds_of`.
    + fn id(name: String) Div
    + fn inset(value: f32) Div
    // Keeps the element's space but does not paint it.
    + fn invisible() Div
    + fn is_focusable() bool
    + fn items_center() Div
    + fn items_end() Div
    + fn items_start() Div
    + fn items_stretch() Div
    + fn justify_around() Div
    + fn justify_between() Div
    + fn justify_center() Div
    + fn justify_end() Div
    + fn justify_evenly() Div
    + fn justify_start() Div
    + fn left(value: f32) Div
    // The line height as a multiple of the text size.
    + fn line_height(factor: f32) Div
    + fn m(value: f32) Div
    + fn max_h(value: f32) Div
    + fn max_w(value: f32) Div
    + fn mb(value: f32) Div
    + fn min_h(value: f32) Div
    + fn min_w(value: f32) Div
    + fn ml(value: f32) Div
    + fn mr(value: f32) Div
    + fn mt(value: f32) Div
    + fn mx(value: f32) Div
    + fn my(value: f32) Div
    // Runs when the left button is pressed and released on the element. Only the innermost element with a click handler runs.
    + fn on_click(handler: fn(MouseEvent)()) Div
    // Runs on every mouse move while the button that was pressed on the element is held, also when the mouse is outside it.
    + fn on_drag(handler: fn(MouseEvent)()) Div
    // Runs with typed text while the element, or one of its children, has focus.
    + fn on_input(handler: fn(String)()) Div
    // Runs for key presses while the element, or one of its children, has focus. The root element also receives them when nothing has focus.
    + fn on_key_down(handler: fn(KeyEvent)()) Div
    + fn on_mouse_down(handler: fn(MouseEvent)()) Div
    + fn on_mouse_move(handler: fn(MouseEvent)()) Div
    + fn on_mouse_up(handler: fn(MouseEvent)()) Div
    + fn on_scroll(handler: fn(ScrollEvent)()) Div
    // Paints the element and its children with this opacity (0 to 1).
    + fn opacity(value: f32) Div
    // Clips children to the padding box.
    + fn overflow_hidden() Div
    + fn overflow_scroll() Div
    + fn overflow_x_scroll() Div
    // Scrolls vertically when the children are taller. Give the element an `id` to keep its scroll position when the tree changes shape.
    + fn overflow_y_scroll() Div
    + fn p(value: f32) Div
    + fn pb(value: f32) Div
    + fn pl(value: f32) Div
    + fn pr(value: f32) Div
    + fn pt(value: f32) Div
    + fn px(value: f32) Div
    + fn py(value: f32) Div
    + fn relative() Div
    + fn right(value: f32) Div
    // The corner radius.
    + fn rounded(radius: f32) Div
    // Corners as round as the element allows: a pill, or a circle for a square.
    + fn rounded_full() Div
    + fn self_center() Div
    + fn self_end() Div
    + fn self_start() Div
    + fn self_stretch() Div
    + fn shadow(shadow: Shadow) Div
    + fn shadow_lg() Div
    + fn shadow_md() Div
    + fn shadow_none() Div
    + fn shadow_sm() Div
    + fn size(value: f32) Div
    + fn size_full() Div
    // The text of a text element.
    + get text: String
    + fn text_2xl() Div
    + fn text_3xl() Div
    + fn text_base() Div
    + fn text_center() Div
    + fn text_color(color: Color) Div
    + fn text_left() Div
    + fn text_lg() Div
    + fn text_right() Div
    + fn text_size(size: f32) Div
    + fn text_sm() Div
    + fn text_xl() Div
    + fn text_xs() Div
    + fn top(value: f32) Div
    // Makes the element focusable: clicking it focuses `handle`, Tab moves to it, and its key handlers receive key presses while it is focused.
    + fn track_focus(handle: FocusHandle) Div
    // Keeps text on one line and ends it with "…" when it does not fit.
    + fn truncate() Div
    + fn w(value: f32) Div
    + fn w_auto() Div
    // Width as a fraction of the parent's, such as 0.5 for half.
    + fn w_frac(value: f32) Div
    + fn w_full() Div
    // Calls `build` with the element when `condition` holds, for styles that depend on state.
    + fn when(condition: bool, build: fn(Div)()) Div
    // Keeps text on one line.
    + fn whitespace_nowrap() Div
}
```

```js
// Values for the four sides of a box, used for padding, margins and border widths.
+ struct Edges {
    + bottom: f32
    + left: f32
    + right: f32
    + top: f32

    + fn add(other: Edges) Edges
    + static fn all(value: f32) Edges
    + get horizontal: f32
    + fn is_uniform() bool
    + fn is_zero() bool
    + get vertical: f32
}
```

```js
// Keeps track of whether an element has keyboard focus. Make one per focusable element and keep it with the element's state; give it to the element with `track_focus`.
+ class FocusHandle {
    + fn blur() void
    + fn focus() void
    + fn is_focused() bool
}
```

```js
// A font file for a family used with `Styled.font`.
+ struct FontFile {
    + name: String
    + path: String
    + weight: FontWeight
}
```

```js
// Text metrics without a window: every character is half the font size wide.
+ class HeadlessPlatform is Platform {
    + images: Map[Point]

    + fn clipboard() String
    + fn image_size(path: String) Point
    + fn set_clipboard(text: String) void
    + fn text_width(text: String, font: ResolvedFont) f32
}
```

```js
// A key press, or a repeat while the key is held.
+ class KeyEvent {
    + key: Key
    + modifiers: Modifiers
    + repeat: bool
    ~+ stopped: bool

    // Stops the event from reaching parent elements and the window's own handling, such as Tab moving the focus.
    + fn stop_propagation() void
}
```

```js
// A size: automatic, in pixels, or a fraction of the parent's size.
+ struct Length {
    + kind: LengthKind
    + value: f32

    + static fn auto() Length
    + static fn fraction(value: f32) Length
    + static fn px(value: f32) Length
    // The size in pixels, or -1 when it is automatic or the parent's size is unknown.
    + fn resolve(parent: f32) f32
}
```

```js
// The modifier keys held during an event.
+ struct Modifiers {
    + alt: bool
    // The Command key on macOS, the Windows or Super key elsewhere.
    + cmd: bool
    + ctrl: bool
    + shift: bool

    // Command on macOS, Control elsewhere: the modifier of shortcuts like copy and paste.
    + get secondary: bool
}
```

```js
// A mouse press, release, move or click. Coordinates are relative to the window.
+ class MouseEvent {
    // The bounds of the element whose handler runs.
    + bounds: Bounds
    + button: MouseButton
    // 2 for a double click, 3 for a triple click.
    + click_count: uint
    + modifiers: Modifiers
    ~+ stopped: bool
    + x: f32
    + y: f32

    // The position relative to the element's top-left corner.
    + get local_x: f32
    + get local_y: f32
    // Stops the event from reaching the handlers of parent elements.
    + fn stop_propagation() void
}
```

```js
// Draws into the scene from a `canvas` element. Coordinates are window coordinates; the canvas's bounds are given next to the painter.
+ class Painter {
    + fn circle(x: f32, y: f32, radius: f32, color: Color) void
    // Limits drawing to `bounds` until `unclip`.
    + fn clip(bounds: Bounds) void
    + fn fill(bounds: Bounds, color: Color, radius: f32 (0)) void
    + fn line(x1: f32, y1: f32, x2: f32, y2: f32, color: Color, width: f32 (1)) void
    + fn ring(x: f32, y: f32, radius: f32, color: Color, width: f32 (1)) void
    + fn stroke(bounds: Bounds, color: Color, width: f32 (1), radius: f32 (0)) void
    // One line of text in a line box 1.4 times the size high, with its top-left corner at `x`, `y`.
    + fn text(x: f32, y: f32, content: String, color: Color, size: f32 (16), weight: FontWeight (.normal), font: String ("")) void
    + fn text_width(content: String, size: f32 (16), weight: FontWeight (.normal), font: String ("")) f32
    // A filled triangle; the corners may be in either order.
    + fn triangle(a: Point, b: Point, c: Point, color: Color) void
    + fn unclip() void
}
```

```js
// What the window needs from the system it runs on: text metrics, images and the clipboard. `run` uses raylib; `headless` uses fixed-width metrics for tests.
+ interface Platform {
}
```

```js
// A point in logical pixels.
+ struct Point {
    + x: f32
    + y: f32
}
```

```js
// One drawing command. Which fields matter depends on `kind`.
+ struct Primitive {
    + border: Edges
    + border_color: Color
    + bounds: Bounds
    + color: Color
    + font: ResolvedFont
    + kind: PrimitiveKind
    // Line end points, triangle corners.
    + points: [Point x 3]
    + radius: f32
    + text: String
    // The blur of a shadow, the width of a line or ring.
    + width: f32
}
```

```js
// Something that draws itself as an element tree. The root of a window is one, and so is every component with state of its own.
+ interface Render {
}
```

```js
// The font a text is drawn with, after inheritance.
+ struct ResolvedFont {
    // The height of one line in pixels.
    + line_height: f32
    // The family name, "" for the built-in Inter.
    + name: String
    + size: f32
    + weight: FontWeight
}
```

```js
// What a frame draws, in order. The window rebuilds it every frame.
+ class Scene {
    + items: Array[Primitive]

    + fn clear() void
    // The first text that contains `part`.
    + fn find_text(part: String) ?Primitive
    // Whether a drawn text contains `part`.
    + fn has_text(part: String) bool
    // Every text drawn, in order.
    + fn texts() Array[String]
}
```

```js
// A scroll wheel or touchpad scroll, in pixels.
+ class ScrollEvent {
    + bounds: Bounds
    + dx: f32
    + dy: f32
    + modifiers: Modifiers
    ~+ stopped: bool
    + x: f32
    + y: f32

    + fn stop_propagation() void
}
```

```js
// A drop shadow behind an element.
+ struct Shadow {
    + blur: f32
    + color: Color
    + spread: f32
    + x: f32
    + y: f32
}
```

```js
// Everything that decides how an element is laid out and painted. Elements, and the closures given to `hover`, `active` and `focus`, change it through the `Styled` methods. Text properties left `null` are inherited from the parent.
+ class Style {
    + align_items: Align
    + align_self: ?Align
    + alpha: f32
    + background: ?Color
    + basis: Length
    + border_tint: Color
    + border_widths: Edges
    + box_shadow: ?Shadow
    + color: ?Color
    + column_gap: f32
    + cursor_style: ?Cursor
    + direction: Direction
    + display_none: bool
    + ellipsis: ?bool
    + font_name: ?String
    + font_size: ?f32
    + grow: f32
    + height: Length
    + inset_bottom: ?f32
    + inset_left: ?f32
    + inset_right: ?f32
    + inset_top: ?f32
    + justify: Justify
    + leading: ?f32
    + margin: Edges
    + max_height: ?f32
    + max_width: ?f32
    + min_height: ?f32
    + min_width: ?f32
    + nowrap: ?bool
    + on_top: bool
    + overflow_x: Overflow
    + overflow_y: Overflow
    + padding: Edges
    + position: Position
    + radius: f32
    + row_gap: f32
    + shrink: f32
    + text_align: ?TextAlign
    + visible: bool
    + weight: ?FontWeight
    + width: Length

    // Takes the element out of the flow, placed with `top`, `right`, `bottom` and `left` inside its parent. It is painted above its in-flow siblings.
    + fn absolute() Style
    + fn bg(color: Color) Style
    // The border width on every side; `border_color` sets the color.
    + fn border(width: f32) Style
    + fn border_b(width: f32) Style
    + fn border_color(color: Color) Style
    + fn border_l(width: f32) Style
    + fn border_r(width: f32) Style
    + fn border_t(width: f32) Style
    + fn bottom(value: f32) Style
    // Centers children on both axes.
    + fn center() Style
    + fn cursor(cursor: Cursor) Style
    + fn cursor_pointer() Style
    + fn cursor_text() Style
    // Paints the element after everything else and without the clipping of its parents, and lets it take the mouse first: for menus, popovers and dialogs. Its layout is unchanged; combine it with `absolute`.
    + fn deferred() Style
    // Places children in a row.
    + fn flex() Style
    // Grows and shrinks from a zero base size, sharing space with its siblings.
    + fn flex_1() Style
    + fn flex_basis(value: f32) Style
    // Places children in a column, the default.
    + fn flex_col() Style
    // Grows into free space, from its content size.
    + fn flex_grow() Style
    // Neither grows nor shrinks.
    + fn flex_none() Style
    + fn flex_row() Style
    + fn flex_shrink_0() Style
    // A font family added with `Window.add_font` or `WindowOptions.fonts`.
    + fn font(name: String) Style
    + fn font_bold() Style
    + fn font_medium() Style
    + fn font_semibold() Style
    + fn font_weight(weight: FontWeight) Style
    // Space between children on both axes.
    + fn gap(value: f32) Style
    + fn gap_x(value: f32) Style
    + fn gap_y(value: f32) Style
    + fn h(value: f32) Style
    + fn h_auto() Style
    + fn h_frac(value: f32) Style
    + fn h_full() Style
    // Removes the element from layout and painting.
    + fn hidden() Style
    + fn inset(value: f32) Style
    // Keeps the element's space but does not paint it.
    + fn invisible() Style
    + fn items_center() Style
    + fn items_end() Style
    + fn items_start() Style
    + fn items_stretch() Style
    + fn justify_around() Style
    + fn justify_between() Style
    + fn justify_center() Style
    + fn justify_end() Style
    + fn justify_evenly() Style
    + fn justify_start() Style
    + fn left(value: f32) Style
    // The line height as a multiple of the text size.
    + fn line_height(factor: f32) Style
    + fn m(value: f32) Style
    + fn max_h(value: f32) Style
    + fn max_w(value: f32) Style
    + fn mb(value: f32) Style
    + fn min_h(value: f32) Style
    + fn min_w(value: f32) Style
    + fn ml(value: f32) Style
    + fn mr(value: f32) Style
    + fn mt(value: f32) Style
    + fn mx(value: f32) Style
    + fn my(value: f32) Style
    // Paints the element and its children with this opacity (0 to 1).
    + fn opacity(value: f32) Style
    // Clips children to the padding box.
    + fn overflow_hidden() Style
    + fn overflow_scroll() Style
    + fn overflow_x_scroll() Style
    // Scrolls vertically when the children are taller. Give the element an `id` to keep its scroll position when the tree changes shape.
    + fn overflow_y_scroll() Style
    + fn p(value: f32) Style
    + fn pb(value: f32) Style
    + fn pl(value: f32) Style
    + fn pr(value: f32) Style
    + fn pt(value: f32) Style
    + fn px(value: f32) Style
    + fn py(value: f32) Style
    + fn relative() Style
    + fn right(value: f32) Style
    // The corner radius.
    + fn rounded(radius: f32) Style
    // Corners as round as the element allows: a pill, or a circle for a square.
    + fn rounded_full() Style
    + fn self_center() Style
    + fn self_end() Style
    + fn self_start() Style
    + fn self_stretch() Style
    + fn shadow(shadow: Shadow) Style
    + fn shadow_lg() Style
    + fn shadow_md() Style
    + fn shadow_none() Style
    + fn shadow_sm() Style
    + fn size(value: f32) Style
    + fn size_full() Style
    + get style: Style
    + fn text_2xl() Style
    + fn text_3xl() Style
    + fn text_base() Style
    + fn text_center() Style
    + fn text_color(color: Color) Style
    + fn text_left() Style
    + fn text_lg() Style
    + fn text_right() Style
    + fn text_size(size: f32) Style
    + fn text_sm() Style
    + fn text_xl() Style
    + fn text_xs() Style
    + fn top(value: f32) Style
    // Keeps text on one line and ends it with "…" when it does not fit.
    + fn truncate() Style
    + fn w(value: f32) Style
    + fn w_auto() Style
    // Width as a fraction of the parent's, such as 0.5 for half.
    + fn w_frac(value: f32) Style
    + fn w_full() Style
    // Keeps text on one line.
    + fn whitespace_nowrap() Style
}
```

```js
// A single-line text field. Keep it with your state and put `input.render(win)` in the tree. It supports selection with the mouse and Shift, word jumps, and copy, cut and paste.
+ class TextInput is Render {
    // The other end of the selection; equal to `cursor` when nothing is selected.
    ~+ anchor: uint
    // The caret position as a byte offset.
    ~+ cursor: uint
    // The text size; the theme's when unset.
    + font_size: ?f32
    // Called after every edit with the new text.
    + on_change: ?fn(String)()
    // Called when Enter is pressed.
    + on_submit: ?fn(String)()
    // Shows dots instead of the text.
    + password: bool
    + placeholder: String
    + text: String

    // The focus handle of the field, for focusing it from code.
    + fn focus_handle(win: Window) FocusHandle
    // Replaces the selection with `t`.
    + fn insert(t: String) void
    + static fn new(placeholder: String ("")) TextInput
    + fn render(win: Window) Div
    + fn select_all() void
    + fn selected_text() String
    + fn set_text(text: String) void
}
```

```js
// The colors and sizes the window and the built-in components use. `win.theme` gives the current one; your own elements can use it too.
+ class Theme {
    // Buttons, selections and focus rings.
    + accent: Color
    // Text on the accent color.
    + accent_text: Color
    // The window background.
    + background: Color
    + border: Color
    + danger: Color
    // Hovered or raised surfaces.
    + elevated: Color
    + font_size: f32
    // Secondary text.
    + muted: Color
    + radius: f32
    // Panels and cards on the background.
    + surface: Color
    + text: Color

    + static fn dark() Theme
    + static fn light() Theme
}
```

```js
// A window and everything that lives across frames: focus, hover, scroll positions and the last frame's elements. The root's `render` gets it every frame.
+ class Window {
    ~+ cursor: Cursor
    // Whether the last frame changed hover state, so another frame should follow.
    ~+ dirty: bool
    ~+ focused: ?FocusHandle
    ~+ fonts: Array[FontFile]
    ~+ frame_requested: bool
    ~+ frames: uint
    + height: f32
    ~+ mouse_x: f32
    ~+ mouse_y: f32
    + platform: Platform
    ~+ quit_requested: bool
    // What the last frame drew.
    + scene: Scene
    + theme: Theme
    // Seconds since the window opened.
    ~+ time: f64
    ~+ title: String
    ~+ title_changed: bool
    + width: f32

    // Adds a font family for `Styled.font`. Add one file per weight that is used; others fall back to the closest added weight.
    + fn add_font(name: String, path: String, weight: FontWeight (.normal)) void
    // The bounds of the element with this `id` in the last frame.
    + fn bounds_of(id: String) ?Bounds
    // Presses and releases the left button at a point, then draws a frame.
    + fn click(x: f32, y: f32, modifiers: Modifiers (.{})) void
    // Clicks the center of the element with this `id`; false when there is none.
    + fn click_on(id: String) bool
    + fn clipboard() String
    // Drags with the left button from one point to another, then draws a frame.
    + fn drag(x1: f32, y1: f32, x2: f32, y2: f32) void
    // Renders the root, lays it out and paints it into `scene`.
    + fn draw() void
    // The element with this `id` in the last frame.
    + fn find(id: String) ?Div
    // A new handle for an element that takes keyboard focus.
    + fn focus_handle() FocusHandle
    // Moves the focus to the next (or previous) focusable element in tree order.
    + fn focus_next(forward: bool (true)) void
    // The topmost element at a point in the last frame.
    + fn hit_test(x: f32, y: f32) ?Div
    // Typed text, delivered to the innermost focused element with an `on_input` handler.
    + fn input(text: String) void
    + fn key_down(key: Key, modifiers: Modifiers (.{}), repeat: bool (false)) void
    + fn mouse_down(x: f32, y: f32, button: MouseButton (.left), modifiers: Modifiers (.{})) void
    + fn mouse_move(x: f32, y: f32, modifiers: Modifiers (.{})) void
    + fn mouse_up(x: f32, y: f32, button: MouseButton (.left), modifiers: Modifiers (.{})) void
    + fn move_to(x: f32, y: f32) void
    + static fn new(root: Render, width: f32, height: f32, platform: Platform, theme: Theme (Theme.dark())) Window
    // Presses a key, then draws a frame.
    + fn press(key: Key, modifiers: Modifiers (.{})) void
    // Closes the window after this frame.
    + fn quit() void
    // Draws another frame after this one, for animations. Without it the window sleeps until the next input event.
    + fn request_frame() void
    + fn resize(width: f32, height: f32) void
    // Scrolls by `dx`, `dy` pixels at the mouse position; positive `dy` moves towards the end.
    + fn scroll(dx: f32, dy: f32, modifiers: Modifiers (.{})) void
    // Scrolls at a point, then draws a frame.
    + fn scroll_at(x: f32, y: f32, dx: f32, dy: f32) void
    + fn set_clipboard(text: String) void
    + fn set_title(title: String) void
    // The width of `content` in the given font.
    + fn text_width(content: String, size: f32 (16), weight: FontWeight (.normal), font: String ("")) f32
    // Types text into the focused element, then draws a frame.
    + fn type_text(text: String) void
}
```

```js
// How `run` opens the window.
+ class WindowOptions {
    // Smooths the edges of shapes.
    + antialias: bool
    + fonts: Array[FontFile]
    + height: i32
    // Opens the window hidden.
    + hidden: bool
    + min_height: i32
    + min_width: i32
    + resizable: bool
    // Saves the third frame to this PNG file and closes the window, for tests and images.
    + screenshot: String
    + theme: Theme
    + title: String
    + width: i32
}
```
