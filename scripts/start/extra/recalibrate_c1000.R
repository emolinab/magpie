# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new yield calib factors for realizations of factor costs (land conversion cost calibration factors are only calculated if needed)
# --------------------------------------------------------

library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

cfg$input <- c(cellular    = "rev4.65+ISIMIP_140122_8f7b9423_f0244510_cellularmagpie_c1000_IPSL-CM6A-LR-ssp126_lpjml-c5bacf3f.tgz",
               regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
               validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.07.tgz",
               calibration = "calibration_H13_ISIMIP_150122_15Jan22.tgz"
               )


cfg$gms$s13_ignore_tau_historical <- 1 #ignoring historical tau == 1
cfg$gms$factor_costs<- "sticky_feb18"
cfg$gms$c38_sticky_mode <- "dynamic"
cfg$force_download <- TRUE

cfg$results_folder <- "output/:title:"
cfg$recalibrate <- FALSE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$title <- "calib_c1000_H13_270222"
cfg$output <- c("rds_report")

#parallel
cfg$qos <- "standby_maxMem"

start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration("H13_c1000_270222")
