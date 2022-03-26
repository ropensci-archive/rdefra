# Precompiled vignettes that depend on API key
# Must manually move image files from rdefra/ to rdefra/vignettes/ after knit

library(knitr)
knit("vignettes/rdefra_vignette.Rmd.orig", "vignettes/rdefra_vignette.Rmd")
