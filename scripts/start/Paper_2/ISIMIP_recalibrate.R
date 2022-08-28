# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new calibration factors
# --------------------------------------------------------

library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

cfg$input <- c(cellular    = "rev4.65+Paper_270822_pDSSAT_MPI-ESM1-2-HR_8f7b9423_6fc6400e_cellularmagpie_c200_MPI-ESM1-2-HR-ssp126_lpjml-8e6c5eb1_isimip-aa82a2e6.tgz",
               regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
               validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.07.tgz")

cfg$gms$s13_ignore_tau_historical <- 1 #ignoring historical tau == 1
cfg$gms$factor_costs<- "sticky_feb18"
cfg$gms$c38_sticky_mode <- "dynamic"
cfg$force_download <- TRUE

cfg$results_folder <- "output/calibration/:title:"
cfg$recalibrate <- TRUE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$title <- "calib_Paper2"
cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration("H13_Paper")
