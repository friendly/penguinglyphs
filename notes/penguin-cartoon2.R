#' Draw a Cartoon-Style Penguin Glyph
#'
#' Draws a simplified cartoon penguin with exaggerated features for better
#' visualization of bill and flipper measurements. Unlike the realistic
#' version, this cartoon style uses a smaller head and larger bill/flippers
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
#' - Head is proportionally smaller (30% of body height vs 40% in realistic)
#' - Bill is more prominent (extends 60% of head width)
#' - Flippers are larger and more exaggerated (70% of body height)
#' - Body is more compact to reduce visual dominance
#' - Features are simplified for clarity
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
  
  # Species colors (same as original)
  species_colors <- c(
    "Adelie" = "#FF6B35",
    "Chinstrap" = "#9A78B8",
    "Gentoo" = "#73C05B"
  )
  
  body_color <- species_colors[species]
  if (is.na(body_color)) body_color <- species_colors["Adelie"]
  
  # Cartoon proportions (simplified, geometric style)
  body_width <- base_size * 1.0 * body_scale  # Narrower body
  body_height <- base_size * 1.3 * body_scale  # Shorter body
  head_size <- base_size * 0.35 * body_scale  # Much smaller head
  
  # Bill dimensions (very prominent, triangular)
  bill_length <- head_size * 1.0 * bill_len_scale  # Long bill
  bill_depth <- head_size * 0.2 * bill_depth_scale  # Pointed bill
  
  # Flipper dimensions (large, wing-like)
  flipper_length <- body_height * 1.0 * flipper_scale  # Very long
  flipper_width <- base_size * 0.25
  
  # Body position (compact, upright)
  body_y <- y
  
  # Draw body (slightly wider, less tall for cartoon look)
  theta <- seq(0, 2 * pi, length.out = 100)
  body_x <- x + body_width * cos(theta)
  body_y_coords <- body_y + body_height * sin(theta)
  polygon(body_x, body_y_coords, col = body_color, border = "black", lwd = 1.5)
  
  # White belly (large oval, dominant feature)
  belly_width <- body_width * 0.65
  belly_height <- body_height * 0.85
  belly_x <- x + belly_width * cos(theta)
  belly_y <- body_y + belly_height * sin(theta) * 0.85 - body_height * 0.05
  polygon(belly_x, belly_y, col = "white", border = NA)
  
  # Head position (on top of body, small)
  head_y <- y + body_height * 0.7
  
  # Draw head (smaller circle)
  head_x <- x + head_size * cos(theta)
  head_y_coords <- head_y + head_size * sin(theta)
  polygon(head_x, head_y_coords, col = body_color, border = "black", lwd = 1.5)
  
  # Draw bill (larger and more prominent)
  bill_x <- x + head_size * 0.4
  bill_y_top <- head_y + bill_depth
  bill_y_bottom <- head_y - bill_depth
  bill_tip <- bill_x + bill_length
  
  polygon(
    c(bill_x, bill_tip, bill_tip, bill_x),
    c(bill_y_top, head_y + bill_depth * 0.5, head_y - bill_depth * 0.5, bill_y_bottom),
    col = "orange", border = "black", lwd = 1.5
  )
  
  # Draw flippers (wing-like, outstretched, simplified triangular shapes)
  flipper_base_y <- body_y + body_height * 0.2
  
  # Left flipper (simple triangle pointing left and slightly up)
  left_flipper_x <- c(
    x - body_width * 0.4,  # base connection
    x - body_width * 0.5 - flipper_length * 0.6,  # tip
    x - body_width * 0.45  # lower base
  )
  left_flipper_y <- c(
    flipper_base_y + body_height * 0.1,
    flipper_base_y + body_height * 0.05,
    flipper_base_y - body_height * 0.15
  )
  polygon(left_flipper_x, left_flipper_y, 
          col = body_color, border = "black", lwd = 1.5)
  
  # Right flipper (simple triangle pointing right and slightly up)
  right_flipper_x <- c(
    x + body_width * 0.4,  # base connection
    x + body_width * 0.5 + flipper_length * 0.6,  # tip
    x + body_width * 0.45  # lower base
  )
  right_flipper_y <- c(
    flipper_base_y + body_height * 0.1,
    flipper_base_y + body_height * 0.05,
    flipper_base_y - body_height * 0.15
  )
  polygon(right_flipper_x, right_flipper_y, 
          col = body_color, border = "black", lwd = 1.5)
  
  # Draw eyes (sex dimorphism)
  eye_y <- head_y + head_size * 0.15
  eye_size <- head_size * 0.15
  left_eye_x <- x - head_size * 0.25
  right_eye_x <- x + head_size * 0.25
  
  if (sex == "female") {
    # Round eyes for females
    symbols(left_eye_x, eye_y, circles = eye_size, 
            inches = FALSE, add = TRUE, 
            fg = "black", bg = "white", lwd = 1.5)
    symbols(right_eye_x, eye_y, circles = eye_size, 
            inches = FALSE, add = TRUE, 
            fg = "black", bg = "white", lwd = 1.5)
    # Pupils
    points(left_eye_x, eye_y, pch = 19, cex = 0.4)
    points(right_eye_x, eye_y, pch = 19, cex = 0.4)
  } else {
    # Angular eyes for males
    eye_offset <- eye_size * 0.8
    polygon(
      c(left_eye_x - eye_offset, left_eye_x, 
        left_eye_x + eye_offset, left_eye_x),
      c(eye_y, eye_y + eye_offset, eye_y, eye_y - eye_offset),
      col = "white", border = "black", lwd = 1.5
    )
    polygon(
      c(right_eye_x - eye_offset, right_eye_x, 
        right_eye_x + eye_offset, right_eye_x),
      c(eye_y, eye_y + eye_offset, eye_y, eye_y - eye_offset),
      col = "white", border = "black", lwd = 1.5
    )
    # Pupils
    points(left_eye_x, eye_y, pch = 19, cex = 0.4)
    points(right_eye_x, eye_y, pch = 19, cex = 0.4)
  }
  
  # Draw feet (simple triangular webbed feet)
  feet_y <- body_y - body_height * 0.7
  
  # Left foot (simple triangle)
  left_foot_x <- c(
    x - body_width * 0.25,
    x - body_width * 0.35,
    x - body_width * 0.15
  )
  left_foot_y <- c(
    feet_y,
    feet_y - base_size * 0.15,
    feet_y - base_size * 0.15
  )
  polygon(left_foot_x, left_foot_y,
          col = "darkorange", border = "black", lwd = 1.2)
  
  # Right foot (simple triangle)
  right_foot_x <- c(
    x + body_width * 0.25,
    x + body_width * 0.35,
    x + body_width * 0.15
  )
  right_foot_y <- c(
    feet_y,
    feet_y - base_size * 0.15,
    feet_y - base_size * 0.15
  )
  polygon(right_foot_x, right_foot_y,
          col = "darkorange", border = "black", lwd = 1.2)
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
  bill_len_norm <- normalize_var(data$bill_length_mm)
  bill_depth_norm <- normalize_var(data$bill_depth_mm)
  flipper_norm <- normalize_var(data$flipper_length_mm)
  body_norm <- normalize_var(data$body_mass_g)
  
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

