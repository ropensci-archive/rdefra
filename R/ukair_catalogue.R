#' Get DEFRA UK-AIR stations metadata
#'
#' @description This function fetches the catalogue of monitoring stations from
#' DEFRA's website.
#'
#' @param site_name This is the name of a specific site. By default this is left
#' blank to get info on all the available sites.
#' @param pollutant This is a number from 1 to 10. Default is 9999, which means
#' all the pollutants.
#' @param group_id This is the identification number of a group of stations.
#' Default is 9999 which means all available networks.
#' @param closed This is "true" to include closed stations, "false" otherwise.
#' @param country_id This is the identification number of the country, it can be
#' a number from 1 to 6. Default is 9999, which means all the countries.
#' @param region_id This is the identification number of the region. 1 =
#' Aberdeen City, etc. (for the full list see
#' \url{https://uk-air.defra.gov.uk/}). Default is 9999, which means all the
#' local authorities.
#'
#' @details
#' The argument \code{Pollutant} is defined based on the following convention:
#' \itemize{
#'  \item{1 = Ozone (O3)}
#'  \item{2 = Nitrogen oxides (NOx)}
#'  \item{3 = Carbon monoxide (CO)}
#'  \item{4 = Sulphur dioxide (SO2)}
#'  \item{5 = Particulate Matter (PM10)}
#'  \item{6 = Particulate Matter (PM2.5)}
#'  \item{7 = PAHs}
#'  \item{8 = Metals in PM10}
#'  \item{9 = Benzene}
#'  \item{10 = Black Carbon}
#' }
#'
#' The argument \code{group_id} is defined based on the following convention:
#' \itemize{
#'  \item{1 = UKEAP: Precip-Net}
#'  \item{2 = Air Quality Strategy Pollutants}
#'  \item{3 = Ammonia and Nitric Acid}
#'  \item{4 = Automatic Urban and Rural Monitoring Network (AURN)}
#'  \item{5 = Dioxins and Furans}
#'  \item{6 = Black Smoke & SO2}
#'  \item{7 = Automatic Hydrocarbon Network}
#'  \item{8 = Heavy Metals}
#'  \item{9 = Nitrogen Dioxide Diffusion Tube}
#'  \item{10 = PAH Andersen}
#'  \item{11 = Particle Size Composition}
#'  \item{12 = PCBs}
#'  \item{13 = TOMPs}
#'  \item{14 = Non-Automatic Hydrocarbon Network}
#'  \item{15 = 1,3-Butadiene Diffusion Tube}
#'  \item{16 = Black Carbon}
#'  \item{17 = Automatic Urban and Rural Monitoring Network (AURN)}
#'  \item{18 = Defra NO2 Diffusion Tube}
#'  \item{19 = PAH Digitel (solid phase)}
#'  \item{20 = PAH Digitel (solid+vapour)}
#'  \item{21 = PAH Deposition}
#'  \item{22 = Particle size and number}
#'  \item{23 = Rural Automatic Mercury network}
#'  \item{24 = Urban Sulphate}
#'  \item{25 = UKEAP: Rural NO2}
#'  \item{26 = Automatic Urban and Rural Monitoring Network (AURN)}
#'  \item{27 = UKEAP: National Ammonia Monitoring Network}
#'  \item{28 = UKEAP: Acid Gases & Aerosol Network}
#'  \item{29 = Particle Speciation (MARGA)}
#'  \item{30 = UKEAP: Historic Aerosol measurements}
#' }
#'
#' The argument \code{country_id} is defined based on the following convention:
#' \itemize{
#'  \item{1 = England}
#'  \item{2 = Wales}
#'  \item{3 = Scotland}
#'  \item{4 = Northern Ireland}
#'  \item{5 = Republic of Ireland}
#'  \item{6 = Channel Islands}
#'  }
#'
#' @return A dataframe listing stations and related information.
#'
#' @export
#'
#' @examples
#'  \dontrun{
#'  stations <- ukair_catalogue()
#'  }
#'

ukair_catalogue <- function(site_name = "",
                            pollutant = 9999,
                            group_id = 9999,
                            closed = "true",
                            country_id = 9999,
                            region_id = 9999){

  if (!(pollutant %in% 1:10 | pollutant == 9999)) {
    stop(paste("The parameter 'pollutant' is not set correctly,",
               "valid values are integers between 1 and 10 (see documentation)",
               "or 9999 (all pollutants)."))
  }

  if (!(group_id %in% 1:30 | group_id == 9999)) {
    stop(paste("The parameter 'group_id' is not set correctly, valid values",
               "are integers between 1 and 30 (see documentation) or 9999",
               "(all groups)."))
  }

  if (!(country_id %in% 1:6 | country_id == 9999)) {
    stop(paste("The parameter 'country_id' is not set correctly, valid values",
               "are integers between 1 and 6 (see documentation) or 9999 (all",
               "countries)."))
  }

  # Any NULL elements of the list supplied to the query paramater are
  # automatically dropped
  catalogue_fetch <- httr::GET(url = "http://uk-air.defra.gov.uk",
                               path = "networks/find-sites",
                               query = list(site_name = site_name,
                                            pollutant = pollutant,
                                            group_id = group_id,
                                            closed = closed,
                                            country_id = country_id,
                                            region_id = region_id,
                                            location_type = 9999,
                                            search = "Search+Network",
                                            view = "advanced",
                                            action = "results"))

  # download content
  catalogue_content <- httr::content(catalogue_fetch)

  # Extract csv link
  catalogue_csv_link <- xml2::xml_find_first(catalogue_content,
                                             "//*[contains(@class,'bCSV')]")
  catalogue_csv_link <- xml2::xml_attr(catalogue_csv_link, "href")

  if (!is.na(catalogue_csv_link)) {

    df <- utils::read.csv(catalogue_csv_link, stringsAsFactors = FALSE)

    # remove trailing and leading white spaces
    df <- data.frame(apply(df, 2, function(x) trimws(x)),
                     stringsAsFactors = FALSE)

    # Change the blank cells to NA
    # http://stackoverflow.com/questions/24172111/change-the-blank-cells-to-na
    df <- data.frame(apply(df, 2, function(x) gsub("^$|^ $", NA, x)),
                     stringsAsFactors = FALSE)

    df$Environment.Type[df$Environment.Type == "Not Available"] <- NA
    df$Start.Date[df$Start.Date == "Unavailable"] <- NA
    df$End.Date[df$End.Date == "Unavailable"] <- NA

    suppressWarnings(df[, "Start.Date"] <- lubridate::ymd(df[, "Start.Date"],
                                                     tz = "Europe/London"))

    suppressWarnings(df[, "End.Date"] <- lubridate::ymd(df[, "End.Date"],
                                                   tz = "Europe/London"))

    # Convert to numeric
    df[, "Northing"] <- as.numeric(as.character(df[, "Northing"]))
    df[, "Easting"] <- as.numeric(as.character(df[, "Easting"]))
    df[, "Latitude"] <- as.numeric(as.character(df[, "Latitude"]))
    df[, "Longitude"] <- as.numeric(as.character(df[, "Longitude"]))
    df[, "Altitude..m."] <- as.numeric(as.character(df[, "Altitude..m."]))

    # Remove Site.Description column as it contains non-ASCII characters
    df <- df[, -which(names(df) %in% c("Site.Description"))]

    return(tibble::as_tibble(df))

  }

}
