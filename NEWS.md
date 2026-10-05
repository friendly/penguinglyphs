# penguinglyphs 0.4.0

## Glyphs in other plots

* `draw_penguin()` now sizes the glyph in inches (new argument `size`, replacing `base_size`) rather than
  in the units of the axes. A glyph has the same shape and size in any plot, whatever the aspect ratio
  or the ranges of the axes, so `asp = 1` is no longer needed.
* New `penguin_points()` adds glyphs for the rows of a data frame to an existing plot, in the manner of `points()`.
* New `penguin_legend()` adds a species legend, and `penguin_colors()` gives the default species colors.
  Colors can be changed with the new `col` argument of the plotting functions.

## Bug fixes

* The legend in `penguin_glyphs()` now matches colors to species by name. Previously, colors were assigned
  in the order the species appeared in the data, so the legend could disagree with the glyphs.
* Measurements are now scaled relative to their ranges in the full `datasets::penguins` data, rather than
  in the rows being plotted, so a given penguin looks the same in any subset. The new `ref` argument
  of `penguin_glyphs()` and `penguin_points()` controls this; `ref = data` gives the old behavior.
* Missing values are now visible: a missing measurement is drawn as an unfilled, dashed outline of that part
  of the glyph, and a penguin of unknown sex has pupils but no eye outlines (it was drawn as a male).
* `penguin_glyphs()` restores the graphics parameters it changes.
* `normalize_var()` gains a `from` argument giving the range to scale from, and returns `NA` rather than 1 
  for a variable that is entirely missing.

## Data

* New dataset `crime`, the rates of serious crimes in the US states that Nathan Yau used to illustrate
  Chernoff faces. The "How to Draw a Penguin" vignette now uses it, rather than downloading the file.

## Glyph design

* Body area, rather than body width and height, is now proportional to body mass, so the body no longer dominates.
* The head is the same size in all glyphs, as a frame of reference for the bill and eyes.
* The bill starts at the side of the head, clear of the eyes.
* Flippers are angled downward, so those of neighboring glyphs no longer collide.
* Pupils are drawn as part of the glyph and scale with it.

# penguinglyphs 0.1.0

* Initial release
* Added `draw_penguin()` function for drawing individual penguin glyphs
* Added `penguin_glyphs()` function for creating grid displays
* Added `normalize_var()` helper function for scaling variables
* Visual mappings: bill length/depth, flipper length, body mass, species (color), sex (eye shape)
* Support for custom legend placement
* ID labels for individual penguins
* Complete documentation and vignette
