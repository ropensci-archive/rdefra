context("Data")

test_that("Hourly data for station ABD/2014 should be available", {

  site_id <- "ABD"
  years <- 2014

  rootURL <- "https://uk-air.defra.gov.uk/data_files/site_data/"
  myURL <- paste(rootURL, site_id, "_", years, ".csv", sep = "")

  expect_that(httr::http_error(myURL), equals(FALSE))

  closeAllConnections()

})

test_that("Hourly data for station BTR3 should be available", {

  site_id <- "BTR3"
  years <- 2012:2016

  rootURL <- "https://uk-air.defra.gov.uk/data_files/site_data/"
  myURL <- paste(rootURL, site_id, "_", years, ".csv", sep = "")

  con.url <- try(url(myURL[[1]]))

  expect_that(inherits(con.url, "try-error"), equals(FALSE))
  expect_that(length(myURL), equals(5))

  closeAllConnections()

})

test_that("Metadata should be in the right format", {

  site_id <- "ABD"
  years <- 2000:2014

  x <- ukair_get_hourly_data(site_id, years)

  y <- attributes(x)$units

  expect_that("data.frame" %in% class(y), equals(TRUE))
  expect_that(all(names(y) == c("variable", "unit", "year")), equals(TRUE))

})

test_that("Data should be in the right format", {

  site_id <- "ABD"
  years <- 2014

  x <- ukair_get_hourly_data(site_id, years)

  expect_that(all(names(x)[1:2] == c("datetime", "SiteID")), equals(TRUE))

  closeAllConnections()

})

test_that("Try and retrieve hourly data", {

  skip_on_cran()

  x <- ukair_get_hourly_data(site_id = "ABD", years = "2014")

  expect_true(dim(x)[1] >= 8760)

  expect_equal(x$datetime[1],
               structure(1388538000, class = c("POSIXct", "POSIXt"),
                         tzone = "UTC"))
  expect_equal(x$SiteID[1], structure(1L, .Label = "ABD", class = "factor"))
  expect_equal(x$PM.sub.10..sub..particulate.matter..Hourly.measured.[1], 16.1)
  expect_equal(x$Nitric.oxide[1], 1.6402)
  expect_equal(x$Nitrogen.dioxide[1], 11.28311)
  expect_equal(x$Nitrogen.oxides.as.nitrogen.dioxide[1], 13.79805)
  expect_equal(x$Non.volatile.PM.sub.10..sub...Hourly.measured.[1], 15.1)
  expect_equal(x$Non.volatile.PM.sub.2.5..sub...Hourly.measured.[1], 7.3)
  expect_equal(x$Ozone[1], 54.94827)
  expect_equal(x$PM.sub.2.5..sub..particulate.matter..Hourly.measured.[1], 9.2)
  expect_equal(x$Volatile.PM.sub.10..sub...Hourly.measured.[1], 1)
  expect_equal(x$Volatile.PM.sub.2.5..sub...Hourly.measured.[1], 1.9)

  closeAllConnections()

})
