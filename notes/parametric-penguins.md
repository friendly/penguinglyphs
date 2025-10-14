# Parametric Penguins

I have an idea to develop R functions that would allow me to draw schematic images of
Penquins, sort of in the style of Chernoff Faces, but where the features represented
would be those related to the R `penguins` dataset.

These are primarily the quantitative ones
"bill_len", "bill_dep",  "flipper_len", "body_mass". These should be used to 
draw a representation of a penguin with the size of each feature mapped to the
length and depth of the bill, length of flippers, and size of the body.
There are also several categorical variables, e.g., "species" and "sex" that could
be mapped to other visual attributes.

Can you create some R functions that would map an observation of a penguin with values
of these variables into something that can be drawn using R graphics?


I see one general change you can make to this now. You assumed the dataset `penguins`
in the `palmerpenguins` package.  But the current version in R 4.5 is `penguins` in the `datasets` package.
The variable names for the quantitivative variables are:  "bill_len"    "bill_dep"    "flipper_len" "body_mass" 
Please make these changes and give me the revised complete code.

* Code from Claude 
  - generalize to allow other variables to be selected for features
  - make into a package from current source at https://www.dropbox.com/scl/fi/kryqistwb2psurr1fp2gy/penguin-glyphs.R?rlkey=zgdu770dj3qp61a571z545to8&dl=0
 -> Making the package:  https://claude.ai/chat/e955781e-6cd2-4037-942b-da18d05665fb


* Penguin line-ups, e.g., find outliers in a collection
  - but also as a test of the visual encoding of penguin features as glyphs

* as follow-up, represent the penguins by Chernoff faces.

## penguinglyphs package

The `penguinglyphs` package is now on GitHub, https://github.com/friendly/penguinglyphs

**TODO**

* The current version of `draw_penguin()` in `R/draw_penguin.R` is too representational, in that the penguin body
size totally dominates the visual display. Design an alternative version `draw_penguin_cartoon()` based on
a cartoon penguin with a much smaller head and larger bill and flippers as in the image under `notes/penguin-cartoon.jpg`.

* Make a hex logo for the package




