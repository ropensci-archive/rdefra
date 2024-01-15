#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom curl has_internet
#' @importFrom httr GET content http_error set_config config
#' @importFrom utils read.csv
#' @importFrom xml2 xml_find_first xml_attr xml_find_all
#' @importFrom lubridate dmy_hms ymd
#' @importFrom tibble as_tibble
#' @importFrom dplyr bind_rows
#' @importFrom sf st_as_sf st_transform st_coordinates
## usethis namespace: end
NULL

#' List of all the DEFRA air quality monitoring stations with complete
#' coordinates
#'
#' @description This is the list of all the air quality monitoring stations ever
#' installed in the UK and operated by DEFRA networks (as per February 2016).
#' As the network expands, metadata for new stations will be added.
#'
#' @format A data frame with 6561 observations on the following 14 variables.
#' \describe{
#'   \item{\code{UK.AIR.ID}}{ID reference for monitoring stations}
#'   \item{\code{EU.Site.ID}}{EU.Site.ID}
#'   \item{\code{EMEP.Site.ID}}{EMEP.Site.ID}
#'   \item{\code{Site.Name}}{Site name}
#'   \item{\code{Environment.Type}}{a factor with levels \code{Background Rural}
#'   \code{Background Suburban} \code{Background Urban}
#'   \code{Industrial Suburban} \code{Industrial Unknown}
#'   \code{Industrial Urban} \code{Traffic Urban} \code{Unknown Unknown}}
#'   \item{\code{Zone}}{Zone}
#'   \item{\code{Start.Date}}{Start date}
#'   \item{\code{End.Date}}{End date}
#'   \item{\code{Latitude}}{Latitude (WGS 84)}
#'   \item{\code{Longitude}}{Longitude (WGS 84)}
#'   \item{\code{Northing}}{Northing coordinate (British National Grid)}
#'   \item{\code{Easting}}{Easting coordinate (British National Grid)}
#'   \item{\code{Altitude..m.}}{Altitude in metres above sea level}
#'   \item{\code{Networks}}{Monitoring Networks}
#'   \item{\code{AURN.Pollutants.Measured}}{Pollutant measured}
#'   \item{\code{Site.Description}}{Description of the site.}
#'   \item{\code{SiteID}}{Site ID, used to retrieve time series data.}
#' }
#'
#' @source \url{https://uk-air.defra.gov.uk/}
#' @examples
#' stations
"stations"
