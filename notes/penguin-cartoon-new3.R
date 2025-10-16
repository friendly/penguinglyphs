#' Draw a Cartoon-Style Penguin Glyph
#'
#' Draws a simplified cartoon penguin with exaggerated features for better
#' visualization of bill and flipper measurements. Unlike the realistic
#' version, this cartoon style uses a smaller body and larger bill/flippers
#' to prevent body size from dominating the display.
#'
#' @param x numeric; x-coordinate for penguin center
#' @param y numeric; y-coordinate for penguin center
#' @param bill_len_scale numeric; scaling factor for bill length (default 1)
#' @param bill_depth_scale numeric; scaling factor for bill depth (default 1)
#' @param flipper_scale numeric; scaling factor for flipper length (default 1)
#' @param body_scale numeric; scaling factor for body size (default 1)
#' @param species character; one of "Adelie", "Chinstrap", "Gentoo"
#' @param sex character; "male" or "female" (affects eye shape)
#' @param base_size numeric; base size multiplier for entire glyph (default 0.1)
#'
#' @details
#' The cartoon style uses these design principles:
#' - Compact body similar to reference cartoon image
#' - Bill is very prominent and extends outward
#' - Flippers extend horizontally like outstretched wings
#' - Body shape is simplified to prevent size dominance
#' - Large white belly oval is the dominant body feature
#'
#' @export
draw_penguin_cartoon <- function(x, y,
                                 bill_len_scale = 1,
                                 bill_depth_scale = 1,
                                 flipper_scale = 1,
                                 body_scale = 1,
                                 species = "Adelie",
                                 sex = "male",
                                 base_size = 0.1) {
  
  # Species colors
  species_colors <- c(
    "Adelie" = "#FF6B35",
    "Chinstrap" = "#9A78B8",
    "Gentoo" = "#73C05B"
  )
  
  body_color <- species_colors[species]
  if (is.na(body_color)) body_color <- species_colors["Adelie"]
  
  # Cartoon proportions - very compact body
  body_width <- base_size * 0.6 * body_scale
  body_height <- base_size * 0.9 * body_scale
  
  # Bill dimensions - very prominent
  bill_length <- base_size * 0.5 * bill_len_scale
  bill_width <- base_size * 0.08 * bill_depth_scale
  
  # Flipper dimensions - extend outward horizontally
  flipper_length <- base_size * 0.7 * flipper_scale
  flipper_width <- base_size * 0.15
  
  # Head size - small, integrated with body
  head_radius <- base_size * 0.25 * body_scale
  head_y <- y + body_height * 0.5
  
  theta <- seq(0, 2 * pi, length.out = 100)
  
  # Draw body (compact oval)
  body_x <- x + body_width * cos(theta)
  body_y_coords <- y + body_height * sin(theta)
  polygon(body_x, body_y_coords, col = body_color, border = "black", lwd = 2)
  
  # Draw large white belly oval (dominant feature)
  belly_width <- body_width * 0.7
  belly_height <- body_height * 0.8
  belly_x <- x + belly_width * cos(theta)
  belly_y <- y + belly_height * sin(theta) - body_height * 0.05
  polygon(belly_x, belly_y, col = "white", border = NA)
  
  # Draw head (small, integrated at top of body)
  head_x <- x + head_radius * cos(theta)
  head_y_coords <- head_y + head_radius * sin(theta)
  polygon(head_x, head_y_coords, col = body_color, border = "black", lwd = 2)
  
  # Draw bill (triangular, very prominent)
  bill_base_x <- x + head_radius * 0.5
  bill_tip_x <- bill_base_x + bill_length
  bill_y <- head_y
  
  polygon(
    c(bill_base_x, bill_tip_x, bill_tip_x, bill_base_x),
    c(bill_y + bill_width, bill_y + bill_width * 0.3, 
      bill_y - bill_width * 0.3, bill_y - bill_width),
    col = "orange", border = "black", lwd = 1.5
  )
  
  # Draw left flipper (extends horizontally outward)
  left_flipper_base_x <- x - body_width * 0.7
  left_flipper_y <- y + body_height * 0.15
  
  left_flipper_x <- c(
    left_flipper_base_x,
    left_flipper_base_x - flipper_length * 0.8,
    left_flipper_base_x - flipper_length,
    left_flipper_base_x - flipper_length * 0.8,
    left_flipper_base_x
  )
  left_flipper_y_coords <- c(
    left_flipper_y + flipper_width * 0.3,
    left_flipper_y + flipper_width * 0.5,
    left_flipper_y,
    left_flipper_y - flipper_width * 0.5,
    left_flipper_y - flipper_width * 0.3
  )
  polygon(left_flipper_x, left_flipper_y_coords, 
          col = body_color, border = "black", lwd = 2)
  
  # Draw right flipper (extends horizontally outward)
  right_flipper_base_x <- x + body_width * 0.7
  right_flipper_y <- y + body_height * 0.15
  
  right_flipper_x <- c(
    right_flipper_base_x,
    right_flipper_base_x + flipper_length * 0.8,
    right_flipper_base_x + flipper_length,
    right_flipper_base_x + flipper_length * 0.8,
    right_flipper_base_x
  )
  right_flipper_y_coords <- c(
    right_flipper_y + flipper_width * 0.3,
    right_flipper_y + flipper_width * 0.5,
    right_flipper_y,
    right_flipper_y - flipper_width * 0.5,
    right_flipper_y - flipper_width * 0.3
  )
  polygon(right_flipper_x, right_flipper_y_coords, 
          col = body_color, border = "black", lwd = 2)
  
  # Draw eye (single eye visible from side view)
  eye_x <- x + head_radius * 0.3
  eye_y <- head_y + head_radius * 0.2
  eye_size <- head_radius * 0.3
  
  if (sex == "female") {
    # Round eye for females
    eye_x_coords <- eye_x + eye_size * cos(theta)
    eye_y_coords <- eye_y + eye_size * sin(theta)
    polygon(eye_x_coords, eye_y_coords, 
            col = "white", border = "black", lwd = 1.5)
    # Pupil
    points(eye_x, eye_y, pch = 19, cex = 0.5)
  } else {
    # Angular eye for males
    eye_offset <- eye_size * 0.8
    polygon(
      c(eye_x - eye_offset, eye_x, eye_x + eye_offset, eye_x),
      c(eye_y, eye_y + eye_offset, eye_y, eye_y - eye_offset),
      col = "white", border = "black", lwd = 1.5
    )
    # Pupil
    points(eye_x, eye_y, pch = 19, cex = 0.5)
  }
  
  # Draw feet (simple triangular feet)
  feet_y <- y - body_height * 0.85
  foot_size <- base_size * 0.2
  
  # Left foot
  left_foot_x <- c(
    x - body_width * 0.3,
    x - body_width * 0.4,
    x - body_width * 0.2
  )
  left_foot_y <- c(
    feet_y,
    feet_y - foot_size,
    feet_y - foot_size
  )
  polygon(left_foot_x, left_foot_y,
          col = "darkorange", border = "black", lwd = 1.5)
  
  # Right foot
  right_foot_x <- c(
    x + body_width * 0.3,
    x + body_width * 0.4,
    x + body_width * 0.2
  )
  right_foot_y <- c(
    feet_y,
    feet_y - foot_size,
    feet_y - foot_size
  )
  polygon(right_foot_x, right_foot_y,
          col = "darkorange", border = "black", lwd = 1.5)
}


