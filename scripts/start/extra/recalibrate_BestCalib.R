# |  (C) 2008-2022 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new yield and land conversion cost calib factors for realizations of factor costs
# --------------------------------------------------------

library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# get default settings
source("config/default.cfg")

realizations <- c("sticky_feb18") # "per_ton_fao_may22","sticky_labor" is very similar to sticky_feb18. No extra calibration needed.
type <- NULL

cfg$results_folder <- "output/:title:"
cfg$recalibrate <- TRUE
cfg$recalibrate_landconversion_cost <- FALSE

cfg$output <- c("rds_report")
cfg$force_download <- TRUE

cfg$gms$c_timesteps <- "calib"

for (r in realizations) {
  cfg$gms$factor_costs <- r
best <- if (r != "per_ton_fao_may22") c(FALSE) else FALSE
for (b in best){
      cfg$best_calib <- b
      cfg$title <- paste("calib_run", r, "bC",b, sep = "_")
    start_run(cfg)
  #  magpie4::submitCalibration(paste("H12", r, b, sep = "_"))

}
}
