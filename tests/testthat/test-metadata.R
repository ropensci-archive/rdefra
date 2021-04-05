context("Metadata")

test_that("Catalogue should be a data.frame.", {

  x <- try(ukair_catalogue(), silent = TRUE)
  
  if ("try-error" %in% class(x) | is.null(class(x))){
    skip()
  }else{
    expect_true("data.frame" %in% class(x))
    closeAllConnections()
  }

})

test_that("Find site identification number from the UK AIR ID string.", {

  x <- try(ukair_get_site_id("UKA00399"), silent = TRUE)
  
  if ("try-error" %in% class(x)){
    skip()
  }else{
    expect_true(x == "ABD")
    expect_true(is.na(ukair_get_site_id("UKA11248")))
  }

})

test_that("Find easting and northing coordinates of site UKA12536.", {
  
  x <- try(ukair_get_coordinates("UKA12536"), silent = TRUE)
  
  if ("try-error" %in% class(x)){
    skip()
  }else{
    expect_true(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                    "Latitude", "Longitude")))
    expect_true(round(x$Longitude, 1) == -0.4)
    expect_true(round(x$Latitude, 1) == 51.7)
  }

})

test_that("Find easting and northing coordinates of site UKA15910.", {

  x <- try(ukair_get_coordinates("UKA15910"), silent = TRUE)
  
  if ("try-error" %in% class(x)){
    skip()
  }else{
    expect_true(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                    "Latitude", "Longitude")))
    expect_true(round(x$Longitude, 1) == -0.7)
    expect_true(round(x$Latitude, 1) == 51.3)
  }

})

test_that("Find easting and northing coordinates of multiple sites.", {

  IDs <- c("UKA15910", "UKA15956", "UKA16663", "UKA16097")
  x <- try(ukair_get_coordinates(IDs), silent = TRUE)
  
  if ("try-error" %in% class(x)){
    skip()
  }else{
    expect_true(all(names(x) %in% c("UK.AIR.ID", "Easting", "Northing",
                                    "Latitude", "Longitude")))
    expect_true(all(round(x$Longitude, 1) == c(-0.7, -0.6, -0.7, 0.3)))
    expect_true(all(round(x$Latitude, 1) == c(51.3, 51.3, 51.3, 51.2)))
  }

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
  x <- try(ukair_get_coordinates(stations), silent = TRUE)
  
  if ("try-error" %in% class(x)){
    skip()
  }else{
    expect_equal(round(x$Latitude[which(is.na(stations$Latitude))], 1),
                 c(51.7, 51.7, 51.6))
    expect_equal(round(x$Longitude[which(is.na(stations$Longitude))], 1),
                 c(-0.4, -3.2, -3.1))
  }

})
