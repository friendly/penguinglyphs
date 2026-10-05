#' Crime rates in the US states
#'
#' Rates of seven types of serious crime in the United States in 2005, for each of the 50 states
#' and the District of Columbia, together with the rates for the country as a whole.
#' The rates are the numbers of offenses per 100,000 population.
#' Nathan Yau used these data to illustrate Chernoff faces, drawn with `aplpack::faces()`.
#'
#' @format A data frame with 52 observations on the following 8 variables.
#' \describe{
#'   \item{`state`}{name of the state, a character vector. The first row,
#'      `"United States"`, gives the national rates.}
#'   \item{`murder`}{rate of murder}
#'   \item{`forcible_rape`}{rate of forcible rape}
#'   \item{`robbery`}{rate of robbery}
#'   \item{`aggravated_assault`}{rate of aggravated assault}
#'   \item{`burglary`}{rate of burglary}
#'   \item{`larceny_theft`}{rate of larceny and theft}
#'   \item{`motor_vehicle_theft`}{rate of motor vehicle theft}
#' }
#'
#' @details The data are from Table 301, "Crime Rates by State, 2004 and 2005, and by Type, 2005",
#' of the *Statistical Abstract of the United States: 2008*. Yau obtained a version of this
#' table from Infochimps, and reduced it to the rates by type of crime.
#'
#' The state names in his file have trailing blanks, which have been removed here.
#'
#' @source Nathan Yau (2010), "How to visualize data with cartoonish faces ala Chernoff",
#'   <https://flowingdata.com/2010/08/31/how-to-visualize-data-with-cartoonish-faces/>.
#'   The data file was `http://datasets.flowingdata.com/crimeRatesByState-formatted.csv`.
#'
#'   Infochimps, "Crime Rates by State, 2004 and 2005, and by Type, 2005 (cleaned up)",
#'   `http://infochimps.org/datasets/crime-rates-by-state-2004-and-2005-and-by-type-2005-cleaned-up-v--2`
#'
#'   U.S. Census Bureau (2007), *Statistical Abstract of the United States: 2008*, Table 301.
#'
#' @examples
#' data(crime)
#' str(crime)
#'
#' # the states with the highest murder rates
#' head(crime[order(-crime$murder), 1:5])
#'
#' # Chernoff faces, as in the source
#' if (requireNamespace("aplpack", quietly = TRUE)) {
#'   aplpack::faces(crime[, 2:8], labels = crime$state, cex = 1)
#' }
#'
#' @keywords datasets
"crime"
