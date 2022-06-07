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
cfg$results_folder <- "output/:title:"

cfg$input <- c(cellular    = "rev4.72+FOCUS_060622_LPJmL_8f7b9423_77225b71_cellularmagpie_c200_MPI-ESM1-2-HR-ssp126_lpjml-8e6c5eb1_isimip-12dd7e02.tgz"
               regional    = "rev4.72+FOCUS_060622__8f7b9423_magpie.tgz",
               validation  = "rev4.72+FOCUS_060622__8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.17.tgz")

cfg$recalibrate <- TRUE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$title <- "calib_run_FOCUS"
cfg$output <- c("rds_report")
cfg$force_replace <- TRUE
cfg$gms$factor_costs<- "sticky_feb18"
cfg$recalc_npi_ndc <- TRUE
start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration("H12")
