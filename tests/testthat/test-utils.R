test_that("UKAIR endpoint works", {

  x <- try(ukair_api(path = "", query = ""), silent = TRUE)

  if ("try-error" %in% class(x) | is.null(class(x))) {
    skip("UKAIR endpoint is not available")
  }else{
    expect_equal(x$status_code, 200)
  }

})
