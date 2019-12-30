context("Metadata")

test_that("DEFRA server should be running", {

  site_name <- ""
  pollutant <- 9999
  group_id <- 9999
  closed <- "true"
  country_id <- 9999
  region_id <- 9999
  location_type <- 9999

  catalogue_fetch <- httr::GET(url = "http://uk-air.defra.gov.uk",
                               path = "networks/find-sites",
                               query = list(site_name = site_name,
                                            pollutant = pollutant,
                                            group_id = group_id,
                                            closed = closed,
                                            country_id = country_id,
                                            region_id = region_id,
                                            location_type = location_type,
                                            search = "Search+Network",
                                            view = "advanced",
                                            action = "results"))

  # URL: catalogue_fetch[[1]]

  # download html
  expect_that(httr::http_error(catalogue_fetch), equals(FALSE))

  closeAllConnections()

})

test_that("Up-to-date metadata catalogue should have at least 6608 stations.", {

  x <- ukair_catalogue()

  expect_true(all(dim(x) >= c(6608, 15)))

  closeAllConnections()

})

test_that("Find site identification number from the UK AIR ID string.", {

  uka_id <- "UKA00399"
  x <- ukair_get_site_id(uka_id)

  expect_that(x == "ABD", equals(TRUE))

  expect_that(is.na(ukair_get_site_id("UKA11248")), equals(TRUE))

  closeAllConnections()

})

test_that("Find easting and northing coordinates of site UKA12536.", {

  uka_id <- "UKA12536"

  x <- ukair_get_coordinates(uka_id)

  expect_that(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                "Latitude", "Longitude")), equals(TRUE))
  expect_that(x$Longitude == -0.416786, equals(TRUE))
  expect_that(x$Latitude == 51.704266, equals(TRUE))

  closeAllConnections()

})

test_that("Find easting and northing coordinates of site UKA15910.", {

  uka_id <- "UKA15910"

  x <- ukair_get_coordinates(uka_id)

  expect_that(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                  "Latitude", "Longitude")), equals(TRUE))
  expect_that(x$Longitude == -0.743709, equals(TRUE))
  expect_that(x$Latitude == 51.322247, equals(TRUE))

  closeAllConnections()

})

test_that("Find easting and northing coordinates of multiple sites.", {

  IDs <- c("UKA15910", "UKA15956", "UKA16663", "UKA16097")
  x <- ukair_get_coordinates(IDs)

  expect_that(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                  "Latitude", "Longitude")), equals(TRUE))
  expect_that(all(x$Longitude == c(-0.743709, -0.63089,
                                   -0.727552, 0.272107)),
              equals(TRUE))
  expect_that(all(x$Latitude == c(51.322247, 51.320938,
                                  51.329932, 51.192638)),
              equals(TRUE))

  closeAllConnections()

})

test_that("Infill missing coordinates from data frame.", {

  stations <- structure(list(UK.AIR.ID = c("UKA15910", "UKA15956", "UKA16663",
                                           "UKA16097", "UKA12536", "UKA12949",
                                           "UKA12399", "UKA13340", "UKA13341",
                                           "UKA15369"),
                             Latitude = c(51.322247, 51.320938, 51.329932,
                                          51.192638, NA, NA, NA, 51.712306,
                                          51.712431, 51.711461),
                             Longitude = c(-0.743709, -0.63089, -0.727552,
                                           0.272107, NA, NA, NA, -3.447338,
                                           -3.43721, -3.442969)),
                        .Names = c("UK.AIR.ID", "Latitude", "Longitude"),
                        row.names = c(NA, -10L),
                        class = c("tbl_df", "tbl", "data.frame"))
  x <- ukair_get_coordinates(stations)
  expect_equal(round(x$Latitude[which(is.na(stations$Latitude))], 3),
               c(51.704, 51.695, 51.648))
  expect_equal(round(x$Longitude[which(is.na(stations$Longitude))], 3),
               c(-0.417, -3.225, -3.135))

  closeAllConnections()

})
