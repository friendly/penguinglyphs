# Internal helpers shared by the glyph functions

# Drawing tools for a glyph centred at (x, y) in user coordinates.
# Offsets are given in glyph units, each `unit` inches long, so the glyph keeps
# its shape whatever the aspect ratio or scale (including log scale) of the axes.
glyph_pen <- function(x, y, unit) {
  x0 <- grconvertX(x, "user", "inches")
  y0 <- grconvertY(y, "user", "inches")
  X <- function(dx) grconvertX(x0 + dx * unit, "inches", "user")
  Y <- function(dy) grconvertY(y0 + dy * unit, "inches", "user")
  theta <- seq(0, 2 * pi, length.out = 60)

  list(
    polygon = function(dx, dy, ...) polygon(X(dx), Y(dy), ...),
    ellipse = function(cx, cy, rx, ry = rx, ...)
      polygon(X(cx + rx * cos(theta)), Y(cy + ry * sin(theta)), ...),
    segments = function(dx0, dy0, dx1, dy1, ...)
      segments(X(dx0), Y(dy0), X(dx1), Y(dy1), ...)
  )
}

# Scale factors for the glyph features, one column per variable in `vars`.
# Ranges are taken from `ref` where it has the variable, otherwise from `data`.
glyph_scales <- function(data, vars, ref = NULL, to = c(0.7, 1.3)) {
  if (is.null(ref)) {
    # datasets::penguins, which only exists in R >= 4.5
    ref <- tryCatch(getExportedValue("datasets", "penguins"),
                    error = function(e) NULL)
  }
  scales <- lapply(vars, function(v) {
    from <- if (!is.null(ref) && is.numeric(ref[[v]])) range(ref[[v]], na.rm = TRUE)
    normalize_var(data[[v]], to[1], to[2], from = from)
  })
  names(scales) <- names(vars)
  as.data.frame(scales)
}

# Look up species colors by name; unknown or missing species are grey
species_col <- function(species, col = penguin_colors()) {
  out <- unname(col[as.character(species)])
  out[is.na(out)] <- "#666666"
  out
}

# Species present in the data, in factor level order
species_present <- function(species) {
  if (is.factor(species)) levels(droplevels(species))
  else unique(stats::na.omit(as.character(species)))
}
