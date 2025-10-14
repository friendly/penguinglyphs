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
