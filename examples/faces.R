# Chernoff faces
# 
library(DescTools)

# try this out:
data(longley)
PlotFaces(longley[1:9,])


# do for penguins
data(penguins, package = "datasets")

# Visualize a random sample
set.seed(42)
sampled_rows <- sample(1:nrow(penguins), size = 20)

PlotFaces(penguins[sampled_rows, 3:6])

## ggChernoff package
## 
library(ggChernoff)
library(ggplot2)

p <- ggplot(iris) +
aes(Sepal.Width, Sepal.Length, fill = Species, brow = Sepal.Length) +
geom_chernoff()
p
p + scale_brow_continuous(midpoint = min)
p + scale_brow_continuous(range = c(-.5, 2))

plt <- ggplot(penguins[sampled_rows,],
              aes(x = body_mass, y = flipper_len,
                  fill = species, nose = bill_len)) +
  geom_chernoff()
                          

