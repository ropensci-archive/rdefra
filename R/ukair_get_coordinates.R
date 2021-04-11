#' Get Easting and Northing coordinates from DEFRA
#'
#' @description This function takes as input the UK AIR ID and returns Easting
#' and Northing coordinates (British National Grid, EPSG:27700).
#'
#' @param ids contains the station identification code defined by DEFRA. It can
#' be: a) an alphanumeric string, b) a vector of strings or c) a data frame. In
#' the latter case, the column containing the codes should be named "UK.AIR.ID",
#' all the other columns will be ignored.
#'
#' @details If the input is a data frame with some of the columns named
#' "UK.AIR.ID", "Northing" and "Easting", the function only infills missing
#' Northing/Easting values (if available on the relevant webpage).
#'
#' @return A data.frame containing at least five columns named "UK.AIR.ID",
#' "Easting", "Northing", "Latitude" and "Longitude".
#'
#' @export
#'
#' @examples
#'  \dontrun{
#'  # Case a: alphanumeric string
#'  ukair_get_coordinates("UKA12536")
#'
#'  # Case b: vector of strings
#'  ukair_get_coordinates(c("UKA15910", "UKA15956", "UKA16663", "UKA16097"))
#'
#'  # Case c: data frame
#'  ukair_get_coordinates(ukair_catalogue()[1:10,])
#'  }
#'

ukair_get_coordinates <- function(ids) {
  UseMethod("ukair_get_coordinates")
}

#' @export
ukair_get_coordinates.default <- function(ids) {
  stop("no available method for ", class(ids), call. = FALSE)
}

#' @export
ukair_get_coordinates.character <- function(ids){

  # Make sure there are no missing IDs
  rows_non_na <- which(!is.na(ids))

  df <- data.frame(t(sapply(ids[rows_non_na], ukair_get_coordinates_internal)))
  sfdf_en <- sf::st_as_sf(df, coords = c("Easting", "Northing"), crs = 27700)
  sfdf_latlon <- sf::st_transform(sfdf_en, crs = 4326)
  
  df_extended <- data.frame(UK.AIR.ID = ids,
                            Longitude = NA, Latitude = NA,
                            Easting = NA, Northing = NA)
  df_extended$Longitude[rows_non_na] <- sf::st_coordinates(sfdf_latlon)[, 1]
  df_extended$Latitude[rows_non_na] <- sf::st_coordinates(sfdf_latlon)[, 2]
  df_extended$Easting[rows_non_na] <- sf::st_coordinates(sfdf_en)[, 1]
  df_extended$Northing[rows_non_na] <- sf::st_coordinates(sfdf_en)[, 2]

  # return a data.frame with coordinates
  return(tibble::as_tibble(df_extended))

}

#' @export
ukair_get_coordinates.data.frame <- function(ids){
  
  if (!"Northing" %in% names(ids)) ids$Northing <- NA
  if (!"Easting" %in% names(ids)) ids$Easting <- NA
  if (!"Latitude" %in% names(ids)) ids$Latitude <- NA
  if (!"Longitude" %in% names(ids)) ids$Longitude <- NA
  
  # Which rows (stations) are the missing Easting/Northing coordinates?
  rows_missing_en <- which(is.na(ids$Northing) | is.na(ids$Easting))
  # For these rows, can we get Easting/Northing from Longitude/Latitude coordinates?
  rows_missing_en_with_ll <- rows_missing_en[which(!is.na(ids$Latitude[rows_missing_en]) | !is.na(ids$Longitude[rows_missing_en]))]
  
  if (length(rows_missing_en_with_ll) > 0) {
    # Transform coordinates
    sfdf_ll <- sf::st_as_sf(ids[rows_missing_en_with_ll,], coords = c("Longitude", "Latitude"), crs = 4326)
    sfdf_en <- sf::st_transform(sfdf_ll, crs = 27700)
    ids$Easting[rows_missing_en_with_ll] <- sf::st_coordinates(sfdf_en)[, 1]
    ids$Northing[rows_missing_en_with_ll] <- sf::st_coordinates(sfdf_en)[, 2]
  }
  
  # For the remaining coordinates we scrape the website
  rows_missing_en <- which(is.na(ids$Northing) | is.na(ids$Easting))
  
  # Get missing Easting/Northing from website, if available
  df_en <- data.frame(t(sapply(ids$UK.AIR.ID[rows_missing_en],
                               ukair_get_coordinates_internal)))
  if (any(!is.na(df_en$Easting))) {
    ids$Easting[rows_missing_en] <- df_en$Easting
  }
  if (any(!is.na(df_en$Northing))) {
    ids$Northing[rows_missing_en] <- df_en$Northing
  }
  # What rows are still missing Easting/Northing coordinates?
  # rows_missing_en <- which(is.na(ids$Northing) | is.na(ids$Easting))
  
  # Which rows (stations) are the missing Longitude/Latitude coordinates?
  rows_missing_ll <- which(is.na(ids$Latitude) | is.na(ids$Longitude))

  # Transform coordinates
  if (length(rows_missing_ll) > 0) {
    sfdf_en <- sf::st_as_sf(ids[rows_missing_ll, ],
                            coords = c("Easting", "Northing"), crs = 27700)
    sfdf_ll <- sf::st_transform(sfdf_en, crs = 4326)
    ids$Longitude[rows_missing_ll] <- sf::st_coordinates(sfdf_ll)[, 1]
    ids$Latitude[rows_missing_ll] <- sf::st_coordinates(sfdf_ll)[, 2]
  }
  
  # return a data.frame with coordinates
  return(tibble::as_tibble(ids))

}

#' Get Easting and Northing coordinates from DEFRA for 1 station
#'
#' @noRd
#'

ukair_get_coordinates_internal <- function(uka_id){
  
  resp <- ukair_api(url,
                    path = "networks/site-info",
                    query = list(uka_id = uka_id))

  # download content
  page_content <- httr::content(resp, encoding = "UTF-8")

  # Extract tab row containing Easting and Northing
  page_tab <- xml2::xml_find_all(page_content,
                                 "//*[contains(@id,'tab_info')]")[[2]]

  # extract and clean all the columns
  vals <- trimws(xml2::xml_text(page_tab))
  # Extract string containing easting and northing
  x <- strsplit(vals, "Easting/Northing:")[[1]][2]
  x <- strsplit(x, "Latitude/Longitude:")[[1]][1]
  # split string into easting and northing and remove heading/trailing spaces
  en <- gsub("^\\s+|\\s+$", "", unlist(strsplit(x, ",")))

  if (!is.null(en) & en[1] != "Not available" & en[2] != "Not available"){

    en_numeric <- c("Easting" = as.numeric(en[1]),
                    "Northing" = as.numeric(en[2]))

  }else{

    en_numeric <- c("Easting" = NA, "Northing" = NA)
    # message(paste("No coordinates available for station", uka_id))

  }

  return(en_numeric)

}
