
#' Create a grid of penguin glyphs from a data frame
#'
#' Visualizes multiple penguins as a grid of glyphs, automatically normalizing
#' measurements to appropriate visual ranges. This function creates a complete
#' plot with legend showing the mapping between data and visual features.
#'
#' @param data Data frame with penguin measurements (typically from palmerpenguins package)
#' @param bill_len Column name for bill length (default "bill_len")
#' @param bill_dep Column name for bill depth (default "bill_dep")
#' @param flipper_len Column name for flipper length (default "flipper_len")
#' @param body_mass Column name for body mass (default "body_mass")
#' @param species Column name for species (default "species")
#' @param sex Column name for sex (default "sex")
#' @param ncol Number of columns in grid (default 5)
#' @param main Plot title (default "Penguin Glyphs")
#' @param legend List with legend parameters: \code{loc} for location 
#'   (e.g., "topleft", "bottom") and \code{horiz} for horizontal layout (TRUE/FALSE).
#'   Default is \code{list(loc = "topleft", horiz = TRUE)}
#'
#' @details The function automatically normalizes all continuous variables to a 
#' scale of 0.7 to 1.3 to ensure visual differences are apparent but not extreme.
#' Row names from the data frame are displayed as IDs within each penguin glyph.
#'
#' @return NULL (creates a plot)
#'
#' @examples
#' # Load the penguins dataset (requires palmerpenguins or datasets package)
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
                           legend = list(loc = "topleft", horiz = FALSE)) {
  
  n <- nrow(data)
  nrow_grid <- ceiling(n / ncol)
  id <- rownames(data)
  
  # Normalize variables
  bill_len_norm <- normalize_var(data[[bill_len]], 0.7, 1.3)
  bill_dep_norm <- normalize_var(data[[bill_dep]], 0.7, 1.3)
  flipper_norm <- normalize_var(data[[flipper_len]], 0.7, 1.3)
  body_norm <- normalize_var(data[[body_mass]], 0.7, 1.3)
  
  # Setup plot
  par(mar = c(2, 5, 3, 2))
  plot(1, type = "n", xlim = c(0, ncol), ylim = c(0, nrow_grid),
       xlab = "", ylab = "", main = main, axes = FALSE, asp = 1)
  
  # Draw glyphs
  for (i in 1:n) {
    row <- ceiling(i / ncol)
    col <- ((i - 1) %% ncol) + 1
    
    x <- col - 0.5
    y <- nrow_grid - row + 0.5
    
    draw_penguin(
      x = x, y = y,
      bill_len_scale = bill_len_norm[i],
      bill_dep_scale = bill_dep_norm[i],
      flipper_scale = flipper_norm[i],
      body_scale = body_norm[i],
      species = as.character(data[[species]][i]),
      sex = as.character(data[[sex]][i]),
      id = id[i],
      base_size = 0.8
    )
  }
  
  # Add legend
  labs <- unique(data[[species]])
  legend(legend$loc, 
         horiz = legend$horiz, 
         legend = labs,
         fill = c("#FF6B35", "#9A78B8", "#73C05B")[1:length(labs)],
         title = "Species", bty = "n")
  
  invisible(NULL)
}
