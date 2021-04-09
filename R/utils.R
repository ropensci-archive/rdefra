# UK-AIR endpoint
url <- "http://uk-air.defra.gov.uk"

# Main API function
ukair_api <- function(url, path, query) {
  url_path <- httr::modify_url(url = url, path = path)
  gracefully_fail(url_path)
  resp <- httr::GET(url = url, path = path, query = query)
  return(resp)
}

# From https://community.rstudio.com/t/internet-resources-should-fail-gracefully/49199/12
gracefully_fail <- function(remote_file) {
  try_GET <- function(x, ...) {
    tryCatch(
      httr::GET(url = x, httr::timeout(60), ...),
      error = function(e) conditionMessage(e),
      warning = function(w) conditionMessage(w)
    )
  }
  is_response <- function(x) {
    class(x) == "response"
  }
  
  # First check internet connection
  if (!curl::has_internet()) {
    message("No internet connection.")
    return(invisible(NULL))
  }
  # Then try for timeout problems
  resp <- try_GET(remote_file)
  if (!is_response(resp)) {
    message(resp)
    return(invisible(NULL))
  }
  # Then stop if status > 400
  if (httr::http_error(resp)) { 
    httr::message_for_status(resp)
    return(invisible(NULL))
  }

}