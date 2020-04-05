rdefra 0.3.7
==============

## BUG FIXES
* Updated tests to be compatible with PROJ6 [#9](https://github.com/ropensci/rdefra/issues/9)

## MINOR CHANGES
* Removed obsolete packages in 'Suggests'

rdefra 0.3.6
==============

## BUG FIXES
* SiteID = NA causes hanging errors [#6](https://github.com/ropensci/rdefra/issues/6)
* Different variables for ukair_get_coordinates() when inputs are fed in differently [#7](https://github.com/ropensci/rdefra/issues/7)

## MINOR CHANGES
* function ukair_get_coords back to original name ukair_get_coordinates

rdefra 0.3.5
==============

## MINOR FIXES
Functions are updated due to a recent modification of the catalogue API.

## MINOR IMPROVEMENTS
Changes made after scanning the package using goodpractice:
* lines no longer than 80 characters
* 84% code coverage
* function names shorter than 30 characters
  - function ukair_get_coordinates now renamed ukair_get_coords

rdefra 0.3.4
==============

## MINOR IMPROVEMENTS
Changes to DESCRIPTION file:

* Added rmarkdown and knitr in Suggests
* Added entry VignetteBuilder: knitr
* Changed all links to the new ropenscilabs github account (ropenscilabs instead of kehraProject)

This repo is now transferred to the ropenscilabs github account.

rdefra 0.3.3
==============

In this release the package was moved to the root directory (needed based on the ropensci review) and the related adjustments made.

## MINOR FIXES

* Corrected units in README (#2)
* Merged README_files folder to assets? (#3)

rdefra 0.3.2
==============

Accepted for pubblication on JOSS

rdefra 0.3.1
==============

Minor changes

rdefra 0.3.0
==============

Minor fixes

rdefra 0.2.0
==============

* Added unist tests (using testthat framework), 
* Added Travis CI integration
* Added a vignette
* Added paper for submission to JOSS
* Added a document to review the package under the ropensci project

rdefra 0.1.0
==============

* Initial release