#' Normalize Variable for Visual Scaling
#'
#' Internal helper function for normalizing variables to visual scale ranges
#'
#' @param x numeric vector to normalize
#' @param min_scale minimum scale value (default 0.7)
#' @param max_scale maximum scale value (default 1.3)
#'
#' @return normalized numeric vector
normalize_var <- function(x, min_scale = 0.7, max_scale = 1.3) {
  if (all(is.na(x))) return(rep(1, length(x)))
  x_min <- min(x, na.rm = TRUE)
  x_max <- max(x, na.rm = TRUE)
  if (x_max == x_min) return(rep(1, length(x)))
  
  normalized <- (x - x_min) / (x_max - x_min)
  scaled <- min_scale + normalized * (max_scale - min_scale)
  scaled[is.na(scaled)] <- 1
  return(scaled)
}


#' Create Cartoon Penguin Glyph Visualization
#'
#' Creates a grid display of multiple cartoon-style penguin glyphs from a data frame.
#' This is the cartoon version of penguin_glyphs() with exaggerated features.
#'
#' @param data data frame with penguin measurements (default: datasets::penguins)
#' @param ncol integer; number of columns in the grid (default 5)
#' @param main character; plot title
#' @param legend list; legend configuration with elements 'loc' and 'horiz'
#'
#' @export
#' @examples
#' # Load the penguins dataset
#' data(penguins, package = "datasets")
#' 
#' # Visualize first 5 penguins in each species
#' which <- outer(1:5, c(0, 152, 277), FUN ="+") |> c()
#' penguin_glyphs_cartoon(penguins[which,])
#' 
#' # Sample random penguins
#' set.seed(42)
#' sampled_rows <- sample(1:nrow(penguins), size = 20)
#' penguin_glyphs_cartoon(penguins[sampled_rows, ], main = "Random Penguin Glyphs")

