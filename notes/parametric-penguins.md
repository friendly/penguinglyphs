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

## Fixes


* The current version of `draw_penguin()` in `R/draw_penguin.R` is too representational, in that the penguin body
size totally dominates the visual display. Please  design an alternative version `draw_penguin_cartoon()` based on
a cartoon penguin with a much smaller head and larger bill and flippers as in the image under `notes/penguin-cartoon.jpg`.

Claude:

**Key Differences from Realistic Version**:

* Smaller Head (30% reduction): Head is now 0.5 * body_scale instead of the typical 0.65, making it less massive
* More Prominent Bill (60% larger): Bill extends 0.8 * head_size vs typical 0.5, making bill measurements more visible
* Exaggerated Flippers (40% larger): Flippers are 0.85 * body_height vs typical 0.6, giving flipper length better visual representation
* Compact Body: Body proportions are adjusted to be wider and less tall, creating a more cartoon-like appearance
* Simplified Features: Cleaner shapes and bolder outlines for clarity

Perfect! This is a great reference image. I can see the cartoon style you're going for - these penguins have:

Very small, compact bodies (almost circular/oval)
Large white belly ovals that take up most of the body
Prominent, pointed bills that are quite substantial relative to head size
Large, wing-like flippers that extend outward (almost star-shaped)
Small orange/red feet
Simple, minimalist design with clean outlines

The key insight from this drawing is that the body should be much more geometric and simplified - almost like a bowling pin or teardrop shape rather than a realistic penguin body. The flippers are more like outstretched wings/arms, and the whole design is very balanced visually.

`notes/penguin-cartoon2.R`:
I've updated the draw_penguin_cartoon() function to better match the style in your reference image. The key changes are:
Major Style Updates:

Much smaller, more compact body - narrower and shorter (1.0 × 1.3 instead of 1.2 × 1.6)
Tiny head - only 0.35 × base_size (was 0.5)
Very prominent bill - extends 1.0 × head_size, making it very noticeable
Large, wing-like flippers - simplified triangular shapes that extend outward, equal to body height
Big white belly oval - takes up 85% of body height
Simple triangular feet - more cartoon-like and less detailed
More upright posture - body centered at y position

The design now follows the geometric, minimalist approach of your sketch where the penguin is essentially:

A small circle (head) with big pointed bill
An oval body with large white belly
Two simple triangular wings extending outward
Two small triangular feet

This should make the bill and flipper measurements much more visually prominent while reducing the dominance of body mass. The clean, simple shapes should also make patterns easier to spot across multiple glyphs!



## Hex logo for the package

I've created a hexagon logo for the penguinglyphs package! The design features:

Gray hexagon background - standard R package hex sticker format
Cartoon penguin in the upper portion, matching the style from your reference image with:

Blue body with white belly oval
Small head with prominent orange bill
Wing-like flippers extending outward
Simple orange feet


"penguin" and "glyphs" text on two lines in the center below the penguin

The penguin is rendered in a simplified style that captures the essence of your hand-drawn reference. The colors match the Chinstrap species from your package (the purple/blue tone).

That's pretty good, but make the penguin bill a bit longer and thicker. 

* Longer and thicker bill - extends from 107 to 128 (was 122) and is thicker vertically (53-57 instead of 55-56)
* Added descriptive text - "penguinglyphs package for R" is now positioned along the bottom-right edge of the hexagon, rotated 60 degrees to follow the hexagon border

The bill is now much more prominent and the package description follows the standard hex sticker format with text along the edge!


