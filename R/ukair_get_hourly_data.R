#' Get hourly data for DEFRA stations
#'
#' @description This function fetches hourly data from DEFRA's air pollution
#' monitoring stations.
#'
#' @param site_id This is the ID of a specific site.
#' @param years Years for which data should be downloaded.
#'
#' @details The measurements are generally in \eqn{\mu g/m^3} (micrograms per
#' cubic metre). To check the units, refer to the table of attributes (see
#' example below). Please double check the units on the DEFRA website, as they
#' might change over time.
#'
#' @return A data.frame containing hourly pollution data.
#'
#' @export
#'
#' @examples
#'  \dontrun{
#'  # Get data for 1 year
#'  output <- ukair_get_hourly_data("ABD", 2014)
#'
#'  # Get data for multiple years
#'  output <- ukair_get_hourly_data("ABD", 2014:2016)
#'
#'  # Get units
#'  attributes(output)$units
#'
#'  }
#'

ukair_get_hourly_data <- function(site_id = NULL, years = NULL){

  if (is.null(site_id)) {

    stop("Please insert a valid ID.
         \nFor a list of valid IDs check the SiteID column in the cached
         catalogue: \n data(stations) \n na.omit(unique(stations$SiteID))")

  }

  if (is.null(years)) {

    stop("Please insert a valid year (or sequence of years).")

  }
  
  data <- lapply(X = years,
                 FUN = function(x) {ukair_get_hourly_data_internal(site_id, x)})

  # remove empties and bind data
  torm <- unlist(lapply(data, is.null))
  data <- data[!torm]
  new_data <- dplyr::bind_rows(data)

  if (is.null(new_data)) {

    stop(paste0("There are no data available for ",
                site_id, " in ", paste(years, collapse = "-"),
                ". Return NULL object."))

  }

  return(tibble::as_tibble(new_data))

}

#' Get hourly data for 1 DEFRA station
#'
#' @importFrom httr http_error
#' @importFrom utils read.csv
#' @importFrom lubridate dmy_hm
#'
#' @noRd
#'

ukair_get_hourly_data_internal <- function(site_id, a_year){
  
  resp <- ukair_api(url,
                    path = paste0("data_files/site_data/",
                                  site_id, "_", a_year, ".csv"),
                    query = "")
  
  df <- suppressWarnings(httr::content(resp, encoding = "UTF-8", skip = 4))

  if ("try-error" %in% class(df)){

    #new_df <- NULL
    message(paste("No data available for station", site_id))

  }else{

    datetime <- suppressWarnings(lubridate::dmy_hms(paste(df$Date, df$time),
                                                    tz = "Europe/London"))
    df_new <- cbind(datetime = datetime,
                    SiteID = site_id,
                    df[, which(!(names(df) %in% c("Date", "time")))])

    return(df_new)

  }

}
