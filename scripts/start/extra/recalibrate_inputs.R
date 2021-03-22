# |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate new calibration factors for different factor costs, resolutions and rcps
# --------------------------------------------------------


library(magpie4)
library(magclass)
options(warn=-1)
# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

cfg$results_folder <- "output/:title::date:"
cfg$recalibrate <- TRUE

realization<-c("sticky_feb18")


for (i in realization){


cfg$title <- paste0("calib_run_SD_01")


cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev52_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         "rev4.58_h12_magpie.tgz",
         "rev4.58_h12_validation.tgz",
         "additional_data_rev3.98.tgz",
         "additional_sticky.tgz"
         )

#Selects factor costs realization
cfg$gms$factor_costs <- i


cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
cfg$crop_calib_max <- 3
cfg$calib_accuracy <- 0.01
cfg$calib_maxiter <- 100

start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("H12","_SD_01"))

}
