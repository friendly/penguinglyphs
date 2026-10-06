# tinyplot: feature request for `fill` and `fill.alpha` in `type_ellipse()`

A request for <https://github.com/grantmcdermott/tinyplot/issues>, from using `tinyplot::type_ellipse()` to draw
data ellipses for the species in `vignettes/introduction.Rmd`.

The bugs found along the way are in `notes/tinyplot-issues.md`; this note refers to two of them.

**Tested with tinyplot 0.7.0 and again with 0.8.0** (the current CRAN release), R 4.6.1, Windows, drawing to a `png()` device.

## The request

Let `type_ellipse()` take `fill = TRUE/FALSE` and `fill.alpha`, as `car::dataEllipse()` does, so that

```r
library(tinyplot)
data(penguins, package = "datasets")
peng <- na.omit(penguins)
cols <- c("#FF6B35", "#9A78B8", "#73C05B")

tinyplot(body_mass ~ flipper_len | species, data = peng, col = cols,
         type = type_ellipse(level = 0.68, fill = TRUE, fill.alpha = 0.15))
```

fills each ellipse with a transparent version of *its own* outline color, whatever that color is and however it was specified.
The same arguments would make sense for the other polygon types, `type_chull()` and `type_polygon()`.

In `car::dataEllipse()` these are `fill = FALSE` and `fill.alpha = 0.3`.

## What tinyplot does now

Line width and fill are both available, but **not as arguments to `type_ellipse()`**:

```r
type_ellipse(lwd = 2)
#> Error: unused argument (lwd = 2)
type_ellipse(fill = 0.2)
#> Error: unused argument (fill = 0.2)
```

`type_ellipse()` takes only `level`, `segments`, `density` and `angle`. The graphical parameters go to
`tinyplot()` or `tinyplot_add()`, which pass them on to the type:

```r
# thick outlines, filled at 20% opacity
tinyplot(body_mass ~ flipper_len | species, data = peng,
         type = type_ellipse(level = 0.68), lwd = 3, fill = 0.2)

# the same, layered on points
tinyplot(body_mass ~ flipper_len | species, data = peng, pch = 16)
tinyplot_add(type = type_ellipse(level = 0.68), lwd = 3, fill = 0.2)
```

What I checked, each drawn and looked at:

| Argument to `tinyplot()` / `tinyplot_add()` | Result |
|---|---|
| `lwd = 4` | thicker outlines: **works** |
| `fill = 0.2` | translucent fill in the default group colors: **works** |
| `bg = "by"` | solid fill in the group colors: **works** |
| `bg = adjustcolor(cols, 0.25)` | fill in colors I supply: **works** |
| `type_ellipse(density = 10)` | hatched ellipses: **works** |
| `lty = 2`, `lty = "dashed"`, `lty = "by"` | **ignored** (issue 1 in `tinyplot-issues.md`) |

`fill = 0.2` gives a *solid, translucent* fill, with 0.2 as the opacity. In my tests, with both versions, it did not
produce hatching; hatching is what `type_ellipse(density = )` gives. If `fill` shows as cross-hatching somewhere,
the exact call and the graphics device are needed to pin that down, and that would be a separate report.

## Why the present interface is not enough

* **The name.** `fill = <number>` is an opacity. That is not what an argument named `fill` suggests, and there is nothing
  corresponding to "fill, yes or no" with a separately chosen transparency.
* **Where it is documented.** It is an argument to `tinyplot()` rather than to the type, so it does not appear on the help page for
  `type_ellipse()`, except in an example.
* **It does not follow custom colors.** With colors given by `col`, the outlines use them but the fills come from the default
  palette, so the fill and outline of an ellipse disagree (issue 2 in `tinyplot-issues.md`).
* **The alternative, `palette`, is fragile.** Giving the colors as `palette = ` instead does produce matching fills, but
  `palette` fails for some variable names, for a function call, and for variables outside the global environment (issue 3).

So the dependable way to get filled ellipses in one's own colors is to compute the fill colors by hand:

```r
tinyplot(body_mass ~ flipper_len | species, data = peng,
         type = type_ellipse(level = 0.68),
         col = cols, lwd = 1.5,
         bg = adjustcolor(cols, alpha.f = 0.15))
```

This works well, and is what the vignette does, but it is not something a user would find without knowing
that `bg` is the fill color of a polygon type.

Fixing issue 2 would give most of what is wanted through the existing `fill = <alpha>`. The request is for the clearer
interface, on the type, where someone looking for it would find it.

## What the vignette does now

`vignettes/introduction.Rmd` draws 68% ellipses with `lwd = 1.5` and a fill at 15% opacity, using the `bg` approach:

```r
cols <- unname(penguin_colors())

tinyplot(body_mass ~ flipper_len | species, data = samp,
         type = type_ellipse(level = 0.68),
         col = cols, lwd = 1.5,
         bg = adjustcolor(cols, alpha.f = 0.15),
         legend = FALSE)
```

When the ellipses are layered on points, the same arguments go to `tinyplot_add()`.
