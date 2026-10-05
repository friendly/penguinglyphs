#' Normalize a variable to a specified range
#'
#' A utility function for use in creating glyphs for variables, designed for the penguinglyphs package.
#'
#' @param x Numeric vector to normalize
#' @param new_min New minimum value (default 0.5)
#' @param new_max New maximum value (default 1.5)
#' @param from Range of values mapped onto `[new_min, new_max]`. The default, `NULL`,
#'   uses the range of `x`. Supply a fixed range to scale different subsets of a
#'   dataset consistently; values of `x` outside it are extrapolated.
#' @return Normalized numeric vector with values scaled to `[new_min, new_max]`.
#'   Missing values remain `NA`.
#' @examples
#' normalize_var(c(1, 2, 3, 4, 5))
#' normalize_var(c(10, 20, 30), new_min = 0, new_max = 1)
#'
#' # the same values, scaled relative to a wider range
#' normalize_var(c(10, 20, 30), new_min = 0, new_max = 1, from = c(0, 100))
#' @export
normalize_var <- function(x, new_min = 0.5, new_max = 1.5, from = NULL) {
  if (is.null(from)) {
    if (all(is.na(x))) return(rep(NA_real_, length(x)))
    from <- range(x, na.rm = TRUE)
  }
  if (from[1] == from[2]) {
    return(ifelse(is.na(x), NA_real_, mean(c(new_min, new_max))))
  }
  (x - from[1]) / (from[2] - from[1]) * (new_max - new_min) + new_min
}
