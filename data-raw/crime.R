# Crime rates in the US states, used by Nathan Yau to illustrate Chernoff faces
# Source: https://flowingdata.com/2010/08/31/how-to-visualize-data-with-cartoonish-faces/
#
# Yau got the data from Infochimps,
#   http://infochimps.org/datasets/crime-rates-by-state-2004-and-2005-and-by-type-2005-cleaned-up-v--2
# which took it from Table 301 of the 2008 Statistical Abstract of the United States.
# He cleaned that file further, to include only the rates by type of crime.

# The original location of the file,
#   http://datasets.flowingdata.com/crimeRatesByState-formatted.csv
# now gives "403 Forbidden" (Oct. 2026), so use the copy in the Internet Archive.
# `id_` in the URL gives the file as archived, without the Wayback Machine banner.
url <- paste0("https://web.archive.org/web/20250821062923id_/",
              "http://datasets.flowingdata.com/crimeRatesByState-formatted.csv")

# keep a copy of the file as downloaded
csv <- "data-raw/crimeRatesByState-formatted.csv"
if (!file.exists(csv)) download.file(url, csv, mode = "wb")

crime <- read.csv(csv)

# state names in the file have trailing blanks, e.g., "Alabama "
crime$state <- trimws(crime$state)
str(crime)

save(crime, file = "data/crime.rda", compress = "bzip2", version = 2)
