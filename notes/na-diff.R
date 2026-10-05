data(penguins, package = "datasets")

peng1 <- na.omit(penguins)
peng2 <- tidyr::drop_na(penguins)

# why are rownames different"
outliers <- c(10, 35, 283)
peng1[outliers,]
peng2[outliers,]

# na.omit() retains the original row numbers from the dataset, 
# but drop_na() returns a tibble with reindexed row positions. 
