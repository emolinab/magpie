# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new calibration factors for yields (land conversion cost calibration factors are only calculated if needed)
# --------------------------------------------------------

library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")
cfg$input <- c(cellular    = "rev4.65Paper_170122_8f7b9423_f2acbfe3_cellularmagpie_c200_UKESM1-0-LL-ssp585_lpjml-8e6c5eb1.tgz",
               regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
               validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation.tgz",
               calibration  = "calibration_H13_ISIMIP_150122_15Jan22.tgz",
               additional  = "additional_data_rev4.07.tgz")

cfg$results_folder <- "output/:title:"
cfg$recalibrate <- TRUE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$title <- "calib_run_free"
cfg$output <- c("rds_report")
cfg$force_replace <- TRUE
start_run(cfg,codeCheck=FALSE)

cfg$gms$factor_costs     <-   "sticky_feb18"
cfg$gms$c38_sticky_mode  <-   "free"

magpie4::submitCalibration("H13_free")
