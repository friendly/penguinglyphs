
#' Create a grid of penguin glyphs from a data frame
#'
#' Visualizes multiple penguins as a grid of glyphs, automatically normalizing
#' measurements to appropriate visual ranges. This function creates a complete
#' plot with legend showing the mapping between data and visual features.
#'
#' @inheritParams penguin_points
#' @param data Data frame with penguin measurements (typically [datasets::penguins])
#' @param ncol Number of columns in grid (default 5)
#' @param main Plot title (default "Penguin Glyphs")
#' @param legend List with legend parameters: `loc` for location
#'   (e.g., "topleft", "bottom") and `horiz` for horizontal layout (TRUE/FALSE).
#'   Default is `list(loc = "topleft", horiz = FALSE)`
#'
#' @details Each continuous variable is normalized to a scale of 0.7 to 1.3, relative
#' to its range in `ref`, to ensure visual differences are apparent but not extreme.
#' Row names from the data frame are displayed as IDs within each penguin glyph.
#' Missing values are shown as described in [draw_penguin()].
#'
#' @return NULL (creates a plot)
#' @seealso [penguin_points()] to use the glyphs as point symbols in another plot
#' @importFrom graphics par plot
#'
#' @examples
#' # Load the penguins dataset
#' data(penguins, package = "datasets")
#'
#' # Visualize first 5 penguins in each species
#' which <- outer(1:5, c(0, 152, 277), FUN ="+") |> c()
#' penguin_glyphs(penguins[which,])
#'
#' # Sample random penguins
#' set.seed(42)
#' sampled_rows <- sample(1:nrow(penguins), size = 20)
#' penguin_glyphs(penguins[sampled_rows, ], main = "Random Penguin Glyphs")
#'
#' # Look at specific outliers
#' outliers <- c(10, 35, 283)
#' penguin_glyphs(penguins[outliers,], main = "Notable Penguins")
#'
#' # Custom legend position
#' penguin_glyphs(penguins[sampled_rows, ],
#'                legend = list(loc = "bottom", horiz = FALSE))
#'
#' @export
penguin_glyphs <- function(data,
                           bill_len = "bill_len",
                           bill_dep = "bill_dep",
                           flipper_len = "flipper_len",
                           body_mass = "body_mass",
                           species = "species",
                           sex = "sex",
                           ncol = 5,
                           main = "Penguin Glyphs",
                           legend = list(loc = "topleft", horiz = FALSE),
                           ref = NULL,
                           col = penguin_colors()) {

  n <- nrow(data)
  nrow_grid <- ceiling(n / ncol)
  legend <- utils::modifyList(list(loc = "topleft", horiz = FALSE), legend)

  # Setup plot
  op <- par(mar = c(2, 5, 3, 2), xpd = TRUE)
  on.exit(par(op))
  plot(1, type = "n", xlim = c(0, ncol), ylim = c(0, nrow_grid),
       xlab = "", ylab = "", main = main, axes = FALSE, asp = 1)

  # Draw glyphs, one in the center of each grid cell
  i <- seq_len(n)
  cell <- 1 / graphics::xinch(1)     # size of a grid cell, in inches
  penguin_points(x = ((i - 1) %% ncol) + 0.5,
                 y = nrow_grid - ceiling(i / ncol) + 0.5,
                 data = data,
                 bill_len = bill_len, bill_dep = bill_dep,
                 flipper_len = flipper_len, body_mass = body_mass,
                 species = species, sex = sex,
                 ref = ref,
                 size = 0.85 * cell,
                 id = TRUE,
                 col = col,
                 cex.id = 1)

  # Add legend
  penguin_legend(legend$loc, data[[species]], col = col, horiz = legend$horiz)

  invisible(NULL)
}
