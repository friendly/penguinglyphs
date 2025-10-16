# flowing data example

library(aplpack)
crime <- read.csv("http://datasets.flowingdata.com/crimeRatesByState-formatted.csv")
head(crime)

faces(crime[, 2:8], 
      labels = crime$state,
      cex = 1)



