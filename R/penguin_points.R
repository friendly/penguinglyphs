#' Add penguin glyphs to a plot
#'
#' Draws a penguin glyph at each of the points `(x, y)` in an existing plot, in the
#' manner of [graphics::points()]. The features of each glyph are taken from the
#' corresponding row of `data`.
#'
#' @param x,y Coordinates of the glyphs, in the units of the current plot. Each should
#'   have one value for each row of `data`.
#' @param data Data frame with penguin measurements, one row for each point
#' @param bill_len Column name for bill length (default "bill_len")
#' @param bill_dep Column name for bill depth (default "bill_dep")
#' @param flipper_len Column name for flipper length (default "flipper_len")
#' @param body_mass Column name for body mass (default "body_mass")
#' @param species Column name for species (default "species")
#' @param sex Column name for sex (default "sex")
#' @param ref Reference data frame, whose ranges of the measurement variables determine
#'   how they are scaled. With the default, `NULL`, the ranges are those of the full
#'   [datasets::penguins] data, so that a given penguin is drawn the same way in any subset.
#'   A variable not found there is scaled by its range in `data`. Use `ref = data` to
#'   scale all variables relative to the rows being plotted.
#' @param size Height of a glyph in inches, for a penguin with all measurements at the
#'   middle of their ranges
#' @param id Labels to display in the bodies of the glyphs: `TRUE` to use the row names
#'   of `data`, or a vector of labels. The default, `FALSE`, gives no labels.
#' @param col Named vector of body colors, with species as names. See [penguin_colors()].
#' @param cex.lab Character expansion for the `id` labels (default 0.8)
#' @param ... Other arguments passed to [draw_penguin()], such as `lwd`
#'
#' @details Each continuous variable is normalized to a scale of 0.7 to 1.3, relative to
#' its range in `ref`. Rows with a missing `x` or `y` are not drawn. Other missing
#' values are shown as described in [draw_penguin()].
#'
#' @return `NULL`, invisibly. Called for its side effect of adding glyphs to a plot.
#' @seealso [penguin_legend()] to add a species legend; [penguin_glyphs()] for a grid display.
#'
#' @examples
#' data(penguins, package = "datasets")
#' set.seed(42)
#' peng <- penguins[sample(nrow(penguins), 30), ]
#'
#' # Glyphs as the point symbols in a scatterplot
#' plot(body_mass ~ flipper_len, data = peng, type = "n",
#'      xlab = "Flipper length (mm)", ylab = "Body mass (g)")
#' penguin_points(peng$flipper_len, peng$body_mass, peng)
#' penguin_legend("topleft", peng$species)
#'
#' # In a plot of the first two principal components
#' peng <- na.omit(penguins)
#' pca <- prcomp(peng[, 3:6], scale. = TRUE)
#' show <- sample(nrow(peng), 40)
#' plot(pca$x[, 1:2], type = "n")
#' penguin_points(pca$x[show, 1], pca$x[show, 2], peng[show, ], size = 0.5)
#' penguin_legend("top", peng$species, horiz = TRUE)
#'
#' @export
penguin_points <- function(x, y, data,
                           bill_len = "bill_len",
                           bill_dep = "bill_dep",
                           flipper_len = "flipper_len",
                           body_mass = "body_mass",
                           species = "species",
                           sex = "sex",
                           ref = NULL,
                           size = 0.4,
                           id = FALSE,
                           col = penguin_colors(),
                           cex.lab = 0.8,
                           ...) {

  n <- nrow(data)
  if (length(x) != n || length(y) != n) {
    stop("`x` and `y` must each have one value for each row of `data`")
  }

  id <- if (isTRUE(id)) rownames(data) else if (isFALSE(id)) NULL else id

  scales <- glyph_scales(data,
                         c(bill_len = bill_len, bill_dep = bill_dep,
                           flipper = flipper_len, body = body_mass),
                         ref = ref)

  for (i in seq_len(n)) {
    draw_penguin(
      x = x[i], y = y[i],
      bill_len_scale = scales$bill_len[i],
      bill_dep_scale = scales$bill_dep[i],
      flipper_scale = scales$flipper[i],
      body_scale = scales$body[i],
      species = as.character(data[[species]][i]),
      sex = as.character(data[[sex]][i]),
      id = id[i],
      size = size,
      col = col,
      cex.lab = cex.lab,
      ...
    )
  }

  invisible(NULL)
}

#' Species colors and legend for penguin glyphs
#'
#' `penguin_colors()` gives the default body colors used for the penguin species.
#' `penguin_legend()` adds a legend for the species to a plot of penguin glyphs,
#' with colors matched to the species by name.
#'
#' @param x Legend position, as in [graphics::legend()], e.g., "topleft" or "bottom"
#' @param species Vector of the species shown in the plot. Only those present are
#'   included in the legend, in the order of the factor levels.
#' @param col Named vector of body colors, with species as names
#' @param title Legend title
#' @param bty Type of box drawn around the legend (default "n", for none)
#' @param ... Other arguments passed to [graphics::legend()], such as `horiz` and `inset`
#'
#' @return `penguin_colors()` returns a named character vector of colors.
#'   `penguin_legend()` returns the result of [graphics::legend()], invisibly.
#'
#' @examples
#' penguin_colors()
#'
#' # Use other colors, matched to species by name
#' data(penguins, package = "datasets")
#' my_colors <- c(Adelie = "darkorange", Chinstrap = "purple", Gentoo = "cyan4")
#' peng <- penguins[c(1:3, 153:155, 278:280), ]
#' plot(bill_dep ~ bill_len, data = peng, type = "n")
#' penguin_points(peng$bill_len, peng$bill_dep, peng, col = my_colors)
#' penguin_legend("bottomright", peng$species, col = my_colors)
#'
#' @export
penguin_colors <- function() {
  c(Adelie    = "#FF6B35",    # Orange
    Chinstrap = "#9A78B8",    # Purple
    Gentoo    = "#73C05B")    # Green
}

#' @rdname penguin_colors
#' @export
penguin_legend <- function(x = "topleft", species,
                           col = penguin_colors(),
                           title = "Species", bty = "n", ...) {
  labs <- species_present(species)
  invisible(graphics::legend(x, legend = labs, fill = species_col(labs, col),
                             title = title, bty = bty, ...))
}
