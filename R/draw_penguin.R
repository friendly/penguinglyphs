#' Draw a single penguin glyph
#'
#' Draws a schematic penguin at specified coordinates with customizable features
#' that represent different measurements. The visual encoding maps:
#'
#' * Bill length -> horizontal extent of the bill
#' * Bill depth -> vertical thickness of the bill
#' * Flipper length -> length of the flippers
#' * Body mass -> overall body size
#' * Species -> body color (Adelie=orange, Chinstrap=purple, Gentoo=green)
#' * Sex -> eye shape (angular for males, round for females)
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
#' @param size Height of the glyph in inches, for a penguin with all scale factors
#'   equal to 1 (default 0.6)
#' @param col Named vector of body colors, with species as names. See [penguin_colors()].
#' @param lwd Line width for the glyph outlines
#' @param cex.id Character expansion for the `id` label
#' @importFrom graphics grconvertX grconvertY polygon segments text
#'
#' @details This function should be called within an existing plot. It uses base R graphics.
#'
#' The glyph is centered at the data coordinates `(x, y)`, but is sized in inches rather
#' than in the units of the axes. It therefore has the same shape and size in any plot,
#' whatever the aspect ratio or the ranges of the axes, in the same way as a plotting symbol.
#'
#' A scale factor that is `NA` is drawn at the neutral value of 1, with the corresponding
#' part of the glyph shown as an unfilled, dashed outline. If `sex` is `NA`, the eyes are
#' drawn as pupils only.
#'
#' @return `NULL`, invisibly. Called for its side effect of drawing a glyph.
#' @seealso [penguin_points()] to add glyphs for the rows of a data frame to a plot;
#'   [penguin_glyphs()] for a grid display.
#'
#' @examples
#' # Create a plot area and draw a single penguin
#' plot(1, xlim=c(0,2), ylim=c(0,2), type="n", asp=1,
#'      xlab="", ylab="", main="Single Penguin")
#' draw_penguin(1, 1, bill_len_scale=1.2, body_scale=1.4,
#'              species="Gentoo", sex="female", size = 2)
#'
#' # Draw multiple penguins with different characteristics
#' plot(1, xlim=c(0,4), ylim=c(0,2), type="n",
#'      xlab="", ylab="", main="Penguin Comparison")
#' draw_penguin(1, 1, species="Adelie", sex="male", id="1", size = 1)
#' draw_penguin(2, 1, species="Chinstrap", sex="female", id="2", size = 1)
#' draw_penguin(3, 1, species="Gentoo", sex="male", id="3", size = 1)
#'
#' # Missing measurements are shown as dashed outlines
#' plot(1, xlim=c(0,3), ylim=c(0,2), type="n",
#'      xlab="", ylab="", main="Missing values")
#' draw_penguin(1, 1, flipper_scale = NA, size = 1)
#' draw_penguin(2, 1, body_scale = NA, sex = NA, size = 1)
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
                         size = 0.6,
                         col = penguin_colors(),
                         lwd = 1.5,
                         cex.id = 0.8) {

  if (is.na(x) || is.na(y)) return(invisible(NULL))

  # A glyph with all scales = 1 is 1.4 glyph units high, feet to top of head
  pen <- glyph_pen(x, y, unit = size / 1.4)

  body_col <- species_col(species, col)
  bill_color <- "lightblue"
  foot_color <- "black"

  # Missing measurements: draw at the neutral scale, as a dashed outline with no fill
  miss <- c(bill    = is.na(bill_len_scale) || is.na(bill_dep_scale),
            flipper = is.na(flipper_scale),
            body    = is.na(body_scale))
  if (is.na(bill_len_scale)) bill_len_scale <- 1
  if (is.na(bill_dep_scale)) bill_dep_scale <- 1
  if (is.na(flipper_scale))  flipper_scale <- 1
  if (is.na(body_scale))     body_scale <- 1
  fill <- function(part, color) if (miss[[part]]) NA else color
  lty  <- function(part) if (miss[[part]]) 2 else 1

  # Body: its area, rather than its width and height, is proportional to body_scale
  body_width <- 0.4 * sqrt(body_scale)
  body_height <- 0.5 * sqrt(body_scale)

  # Draw body (ellipse)
  pen$ellipse(0, 0, body_width, body_height,
              col = fill("body", body_col), border = "black",
              lwd = lwd, lty = lty("body"))

  # Draw belly (lighter ellipse)
  if (!miss[["body"]]) {
    pen$ellipse(0, -0.05, body_width * 0.6, body_height * 0.7 * 0.8,
                col = "white", border = NA)
  }

  # Draw head, the same size in all glyphs as a frame of reference for the bill and eyes
  head_radius <- 0.2
  head_y <- body_height + head_radius * 0.6
  pen$ellipse(0, head_y, head_radius,
              col = body_col, border = "black", lwd = lwd)

  # Draw bill, starting at the side of the head so that it is clear of the eyes
  bill_length <- 0.40 * bill_len_scale
  bill_depth  <- 0.20 * bill_dep_scale
  bill_x <- head_radius * 0.75
  bill_y <- head_y - head_radius * 0.15
  pen$polygon(bill_x + c(0, bill_length, bill_length, 0),
              bill_y + c(bill_depth/2, bill_depth/3, -bill_depth/3, -bill_depth/2),
              col = fill("bill", bill_color), border = "black",
              lwd = lwd, lty = lty("bill"))

  # Draw eyes (shape depends on sex)
  eye_x <- 0.07
  eye_y <- head_y + head_radius * 0.25
  eye_size <- 0.05

  for (side in c(-1, 1)) {
    if (is.na(sex)) {
      # Sex unknown: pupils only
    } else if (sex == "female") {
      # Rounder eyes for females
      pen$ellipse(side * eye_x, eye_y, eye_size,
                  col = "white", border = "black", lwd = lwd)
    } else {
      # More angular eyes for males
      pen$polygon(side * eye_x + eye_size * c(-1, 1, 1, -1),
                  eye_y + eye_size * c(-0.7, -0.7, 1, 1),
                  col = "white", border = "black", lwd = lwd)
    }
    # Draw pupils
    pen$ellipse(side * eye_x, eye_y, 0.015, col = "black", border = NA)
  }

  # Draw flippers
  flipper_length <- 0.35 * flipper_scale
  flipper_width <- 0.12
  # outline of a flipper pointing straight out from the side of the body ...
  flip_along  <- c(0, body_width*0.2 + flipper_length*0.5,
                   body_width*0.2 + flipper_length, body_width*0.1)
  flip_across <- c(0, -flipper_width, -flipper_width*0.5, flipper_width*0.3)
  # ... then angled downward, so the flippers of neighboring glyphs don't collide
  angle <- -35 * pi / 180
  flip_x <- body_width*0.7 + flip_along * cos(angle) - flip_across * sin(angle)
  flip_y <- 0.1 * body_height + flip_along * sin(angle) + flip_across * cos(angle)
  for (side in c(-1, 1)) {
    pen$polygon(side * flip_x, flip_y,
                col = fill("flipper", body_col), border = "black",
                lwd = lwd, lty = lty("flipper"))
  }

  # Draw feet
  foot_size <- 0.08
  for (side in c(-1, 1)) {
    pen$segments(side * 0.1, -body_height,
                 side * 0.15, -body_height - foot_size,
                 col = foot_color, lwd = 2)
    pen$segments(side * 0.15, -body_height - foot_size,
                 side * c(0.2, 0.1), -body_height - foot_size*0.7,
                 col = foot_color, lwd = 2)
  }

  # Label the glyph with id
  if (!is.null(id)) text(x, y, labels = id, cex = cex.id)

  invisible(NULL)
}
