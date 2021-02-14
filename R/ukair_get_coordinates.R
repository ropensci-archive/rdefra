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
  
  df <- data.frame(t(sapply(ids, ukair_get_coordinates_internal)))
  df$Latitude <- NA
  df$Longitude <- NA

  df_extended <- en2latlon(df)
  df <- cbind("UK.AIR.ID" = ids, df_extended)

  # return a data.frame with coordinates
  return(tibble::as_tibble(df))

}

#' @export
ukair_get_coordinates.data.frame <- function(ids){

  if ("Northing" %in% names(ids) & "Easting" %in% names(ids)){

    # We expect to infill only missing coordinates
    nrows <- which(is.na(ids$Northing) | is.na(ids$Easting))

  }else{

    # otherwise, we force to extract coordinates for all the given stations
    ids$Northing <- NA
    ids$Easting <- NA
    nrows <- seq(1, dim(ids)[1])

  }

  # This is the list of all the relevant ids
  id_s <- as.character(ids$UK.AIR.ID[nrows])

  df_extended <- data.frame(t(sapply(id_s, ukair_get_coordinates_internal)))

  ids$Northing[nrows] <- df_extended$Northing
  ids$Easting[nrows] <- df_extended$Easting
  ids$Northing <- as.numeric(ids$Northing)
  ids$Easting <- as.numeric(ids$Easting)

  df0 <- en2latlon(ids)
  df <- latlon2en(df0)

  return(tibble::as_tibble(df))

}

#' Get Easting and Northing coordinates from DEFRA for 1 station
#'
#' @noRd
#'

ukair_get_coordinates_internal <- function(uka_id){

  page_fetch <- httr::GET(url = "http://uk-air.defra.gov.uk",
                          path = "networks/site-info",
                          query = list(uka_id = uka_id))

  # download content
  page_content <- httr::content(page_fetch, encoding = "UTF-8")

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

#' Convert Easting and Northing to Latitude and Longitude
#'
#' @noRd
#'

en2latlon <- function(df){

  # If there are missing Lat/Lon but known Easting and Northing,
  # then transform Easting and Northing to Latitude and Longitude
  lonlat_na <- which(is.na(df$Longitude) | is.na(df$Latitude))
  en_na <- which(is.na(df$Easting) | is.na(df$Northing))
  rows2transform <- setdiff(lonlat_na, en_na)

  if (length(rows2transform) > 0){

    df_no_nas <- df[rows2transform,]
    # First step: define spatial points
    sp::coordinates(df_no_nas) <- ~Easting + Northing
    sp::proj4string(df_no_nas) <- sp::CRS("+init=epsg:27700")
    # then, convert coordinates from British National Grid to WGS84
    latlon <- round(sp::spTransform(df_no_nas,
                                    sp::CRS("+init=epsg:4326"))@coords, 6)
    pt <- data.frame(latlon)
    names(pt) <- c("Longitude", "Latitude")
    df$Latitude[rows2transform] <- pt$Latitude
    df$Longitude[rows2transform] <- pt$Longitude
    
  }

  return(df)

}

#' Convert Latitude and Longitude to Easting and Northing
#'
#' @noRd
#'

latlon2en <- function(df){
  
  # If there are missing Lat/Lon but known Easting and Northing,
  # then transform Easting and Northing to Latitude and Longitude
  lonlat_na <- which(is.na(df$Longitude) | is.na(df$Latitude))
  en_na <- which(is.na(df$Easting) | is.na(df$Northing))
  rows2transform <- en_na[which(!(en_na %in% lonlat_na))]
  
  if (length(rows2transform) > 0){
    
    df_no_nas <- df[rows2transform,]
    # First step: define spatial points
    sp::coordinates(df_no_nas) <- ~Longitude + Latitude
    sp::proj4string(df_no_nas) <- sp::CRS("+init=epsg:4326")
    # then, convert coordinates from British National Grid to WGS84
    latlon <- round(sp::spTransform(df_no_nas,
                                    sp::CRS("+init=epsg:27700"))@coords, 6)
    pt <- data.frame(latlon)
    names(pt) <- c("Easting", "Northing")
    df$Northing[rows2transform] <- pt$Northing
    df$Easting[rows2transform] <- pt$Easting
    
  }
  
  
  return(df)
  
}