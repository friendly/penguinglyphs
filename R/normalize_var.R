#' Normalize a variable to a specified range
#' 
#' A utility function for use in creating glyphs for variables, designed for the penguinglyphs package.
#'
#' @param x Numeric vector to normalize
#' @param new_min New minimum value (default 0.5)
#' @param new_max New maximum value (default 1.5)
#' @return Normalized numeric vector with values scaled to \code{[new_min, new_max]}
#' @examples
#' normalize_var(c(1, 2, 3, 4, 5))
#' normalize_var(c(10, 20, 30), new_min = 0, new_max = 1)
#' @export
normalize_var <- function(x, new_min = 0.5, new_max = 1.5) {
  if (all(is.na(x))) return(rep(1, length(x)))
  x_range <- range(x, na.rm = TRUE)
  if (x_range[1] == x_range[2]) return(rep(mean(c(new_min, new_max)), length(x)))
  (x - x_range[1]) / (x_range[2] - x_range[1]) * (new_max - new_min) + new_min
}
