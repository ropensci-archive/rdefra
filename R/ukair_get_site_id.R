#' Get site identification numbers for DEFRA stations
#'
#' @description Given the UK AIR ID (from [ukair_catalogue()]), this
#' function fetches the catalogue of monitoring stations from DEFRA's website.
#'
#' @param id_s An alphanumeric string (or vector of strings) containing the UK
#' AIR ID defined by DEFRA.
#'
#' @return A named vector containing the site id_s.
#'
#' @export
#'
#' @examples
#'  \dontrun{
#'  ukair_get_site_id("UKA00399")
#'  }
#'

ukair_get_site_id <- function(id_s) {

  id_s <- as.character(id_s)

  en_df <- t(sapply(id_s, ukair_get_site_id_internal))

  return(as.character(en_df))

}

#' Internal function to get site id_s for 1 DEFRA station
#'
#' @noRd
#'

ukair_get_site_id_internal <- function(uka_id) {

  resp <- ukair_api(url = ukair_url,
                    path = "networks/site-info",
                    query = list(uka_id = uka_id,
                                 search = "View+Site+Information",
                                 action = "site"))

  # download content
  page_content <- httr::content(resp, encoding = "UTF-8")

  # Extract tab row containing Easting and Northing
  page_tab <- xml2::xml_find_all(page_content, '//*[@id="g4"]/td[4]/a[4]')
  hrefs <- xml2::xml_attr(page_tab, "href")

  if (is.null(hrefs)) {

    site_id <- NA
    message("No ID available for the specified station")

  }else{

      site_id <- gsub("^.*\\=", "", hrefs)

  }

  if (length(as.list(site_id)) == 0) {

    site_id <- NA
    # if the siteID is unknown, a workaround is to search the cached catalogue.
    # BETTER SOLUTION IS NEEDED! THE SITEID CAN NO LONGER BE RETRIEVED BY THE
    # UK AIR SITE INFORMATION WEB PAGE.
    cached_station_catalogue <- rdefra::stations
    x <- cached_station_catalogue$SiteID[cached_station_catalogue$UK.AIR.ID == uka_id]
    if (!is.na(x)) site_id <- x
  }

  return(site_id)

}
