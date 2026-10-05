# Changelog

## penguinglyphs 0.4.0

### Glyphs in other plots

- [`draw_penguin()`](https://friendly.github.io/penguinglyphs/reference/draw_penguin.md)
  now sizes the glyph in inches (new argument `size`, replacing
  `base_size`) rather than in the units of the axes. A glyph has the
  same shape and size in any plot, whatever the aspect ratio or the
  ranges of the axes, so `asp = 1` is no longer needed.
- New
  [`penguin_points()`](https://friendly.github.io/penguinglyphs/reference/penguin_points.md)
  adds glyphs for the rows of a data frame to an existing plot, in the
  manner of [`points()`](https://rdrr.io/r/graphics/points.html).
- New
  [`penguin_legend()`](https://friendly.github.io/penguinglyphs/reference/penguin_colors.md)
  adds a species legend, and
  [`penguin_colors()`](https://friendly.github.io/penguinglyphs/reference/penguin_colors.md)
  gives the default species colors. Colors can be changed with the new
  `col` argument of the plotting functions.
- New `cex.lab` argument of
  [`draw_penguin()`](https://friendly.github.io/penguinglyphs/reference/draw_penguin.md),
  [`penguin_points()`](https://friendly.github.io/penguinglyphs/reference/penguin_points.md)
  and
  [`penguin_glyphs()`](https://friendly.github.io/penguinglyphs/reference/penguin_glyphs.md)
  controls the size of the `id` labels.

### Bug fixes

- The legend in
  [`penguin_glyphs()`](https://friendly.github.io/penguinglyphs/reference/penguin_glyphs.md)
  now matches colors to species by name. Previously, colors were
  assigned in the order the species appeared in the data, so the legend
  could disagree with the glyphs.
- Measurements are now scaled relative to their ranges in the full
  [`datasets::penguins`](https://rdrr.io/r/datasets/penguins.html) data,
  rather than in the rows being plotted, so a given penguin looks the
  same in any subset. The new `ref` argument of
  [`penguin_glyphs()`](https://friendly.github.io/penguinglyphs/reference/penguin_glyphs.md)
  and
  [`penguin_points()`](https://friendly.github.io/penguinglyphs/reference/penguin_points.md)
  controls this; `ref = data` gives the old behavior.
- Missing values are now visible: a missing measurement is drawn as an
  unfilled, dashed outline of that part of the glyph, and a penguin of
  unknown sex has pupils but no eye outlines (it was drawn as a male).
- The legend in
  [`penguin_glyphs()`](https://friendly.github.io/penguinglyphs/reference/penguin_glyphs.md)
  no longer overlaps the glyphs. It is placed outside the grid, beside
  or above/below it, using the spare room around the grid where there is
  some.
- [`penguin_glyphs()`](https://friendly.github.io/penguinglyphs/reference/penguin_glyphs.md)
  restores the graphics parameters it changes.
- [`normalize_var()`](https://friendly.github.io/penguinglyphs/reference/normalize_var.md)
  gains a `from` argument giving the range to scale from, and returns
  `NA` rather than 1 for a variable that is entirely missing.

### Data

- New dataset `crime`, the rates of serious crimes in the US states that
  Nathan Yau used to illustrate Chernoff faces. The “How to Draw a
  Penguin” vignette now uses it, rather than downloading the file.

### Glyph design

- Body area, rather than body width and height, is now proportional to
  body mass, so the body no longer dominates.
- The head is the same size in all glyphs, as a frame of reference for
  the bill and eyes.
- The bill starts at the side of the head, clear of the eyes.
- Flippers are angled downward, so those of neighboring glyphs no longer
  collide.
- Pupils are drawn as part of the glyph and scale with it.

## penguinglyphs 0.1.0

- Initial release
- Added
  [`draw_penguin()`](https://friendly.github.io/penguinglyphs/reference/draw_penguin.md)
  function for drawing individual penguin glyphs
- Added
  [`penguin_glyphs()`](https://friendly.github.io/penguinglyphs/reference/penguin_glyphs.md)
  function for creating grid displays
- Added
  [`normalize_var()`](https://friendly.github.io/penguinglyphs/reference/normalize_var.md)
  helper function for scaling variables
- Visual mappings: bill length/depth, flipper length, body mass, species
  (color), sex (eye shape)
- Support for custom legend placement
- ID labels for individual penguins
- Complete documentation and vignette
