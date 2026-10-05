
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
#' @param cex.lab Character expansion for the ID labels in the glyphs (default 1)
#' @param legend List with legend parameters: `loc` for location, one of the keywords
#'   "topleft", "top", "topright", "left", "right", "bottomleft", "bottom" or "bottomright",
#'   and `horiz` for horizontal layout (TRUE/FALSE).
#'   Default is `list(loc = "topleft", horiz = FALSE)`
#'
#' @details Each continuous variable is normalized to a scale of 0.7 to 1.3, relative
#' to its range in `ref`, to ensure visual differences are apparent but not extreme.
#' Row names from the data frame are displayed as IDs within each penguin glyph.
#' Missing values are shown as described in [draw_penguin()].
#' 
#' The legend is placed outside the grid of glyphs, on the side given by `legend$loc`.
#' The grid cells are square, so there is usually spare room either beside the grid or 
#' above and below it. For a corner position such as "topleft", the legend goes beside
#' or above the grid, whichever leaves more room for the glyphs.
#'
#' @return NULL (creates a plot)
#' @seealso [penguin_points()] to use the glyphs as point symbols in another plot
#' @importFrom graphics par plot.new plot.window title xinch yinch
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
#' # Look at specific outliers, among the penguins with complete data.
#' # Renumbering the rows gives the same case numbers as in heplots::peng
#' peng <- na.omit(penguins)
#' rownames(peng) <- NULL
#' outliers <- c(10, 35, 283)
#' penguin_glyphs(peng[outliers,], main = "Notable Penguins")
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
                           col = penguin_colors(),
                           cex.lab = 1) {

  n <- nrow(data)
  nrow_grid <- ceiling(n / ncol)
  legend <- utils::modifyList(list(loc = "topleft", horiz = FALSE), legend)

  # Setup plot
  op <- par(mar = c(1, 1, 3, 1), xpd = TRUE)
  on.exit(par(op))
  plot.new()
  
  # Size of the legend, with a small gap between it and the grid, 
  # and of the plot region, in inches
  loc <- legend$loc
  gap <- 0.1
  size <- penguin_legend(0, data[[species]], col = col, horiz = legend$horiz, 
                         plot = FALSE)$rect
  leg_w <- size$w / xinch(1) + gap
  leg_h <- size$h / yinch(1) + gap
  pin <- par("pin")
  
  # Reserve a strip for the legend, either beside the grid or above/below it.
  # The grid cells are square, so often there is spare room in one direction, and 
  # the legend costs nothing. A corner position allows either: use the one that 
  # leaves the larger cells.
  cell_beside <- min((pin[1] - leg_w) / ncol, pin[2] / nrow_grid)
  cell_stack  <- min(pin[1] / ncol, (pin[2] - leg_h) / nrow_grid)
  can_beside <- grepl("left|right", loc)
  can_stack  <- grepl("top|bottom", loc)
  beside <- can_beside && (!can_stack || cell_beside >= cell_stack)
  stack  <- can_stack && !beside
  cell <- if (beside) cell_beside else if (stack) cell_stack else 0
  if (cell <= 0) {
    # legend inside the plot: other positions, or one too big to make room for
    beside <- stack <- FALSE
    cell <- min(pin / c(ncol, nrow_grid))
  }
  
  # Plot limits, in units of grid cells: the grid, plus the strip for the legend, 
  # centered in the plot region
  leg_w <- leg_w / cell
  leg_h <- leg_h / cell
  gap <- gap / cell
  xlim <- c(0, ncol)
  ylim <- c(0, nrow_grid)
  if (beside) {
    if (grepl("left", loc)) xlim[1] <- -leg_w else xlim[2] <- ncol + leg_w
  }
  if (stack) {
    if (grepl("bottom", loc)) ylim[1] <- -leg_h else ylim[2] <- nrow_grid + leg_h
  }
  xlim <- xlim + c(-1, 1) * (pin[1] / cell - diff(xlim)) / 2
  ylim <- ylim + c(-1, 1) * (pin[2] / cell - diff(ylim)) / 2
  plot.window(xlim, ylim, asp = 1, xaxs = "i", yaxs = "i")
  title(main = main)
  
  # Draw glyphs, one in the center of each grid cell
  i <- seq_len(n)
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
                 cex.lab = cex.lab)
  
  # Add legend: in its strip, aligned with the edges of the grid
  if (beside) {
    left <- grepl("left", loc)
    v <- if (grepl("top", loc)) 1 else if (grepl("bottom", loc)) 0 else 0.5
    penguin_legend(if (left) -gap else ncol + gap, data[[species]], 
                   y = v * nrow_grid, xjust = if (left) 1 else 0, yjust = v,
                   col = col, horiz = legend$horiz)
  } else if (stack) {
    bottom <- grepl("bottom", loc)
    h <- if (grepl("left", loc)) 0 else if (grepl("right", loc)) 1 else 0.5
    penguin_legend(h * ncol, data[[species]], 
                   y = if (bottom) -gap else nrow_grid + gap, 
                   xjust = h, yjust = if (bottom) 1 else 0,
                   col = col, horiz = legend$horiz)
  } else {
    penguin_legend(loc, data[[species]], col = col, horiz = legend$horiz)
  }
  
  invisible(NULL)
}
