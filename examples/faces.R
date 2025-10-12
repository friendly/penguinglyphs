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
