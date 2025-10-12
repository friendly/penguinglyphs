<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
![GitHub last commit](https://img.shields.io/github/last-commit/friendly/penguinglyphs/master)
<!-- badges: end -->⁠


# penguinglyphs

A system for visualizing multivariate penguin data as schematic penguin drawings. Physical measurements are mapped to visual features of penguin glyphs, making patterns in the data immediately apparent.

## Installation

You can install the development version from GitHub:

```r
# install.packages("devtools")
devtools::install_github("friendly/penguinglyphs")
```

## Visual Mappings

The package maps penguin measurements to visual features:

- **Bill length** → horizontal extent of the bill
- **Bill depth** → vertical thickness of the bill  
- **Flipper length** → length of the flippers
- **Body mass** → overall body size (affects body, head, all proportions)
- **Species** → body color
  - Adelie: Orange (#FF6B35)
  - Chinstrap: Purple (#9A78B8)
  - Gentoo: Green (#73C05B)
- **Sex** → eye shape (angular for males, round for females)

## Usage

### Basic Example

```r
library(penguinglyphs)

# Load penguin data
data(penguins, package = "datasets")

# Visualize first 20 penguins
penguin_glyphs(head(penguins, 20), main = "Palmer Penguins")
```

### Drawing Individual Penguins

```r
# Create plot area
plot(1, xlim=c(0,2), ylim=c(0,2), type="n", asp=1, 
     xlab="", ylab="", main="Custom Penguin")

# Draw a penguin with custom characteristics
draw_penguin(1, 1, 
             bill_len_scale = 1.2, 
             body_scale = 1.4, 
             species = "Gentoo", 
             sex = "female")
```

### Advanced Examples

```r
# Examine specific outliers
outliers <- c(10, 35, 283)
penguin_glyphs(penguins[outliers,], main = "Notable Penguins")

# Create a lineup for visual inference
set.seed(42)
cast <- c(sample(1:nrow(penguins), size = 17), outliers)
lineup <- sample(cast, size = length(cast))
penguin_glyphs(penguins[lineup,], main = "Can you spot the outliers?")

# Customize legend placement
penguin_glyphs(penguins[1:20,], 
               legend = list(loc = "bottom", horiz = FALSE))
```

## Key Functions

- `penguin_glyphs()` - Creates a grid display of multiple penguins from a data frame
- `draw_penguin()` - Draws a single penguin at specified coordinates  
- `normalize_var()` - Helper function that scales variables to appropriate visual ranges

## Why Glyphs?

Glyph-based visualizations allow you to see patterns across multiple dimensions simultaneously. Larger penguins with longer flippers appear visibly different from smaller ones, and species differences are immediately apparent through color. This makes it easy to spot outliers, clusters, and relationships that might be hidden in traditional plots.

## Related

This package is designed to work with the [Palmer Penguins](https://allisonhorst.github.io/palmerpenguins/) dataset, a popular alternative to the iris dataset for data exploration and visualization examples.

## License

MIT
