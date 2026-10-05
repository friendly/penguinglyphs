# Glyph tweaks

Design changes to the penguin glyph that need some thought before they are made, because they change how
the data are represented, not just how the code works.

## 1. Make sex easier to see

### The problem

Sex is shown by the shape of the eyes: square for males, round for females. This is the weakest encoding in the glyph.
It is readable when a glyph is drawn large (the anatomy figure in the *How to Draw a Penguin* vignette), but not at the
sizes used in real displays.

The numbers explain why. In `draw_penguin()` (`R/draw_penguin.R`), in glyph units, where the whole glyph is 1.4 units high:

| Part | Size |
|---|---|
| Head radius | 0.20 |
| Eye half-width (`eye_size`) | 0.05 |
| Eye centers | ±0.07 from the middle of the head |
| Male eye | rectangle, 0.10 wide × 0.085 high |
| Female eye | circle, radius 0.05 |
| Pupil | radius 0.015 |

So an eye is about 7% of the height of the glyph. At the default `size = 0.4` in. of `penguin_points()`, an eye is
about 0.03 in. across: roughly 3 pixels on screen. A 3-pixel square and a 3-pixel circle cannot be told apart.
Even in the grid display of `penguin_glyphs()`, with glyphs about 1 in. high, an eye is only about 7 pixels.

Two things are wrong, and they are separate:

* **Size**: the eyes are too small.
* **Contrast**: a square and a circle of the same size are among the *least* distinguishable pairs of shapes.
  Both are compact, convex, white-filled, with the same black pupil in the middle.

### Constraints

* The head is a fixed size, so that it serves as a frame of reference for the bill. Two eyes side by side have to
  fit in it, clear of the bill, which starts at 0.75 of the head radius. That limits `eye_size` to about 0.06 with the present head.
* Making the head larger makes room, but the head then takes attention from the body and the bill, and the proportions
  that were just fixed (body area ∝ mass; nothing but mass changes the overall size) need checking again.
* Unknown sex is drawn as pupils with no eye outline. Any new design needs a third, visibly "unknown" state.
* Species uses the body color, so sex cannot use body color. The bill is light blue for all penguins and the feet are black:
  these are unused channels.

### Options

1. **Just make the eyes bigger.** Head radius 0.20 → about 0.24, `eye_size` 0.05 → about 0.075. The least change, but it only addresses
   size, not contrast. On its own, probably not enough at scatterplot sizes.

2. **Fill, rather than shape.** Open eyes for one sex, filled (dark) eyes for the other, like `pch = 1` vs. `pch = 16`.
   Fill is the most robust distinction at small sizes; it survives when the shape is only a few pixels. Could be combined with
   the present shapes, so shape and fill are redundant.

3. **More distinct shapes.** Keep two outlined eyes, but choose shapes that differ in orientation or extent rather than
   in corners: a circle vs. a horizontal slit or a wide ellipse; a circle vs. a triangle or diamond. Better than square vs. circle,
   but still limited by size.

4. **One eye, in profile.** The bill already points sideways, so the head is really drawn in profile, with two eyes that
   belong to a front view. A profile head with a single eye is more consistent, and one eye can be nearly twice as large
   (radius about 0.09–0.10) in the same head. This is the largest visual change.

5. **A second cue, outside the eyes.** Show sex redundantly by something larger: the color of the bill or the feet,
   a crest or eyebrow on the head, or the shape of the belly patch. The eyes can then stay as they are, as a secondary cue.
   The risk is that a new color competes with species.

### Recommendation

Options 2 and 4 together: a profile head with **one large eye, open for females and filled for males**, keeping round vs. angular
as a redundant difference in shape. Unknown sex is then an eye drawn as a dashed outline, which matches the way missing
measurements are already shown, and is more visible than the present pupils-only eyes.

If that is too large a change to the look of the glyph, the fallback is options 1 and 2: keep two eyes, enlarge them as far as the head
allows, and add the fill contrast.

### How to decide

* Draw the candidates with the sex × species figure from `vignettes/draw.Rmd`, but at `size = 0.4`, the size that matters.
* Then test them: a line-up of, say, 19 males and 1 female (and the reverse), at grid size and at scatterplot size.
  Can the odd one be found, and how quickly?
* This is a natural use for a `style =` argument to `draw_penguin()`: the candidates can be alternative styles, compared side by side,
  with the present glyph kept as the default until one is chosen. The drawing code is already separated from the coordinate
  handling (`glyph_pen()` in `R/utils.R`), so a new style only needs new geometry.

### What a change touches

* `R/draw_penguin.R`: the eye geometry, and the roxygen description of the encoding.
* Sex has no legend. If it becomes easier to see, `penguin_legend()` (or a companion) should explain it.
* `vignettes/draw.Rmd`: the anatomy figure (its label positions are in glyph units), the species × sex figure,
  and the text that says the eyes are "probably the first thing to improve".
* `vignettes/introduction.Rmd`: "Visual Encoding" and "Interpreting the Glyphs".
* `README.Rmd` (visual mappings, and all figures), `NEWS.md`, the hex logo if the head changes, and the pkgdown site in `docs/`.

## Other candidates

Noted while testing the glyph; none is worked out yet.

* **Flipper length is the weakest of the four measurements.** Over the range of scale factors, 0.7 to 1.3, the change in the flippers is modest.
  Their length could be given a wider range than the other features, or the flippers made narrower so that length dominates their shape.
* **Body mass is still the most conspicuous feature**, even shown by area. It also moves the head and the feet. Whether that matters
  depends on what the display is for.
* **Bill length and depth are read together**, as the shape of the bill. That may be a feature rather than a problem, but it means
  the two are not judged independently.
* **The cartoon versions** in `notes/penguin-cartoon*.R`, with a smaller head and larger bill and flippers, are an alternative
  overall design, and another candidate for `style =`.
