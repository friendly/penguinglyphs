# Normalize a variable to a specified range

A utility function for use in creating glyphs for variables, designed
for the penguinglyphs package.

## Usage

``` r
normalize_var(x, new_min = 0.5, new_max = 1.5, from = NULL)
```

## Arguments

- x:

  Numeric vector to normalize

- new_min:

  New minimum value (default 0.5)

- new_max:

  New maximum value (default 1.5)

- from:

  Range of values mapped onto `[new_min, new_max]`. The default, `NULL`,
  uses the range of `x`. Supply a fixed range to scale different subsets
  of a dataset consistently; values of `x` outside it are extrapolated.

## Value

Normalized numeric vector with values scaled to `[new_min, new_max]`.
Missing values remain `NA`.

## Examples

``` r
normalize_var(c(1, 2, 3, 4, 5))
#> [1] 0.50 0.75 1.00 1.25 1.50
normalize_var(c(10, 20, 30), new_min = 0, new_max = 1)
#> [1] 0.0 0.5 1.0

# the same values, scaled relative to a wider range
normalize_var(c(10, 20, 30), new_min = 0, new_max = 1, from = c(0, 100))
#> [1] 0.1 0.2 0.3
```
