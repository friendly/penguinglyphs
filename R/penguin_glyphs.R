#' Draw a single penguin glyph
#'
#' Draws a schematic penguin at specified coordinates with customizable features
#' that represent different measurements. The visual encoding maps:
#' \itemize{
#'   \item Bill length -> horizontal extent of the bill
#'   \item Bill depth -> vertical thickness of the bill
#'   \item Flipper length -> length of the flippers
#'   \item Body mass -> overall body size
#'   \item Species -> body color (Adelie=orange, Chinstrap=purple, Gentoo=green)
#'   \item Sex -> eye shape (angular for males, round for females)
#' }
#'
#' @param x X coordinate for center of penguin
#' @param y Y coordinate for center of penguin
#' @param bill_len_scale Scale factor for bill length (default 1)
#' @param bill_dep_scale Scale factor for bill depth (default 1)
#' @param flipper_scale Scale factor for flipper length (default 1)
#' @param body_scale Scale factor for body size (default 1)
#' @param species Species name affecting color: "Adelie", "Chinstrap", or "Gentoo"
#' @param sex Sex affecting eye shape: "male" or "female"
#' @param id Optional identifier to display in the penguin's body
#' @param base_size Base size multiplier for entire glyph (default 1)
#' @importFrom graphics par points polygon segments symbols text
#'
#' @details This function should be called within an existing plot with appropriate
#' coordinates and aspect ratio (asp=1 recommended). It uses base R graphics.
#'
#' @examples
#' # Create a plot area and draw a single penguin
#' plot(1, xlim=c(0,2), ylim=c(0,2), type="n", asp=1, 
#'      xlab="", ylab="", main="Single Penguin")
#' draw_penguin(1, 1, bill_len_scale=1.2, body_scale=1.4, 
#'              species="Gentoo", sex="female")
#'
#' # Draw multiple penguins with different characteristics
#' plot(1, xlim=c(0,4), ylim=c(0,2), type="n", asp=1,
#'      xlab="", ylab="", main="Penguin Comparison")
#' draw_penguin(1, 1, species="Adelie", sex="male", id="1")
#' draw_penguin(2, 1, species="Chinstrap", sex="female", id="2")
#' draw_penguin(3, 1, species="Gentoo", sex="male", id="3")
#'
#' @export
draw_penguin <- function(x, y, 
                         bill_len_scale = 1, 
                         bill_dep_scale = 1,
                         flipper_scale = 1, 
                         body_scale = 1,
                         species = "Adelie",
                         sex = "male",
                         id = NULL, 
                         base_size = 1) {
  
  # Species color mapping
  species_colors <- list(
    "Adelie" = "#FF6B35",      # Orange
    "Chinstrap" = "#9A78B8",   # Purple
    "Gentoo" = "#73C05B"       # Green
  )
  bill_color <- "lightblue"
  foot_color <- "black"
  
  body_col <- species_colors[[species]]
  if (is.null(body_col)) body_col <- "#666666"
  
  # Scale factors
  bs <- base_size
  body_width <- 0.4 * body_scale * bs
  body_height <- 0.5 * body_scale * bs
  
  # Draw body (ellipse)
  theta <- seq(0, 2*pi, length.out = 100)
  body_x <- x + body_width * cos(theta)
  body_y <- y + body_height * sin(theta)
  polygon(body_x, body_y, col = body_col, border = "black", lwd = 1.5)
  
  # Draw belly (lighter ellipse)
  belly_width <- body_width * 0.6
  belly_height <- body_height * 0.7
  belly_x <- x + belly_width * cos(theta)
  belly_y <- y - 0.05 * bs + belly_height * sin(theta) * 0.8
  polygon(belly_x, belly_y, col = "white", border = NA)
  
  # Draw head
  head_radius <- 0.15 * body_scale * bs
  head_y <- y + body_height + head_radius * 0.6
  theta_head <- seq(0, 2*pi, length.out = 50)
  head_x <- x + head_radius * cos(theta_head)
  head_y_coords <- head_y + head_radius * sin(theta_head)
  polygon(head_x, head_y_coords, col = body_col, border = "black", lwd = 1.5)
  
  # Draw bill
  bill_length <- 0.40 * bill_len_scale * bs
  bill_depth  <- 0.20 * bill_dep_scale * bs
  bill_x <- c(x, x + bill_length, x + bill_length, x)
  bill_y <- c(head_y + bill_depth/2, head_y + bill_depth/3, 
              head_y - bill_depth/3, head_y - bill_depth/2)
  polygon(bill_x, bill_y, col = bill_color, border = "black", lwd = 1.5)
  
  # Draw eyes (shape depends on sex)
  eye_y <- head_y + head_radius * 0.2
  eye_size <- 0.05 * bs
  
  if (!is.na(sex) && sex == "female") {
    # Rounder eyes for females
    symbols(x - 0.06*bs, eye_y, circles = eye_size, 
            inches = FALSE, add = TRUE, fg = "black", bg = "white", lwd = 1.5)
    symbols(x + 0.06*bs, eye_y, circles = eye_size, 
            inches = FALSE, add = TRUE, fg = "black", bg = "white", lwd = 1.5)
  } else {
    # More angular eyes for males
    left_eye_x <- c(x - 0.06*bs - eye_size, x - 0.06*bs + eye_size, 
                    x - 0.06*bs + eye_size, x - 0.06*bs - eye_size)
    left_eye_y <- c(eye_y - eye_size*0.7, eye_y - eye_size*0.7, 
                    eye_y + eye_size, eye_y + eye_size)
    polygon(left_eye_x, left_eye_y, col = "white", border = "black", lwd = 1.5)
    
    right_eye_x <- left_eye_x + 0.12*bs
    polygon(right_eye_x, left_eye_y, col = "white", border = "black", lwd = 1.5)
  }
  
  # Draw pupils
  points(x - 0.06*bs, eye_y, pch = 19, cex = 0.5*bs)
  points(x + 0.06*bs, eye_y, pch = 19, cex = 0.5*bs)
  
  # Draw flippers
  flipper_length <- 0.35 * flipper_scale * bs
  flipper_width <- 0.12 * bs
  
  # Left flipper
  left_flip_x <- c(x - body_width*0.7, x - body_width*0.9 - flipper_length*0.5,
                   x - body_width*0.9 - flipper_length, x - body_width*0.8)
  left_flip_y <- c(y, y - flipper_width, y - flipper_width*0.5, y + flipper_width*0.3)
  polygon(left_flip_x, left_flip_y, col = body_col, border = "black", lwd = 1.5)
  
  # Right flipper
  right_flip_x <- c(x + body_width*0.7, x + body_width*0.9 + flipper_length*0.5,
                    x + body_width*0.9 + flipper_length, x + body_width*0.8)
  right_flip_y <- left_flip_y
  polygon(right_flip_x, right_flip_y, col = body_col, border = "black", lwd = 1.5)
  
  # Draw feet
  foot_size <- 0.08 * bs
  # Left foot
  segments(x - 0.1*bs, y - body_height, x - 0.15*bs, y - body_height - foot_size, 
           col = foot_color, lwd = 2)
  segments(x - 0.15*bs, y - body_height - foot_size, 
           x - 0.2*bs, y - body_height - foot_size*0.7, col = foot_color, lwd = 2)
  segments(x - 0.15*bs, y - body_height - foot_size, 
           x - 0.1*bs, y - body_height - foot_size*0.7, col = foot_color, lwd = 2)
  
  # Right foot
  segments(x + 0.1*bs, y - body_height, x + 0.15*bs, y - body_height - foot_size, 
           col = foot_color, lwd = 2)
  segments(x + 0.15*bs, y - body_height - foot_size, 
           x + 0.2*bs, y - body_height - foot_size*0.7, col = foot_color, lwd = 2)
  segments(x + 0.15*bs, y - body_height - foot_size, 
           x + 0.1*bs, y - body_height - foot_size*0.7, col = foot_color, lwd = 2)
  
  # Label the glyph with id
  if (!is.null(id)) text(x, y, label=id)
}

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
#' \dontrun{
#' # Load the penguins dataset (requires palmerpenguins or datasets package)
#' data(penguins, package = "datasets")
#' 
#' # Visualize first 20 penguins
#' penguin_glyphs(head(penguins, 20), main = "Palmer Penguins")
#' 
#' # Sample random penguins
#' set.seed(42)
#' sampled_rows <- sample(1:nrow(penguins), size = 20)
#' penguin_glyphs(penguins[sampled_rows, ], main = "Random Sample")
#' 
#' # Look at specific outliers
#' outliers <- c(10, 35, 283)
#' penguin_glyphs(penguins[outliers,], main = "Notable Penguins")
#' 
#' # Custom legend position
#' penguin_glyphs(penguins[sampled_rows, ], 
#'                legend = list(loc = "bottom", horiz = FALSE))
#' }
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
                           legend = list(loc = "topleft", horiz = TRUE)) {
  
  n <- nrow(data)
  nrow_grid <- ceiling(n / ncol)
  id <- rownames(data)
  
  # Normalize variables
  bill_len_norm <- normalize_var(data[[bill_len]], 0.7, 1.3)
  bill_dep_norm <- normalize_var(data[[bill_dep]], 0.7, 1.3)
  flipper_norm <- normalize_var(data[[flipper_len]], 0.7, 1.3)
  body_norm <- normalize_var(data[[body_mass]], 0.7, 1.3)
  
  # Setup plot
  par(mar = c(2, 2, 3, 2))
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
