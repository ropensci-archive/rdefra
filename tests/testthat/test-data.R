context("Data")

test_that("Try and retrieve hourly data for 1 year", {

  x <- try(ukair_get_hourly_data(site_id = "ABD", years = "2014"),
           silent = TRUE)

  if ("try-error" %in% class(x) | is.null(class(x))) {
    skip("Call to ukair_get_hourly_data for 1 year failed!")
  }else{
    expect_true(all(names(x)[1:2] == c("datetime", "SiteID")))
    expect_true(dim(x)[1] >= 8760)
    expect_equal(x$`PM<sub>10</sub> particulate matter (Hourly measured)`[1],
                 16.1)
    expect_equal(x$`Nitric oxide`[1], 1.6402)
    expect_equal(x$`Nitrogen dioxide`[1], 11.28311)
    expect_equal(x$`Nitrogen oxides as nitrogen dioxide`[1], 13.79805)
    expect_equal(x$`Non-volatile PM<sub>10</sub> (Hourly measured)`[1], 15.1)
    expect_equal(x$`Non-volatile PM<sub>2.5</sub> (Hourly measured)`[1], 7.3)
    expect_equal(x$Ozone[1], 54.94827)
    expect_equal(x$`PM<sub>2.5</sub> particulate matter (Hourly measured)`[1],
                 9.2)
    expect_equal(x$`Volatile PM<sub>10</sub> (Hourly measured)`[1], 1)
    expect_equal(x$`Volatile PM<sub>2.5</sub> (Hourly measured)`[1], 1.9)
  }

})

test_that("Try and retrieve hourly data for 2 years", {

  x <- try(ukair_get_hourly_data(site_id = "ABD", years = 2000:2001),
           silent = TRUE)

  if ("try-error" %in% class(x) | is.null(class(x))) {
    skip("Call to ukair_get_hourly_data for 2 years failed!")
  }else{
    expect_true("data.frame" %in% class(x))
    expect_true(all(dim(x) == c(17544, 20)))
  }

})
