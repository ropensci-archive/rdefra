# rdefra: Interact with the UK AIR Pollution Database from DEFRA

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.593187.svg)](https://doi.org/10.5281/zenodo.593187)
[![JOSS](https://joss.theoj.org/papers/10.21105/joss.00051/status.svg)](https://doi.org/10.21105/joss.00051)

<!-- badges: start -->
[![R-CMD-check](https://github.com/ropensci/rdefra/workflows/R-CMD-check/badge.svg)](https://github.com/ropensci/rdefra/actions)
[![codecov.io](https://codecov.io/gh/ropensci/rdefra/coverage.svg?branch=master)](https://app.codecov.io/gh/ropensci/rdefra?branch=master)
[![CRAN Status
Badge](http://www.r-pkg.org/badges/version/rdefra)](https://cran.r-project.org/package=rdefra)
[![CRAN Total
Downloads](http://cranlogs.r-pkg.org/badges/grand-total/rdefra)](https://cran.r-project.org/package=rdefra)
[![CRAN Monthly
Downloads](http://cranlogs.r-pkg.org/badges/rdefra)](https://cran.r-project.org/package=rdefra)
[![](https://badges.ropensci.org/68_status.svg)](https://github.com/ropensci/software-review/issues/68)
<!-- badges: end -->

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
infrastructure, data retrieval is very efficient. Multiple years of data
for hundreds of sites can be downloaded in only few minutes.

For similar functionalities see also the
[openair](https://cran.r-project.org/package=openair) package, which
relies on a local copy of the data on servers at King’s College (UK),
and the [ropenaq](https://CRAN.R-project.org/package=ropenaq) which
provides UK-AIR latest measured levels (see
<https://uk-air.defra.gov.uk/latest/currentlevels>) as well as data from
other countries.

## Installation

Get the released version from CRAN:

``` r
install.packages("rdefra")
```

Or the development version from GitHub using the package `remotes`:

``` r
install.packages("remotes")
remotes::install_github("ropensci/rdefra")
```

Load the rdefra package:

``` r
library(rdefra)
```

## Functions

The package logic assumes that users access the UK-AIR database in the
following steps:

1.  Browse the catalogue of available stations and selects some stations
    of interest (see function `ukair_catalogue()`).
2.  Get missing coordinates (see function `ukair_get_coordinates()`).
3.  Retrieves data for the selected stations (see functions
    `ukair_get_site_id()` and `ukair_get_hourly_data()`).

For an in-depth description of the various functionalities and example
applications, please refer to the package
[vignette](https://github.com/ropensci/rdefra/blob/master/vignettes/rdefra_vignette.Rmd).

## Meta

  - This package and functions herein are part of an experimental open-source project. They are provided as is, without any guarantee.
  - Please [report any issues or
    bugs](https://github.com/ropensci/rdefra/issues).
  - License: [GPL-3](https://opensource.org/license/gpl-3-0/)
  - This package was reviewed by [Maëlle
    Salmon](https://github.com/maelle) and [Hao
    Zhu](https://github.com/haozhu233) for submission to ROpenSci (see
    review [here](https://github.com/ropensci/software-review/issues/68)) and
    the Journal of Open Source Software (see review
    [here](https://github.com/openjournals/joss-reviews/issues/51)).
  - Cite `rdefra`: `citation(package = "rdefra")`

<br/>

[![ropensci\_footer](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org/)
