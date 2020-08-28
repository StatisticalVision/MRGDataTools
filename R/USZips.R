#' Zip Codes and Geo-Coordinates for the US.
#'
#' A dataset of US zip codes, latitudes, and longitudes and city or town names.
#'
#' @format A data.table with containing 44,338 zip and the following variables:
#' \describe{
#'   \item{city}{Name of a city in that zipcode}
#'   \item{state}{Name of the stat for that zipcode}
#'   \item{lon}{Longitude of the center of that zipcode}
#'   \item{lat}{Latitude of the center of that zipcode}
#'   \item{geo.address}{The address used to obtain the lat and lon from google maps.}
#'   \item{index}{An index variable}
#' }
"AllZips"
