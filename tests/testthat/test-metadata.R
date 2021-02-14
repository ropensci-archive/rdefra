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
  expect_equal(httr::http_error(catalogue_fetch), FALSE)

  closeAllConnections()

})

test_that("Up-to-date metadata catalogue should have at least 6610 stations.", {

  x <- ukair_catalogue()

  expect_true("data.frame" %in% class(x))

  closeAllConnections()

})

test_that("Find site identification number from the UK AIR ID string.", {

  uka_id <- "UKA00399"
  x <- ukair_get_site_id(uka_id)

  expect_true(x == "ABD")

  expect_true(is.na(ukair_get_site_id("UKA11248")))

})

test_that("Find easting and northing coordinates of site UKA12536.", {

  uka_id <- "UKA12536"

  x <- ukair_get_coordinates(uka_id)

  expect_true(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                  "Latitude", "Longitude")))
  expect_true(round(x$Longitude, 1) == -0.4)
  expect_true(round(x$Latitude, 1) == 51.7)

})

test_that("Find easting and northing coordinates of site UKA15910.", {

  uka_id <- "UKA15910"

  x <- ukair_get_coordinates(uka_id)

  expect_true(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                  "Latitude", "Longitude")))
  expect_true(round(x$Longitude, 1) == -0.7)
  expect_true(round(x$Latitude, 1) == 51.3)

})

test_that("Find easting and northing coordinates of multiple sites.", {

  IDs <- c("UKA15910", "UKA15956", "UKA16663", "UKA16097")
  x <- ukair_get_coordinates(IDs)

  expect_true(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                  "Latitude", "Longitude")))
  expect_true(all(round(x$Longitude, 1) == c(-0.7, -0.6, -0.7, 0.3)))
  expect_true(all(round(x$Latitude, 1) == c(51.3, 51.3, 51.3, 51.2)))

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
  expect_equal(round(x$Latitude[which(is.na(stations$Latitude))], 1),
               c(51.7, 51.7, 51.6))
  expect_equal(round(x$Longitude[which(is.na(stations$Longitude))], 1),
               c(-0.4, -3.2, -3.1))

})
