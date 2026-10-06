# tinyplot: issues to report

Four things that did not work as expected, found while using `tinyplot` for the plots in `vignettes/introduction.Rmd`.
Each is a separate issue for <https://github.com/grantmcdermott/tinyplot/issues>.

The related feature request, for a `fill.alpha` argument, is in `notes/tinyplot-feature-request.md`.

**Tested with tinyplot 0.7.0 and again with 0.8.0** (the current CRAN release), R 4.6.1, Windows, drawing to a `png()` device.
Everything below gave the same result in both versions.

Setup for all the examples:

```r
library(tinyplot)
data(penguins, package = "datasets")
peng <- na.omit(penguins)
```

## 1. `lty` is ignored by `type_ellipse()` (and `type_polygon()`)

```r
# solid lines, though dashed were asked for
tinyplot(body_mass ~ flipper_len | species, data = peng, type = "ellipse", lty = 2)
tinyplot(body_mass ~ flipper_len | species, data = peng, type = "ellipse", lty = "dashed")
tinyplot(body_mass ~ flipper_len | species, data = peng, type = "ellipse", lty = "by")

# for comparison, lty is respected here
tinyplot(body_mass ~ flipper_len | species, data = peng, type = "l", lty = 2)
```

Expected: dashed outlines (and a different line type for each group, with `lty = "by"`). 
Observed: solid outlines in all three.
`lwd` given the same way is respected. `type_polygon()` with `lty = 2` is also drawn solid.

The drawing function has the argument, `draw_polygon()` calls `polygon(..., lty = ilty, lwd = ilwd)`, so it looks as if
`ilty` is not being filled in for the polygon-based types.

Why it matters: line type is the usual way to distinguish groups in black and white, and to show two ellipses
for the same group (e.g., 68% and 95%, or classical and robust).

## 2. `fill = <alpha>` ignores colors given by `col`

```r
cols <- c("#FF6B35", "#9A78B8", "#73C05B")

# outlines are orange / purple / green, but the fills are grey / pink / light green
tinyplot(body_mass ~ flipper_len | species, data = peng,
         type = type_ellipse(level = 0.68), col = cols, fill = 0.25, lwd = 2)
```

Expected: each ellipse filled with a translucent version of its own outline color. Observed: the outlines use `col`, but the fills
are taken from the default palette (black, red, green), so the outline and fill of an ellipse do not match.

Two ways around it, both of which give matching fills:

```r
# give the colors as the palette
tinyplot(body_mass ~ flipper_len | species, data = peng,
         type = type_ellipse(level = 0.68),
         palette = c("#FF6B35", "#9A78B8", "#73C05B"), fill = 0.25, lwd = 2)

# or give the fill colors explicitly
tinyplot(body_mass ~ flipper_len | species, data = peng,
         type = type_ellipse(level = 0.68),
         col = cols, bg = adjustcolor(cols, 0.25), lwd = 2)
```

This may be intended, in that `palette` is the documented way to set group colors and `col` overrides only the
lines. If so, it deserves a note in the documentation of `fill`.

## 3. `palette = <expression>` fails, depending on the name of the variable or where it is defined

```r
f <- body_mass ~ flipper_len | species
v <- c("#FF6B35", "#9A78B8", "#73C05B")

mypal <- v; pal <- v; x <- v; cols <- v; col <- v

tinyplot(f, data = peng, palette = mypal)   # OK
tinyplot(f, data = peng, palette = pal)     # OK
tinyplot(f, data = peng, palette = x)       # OK

tinyplot(f, data = peng, palette = cols)
#> Error: 'what' must be a function or character string
tinyplot(f, data = peng, palette = col)
#> Error: unused argument (n = 3)
```

Two more cases of the same kind:

```r
# a call that returns a (named) vector of colors
library(penguinglyphs)
tinyplot(f, data = peng, palette = penguin_colors())
#> Error: 'what' must be a function or character string

# a variable that is not in the global environment, e.g., when the code is run by
# rmarkdown::render(..., envir = new.env())
pal <- v
tinyplot(f, data = peng, palette = pal)
#> Error: object 'pal' not found
```

The same vector of colors works or fails depending only on the name of the variable that holds it, or on where it is defined.
The names that fail, `cols` and `col`, are ones tinyplot uses internally, so it looks like the `palette` expression is being
evaluated in a frame inside tinyplot where those names mean something else, instead of in the caller's environment.

Why it matters: `cols` is about the most natural name there is for a vector of colors. The error messages give no hint
of what went wrong; I first took it to mean that a palette could not be a vector of colors at all.

## 4. A legend erases the panels already drawn in a multi-panel layout

```r
op <- tpar(mfrow = c(1, 2))     # the same happens with par(mfrow = c(1, 2))
tinyplot(body_mass ~ flipper_len | species, data = peng, legend = FALSE)
tinyplot(bill_dep ~ bill_len | species, data = peng, legend = "bottomright")
tpar(op)
```

Expected: two panels, the second with a legend inside it. Observed: the first panel is blank, and only the second is drawn.
It happens whether the legend is inside or outside the plot region. With `legend = FALSE` in both calls,
both panels are drawn.

The workaround used in the vignette is `legend = FALSE` in every panel, and one legend added with base graphics.