penguin_glyphs_cartoon <- function(data = NULL,
                                   ncol = 5,
                                   main = "Cartoon Penguin Glyphs",
                                   legend = list(loc = "topright", horiz = TRUE)) {
  
  if (is.null(data)) {
    data <- datasets::penguins
  }
  
  # Remove NA rows
  data <- na.omit(data)
  
  n <- nrow(data)
  nrow_grid <- ceiling(n / ncol)
  
  # Set up plot
  par(mar = c(2, 2, 3, 2))
  plot(1, type = "n", xlim = c(0, ncol), ylim = c(0, nrow_grid),
       xlab = "", ylab = "", axes = FALSE, main = main, asp = 1)
  
  # Normalize variables for visual scaling
  # Handle both palmerpenguins and datasets column name conventions
  bill_len_col <- if("bill_length_mm" %in% names(data)) "bill_length_mm" else "bill_len"
  bill_depth_col <- if("bill_depth_mm" %in% names(data)) "bill_depth_mm" else "bill_dep"
  flipper_col <- if("flipper_length_mm" %in% names(data)) "flipper_length_mm" else "flipper_len"
  body_col <- if("body_mass_g" %in% names(data)) "body_mass_g" else "body_mass"
  
  bill_len_norm <- normalize_var(data[[bill_len_col]])
  bill_depth_norm <- normalize_var(data[[bill_depth_col]])
  flipper_norm <- normalize_var(data[[flipper_col]])
  body_norm <- normalize_var(data[[body_col]])
  
  # Draw each penguin
  for (i in 1:n) {
    col_pos <- (i - 1) %% ncol
    row_pos <- nrow_grid - floor((i - 1) / ncol) - 1
    
    x <- col_pos + 0.5
    y <- row_pos + 0.5
    
    draw_penguin_cartoon(
      x = x,
      y = y,
      bill_len_scale = bill_len_norm[i],
      bill_depth_scale = bill_depth_norm[i],
      flipper_scale = flipper_norm[i],
      body_scale = body_norm[i],
      species = as.character(data$species[i]),
      sex = as.character(data$sex[i]),
      base_size = 0.35
    )
  }
  
  # Add legend
  species_colors <- c(
    "Adelie" = "#FF6B35",
    "Chinstrap" = "#9A78B8",
    "Gentoo" = "#73C05B"
  )
  
  legend(legend$loc,
         legend = names(species_colors),
         fill = species_colors,
         title = "Species",
         horiz = legend$horiz,
         bty = "n")
}
