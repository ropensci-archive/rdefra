
<!-- Edit the README.Rmd only!!! The README.md is generated automatically from README.Rmd. -->

# rdefra: Interact with the UK AIR Pollution Database from DEFRA

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.593187.svg)](https://doi.org/10.5281/zenodo.593187)
[![status](http://joss.theoj.org/papers/57058f6e8a511f3bb0667ef7687cc87d/status.svg)](http://joss.theoj.org/papers/57058f6e8a511f3bb0667ef7687cc87d)

[![Travis-CI Build
Status](https://travis-ci.org/ropensci/rdefra.svg?branch=master)](https://travis-ci.org/ropensci/rdefra)
[![codecov.io](https://codecov.io/gh/ropensci/rdefra/coverage.svg?branch=master)](https://codecov.io/gh/ropensci/rdefra?branch=master)

[![CRAN Status
Badge](http://www.r-pkg.org/badges/version/rdefra)](https://cran.r-project.org/package=rdefra)
[![CRAN Total
Downloads](http://cranlogs.r-pkg.org/badges/grand-total/rdefra)](https://cran.r-project.org/package=rdefra)
[![CRAN Monthly
Downloads](http://cranlogs.r-pkg.org/badges/rdefra)](https://cran.r-project.org/package=rdefra)
[![](https://badges.ropensci.org/68_status.svg)](https://github.com/ropensci/onboarding/issues/68)

The package [rdefra](https://cran.r-project.org/package=rdefra) allows
to retrieve air pollution data from the Air Information Resource
[UK-AIR](https://uk-air.defra.gov.uk/) of the Department for
Environment, Food and Rural Affairs in the United Kingdom. UK-AIR does
not provide a public API for programmatic access to data, therefore this
package scrapes the HTML pages to get relevant information.

This package follows a logic similar to other packages such as
[waterData](https://cran.r-project.org/package=waterData) and
[rnrfa](https://cran.r-project.org/package=rnrfa): sites are first
identified through a catalogue, data are imported via the station
identification number, then data are visualised and/or used in analyses.
The metadata related to the monitoring stations are accessible through
the function `ukair_catalogue()`, missing stations’ coordinates can be
obtained using the function `ukair_get_coordinates()`, and time series
data related to different pollutants can be obtained using the function
`ukair_get_hourly_data()`.

DEFRA’s servers can handle multiple data requests, therefore concurrent
calls can be sent simultaneously using the
[parallel](https://www.R-project.org/) package. Although the limit rate
depends on the maximum number of concurrent calls, traffic and available
infrustracture, data retrieval is very efficient. Multiple years of data
for hundreds of sites can be downloaded in only few minutes.

For similar functionalities see also the
[openair](https://cran.r-project.org/package=openair) package, which
relies on a local copy of the data on servers at King’s College (UK),
and the [ropenaq](https://CRAN.R-project.org/package=ropenaq) which
provides UK-AIR latest measured levels (see
<https://uk-air.defra.gov.uk/latest/currentlevels>) as well as data from
other countries.

## Dependencies & Installation

### Dependencies

The rdefra package depends on two things:

  - The Geospatial Data Abstraction Library (GDAL).

  - Some additional CRAN packages. Check for missing dependencies and
    install them using the commands
below:

<!-- end list -->

``` r
packs <- c("httr", "xml2", "lubridate", "tibble", "dplyr", "sp", "devtools",
           "leaflet", "zoo", "testthat", "knitr", "Rmarkdown")
new.packages <- packs[!(packs %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
```

### Installation

Get the released version from CRAN:

``` r
install.packages("rdefra")
```

Or the development version from github using
[remotes](https://github.com/r-lib/remotes):

``` r
remotes::install_github("ropensci/rdefra")
```

Load the rdefra package:

``` r
library("rdefra")
```

## Functions

The package logic assumes that users access the UK-AIR database in the
fllowing steps:

1.  Browse the catalogue of available stations and selects some stations
    of interest (see function `ukair_catalogue()`).
2.  Get missing coordinates (see function `ukair_get_coordinates()`).
3.  Retrieves data for the selected stations (see functions
    `ukair_get_site_id()` and `ukair_get_hourly_data()`).

For an in-depth description of the various functionalities andexample
applications, please refer to the package
[vignette](vignettes/rdefra_vignette.md).

## Meta

  - Please note that this project is released with a [Contributor Code
    of Conduct](CONDUCT.md). By participating in this project you agree
    to abide by its terms.
  - Please [report any issues or
    bugs](https://github.com/ropensci/rdefra/issues).
  - License: [GPL-3](https://opensource.org/licenses/GPL-3.0)
  - This package was reviewed by [Maëlle
    Salmon](https://github.com/maelle) and [Hao
    Zhu](https://github.com/haozhu233) for submission to ROpenSci (see
    review [here](https://github.com/ropensci/onboarding/issues/68)) and
    the Journal of Open Source Software (see review
    [here](https://github.com/openjournals/joss-reviews/issues/51)).
  - Get citation information for `rdefra` in R doing `citation(package =
    "rdefra")`

<br/>

[![ropensci\_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
