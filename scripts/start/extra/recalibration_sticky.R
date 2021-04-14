# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate new calibration factors for different factor costs, resolutions and rcps
# --------------------------------------------------------

#For sensitivity analysis
library(magpie4)
library(magclass)
options(warn=-1)
# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

realization<-c("sticky_feb18")
sticky_modes<-c("free","dynamic")
input <- c("rev4.59SmashingPumpkins_h12_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59SmashingPumpkins_h12_024608f1_cellularmagpie_debug.tgz",
         "rev4.59SmashingPumpkins_h12_magpie_debug.tgz",
         "additiona_stickyH12.tgz"
         )

### Normal
for (i in realization){
  for (so in sticky_modes){

cfg$title <- paste0("calib_run_",i,"_",so,"_SP_")
cfg$input <- input

cfg$results_folder <- "output/:title::date:"
cfg$recalibrate <- TRUE

#Selects factor costs realization
cfg$gms$factor_costs <- i
cfg$gms$c38_sticky_mode  <- so

cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
cfg$crop_calib_max <- 2


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("H13","_SP_",i,"_",so))

}}

depreciation<-c(0,0.01,0.1)
dep<-("0","001","01")

for (d in 1:length(depreciation)){

cfg$title <- paste0("calib_run_dp_",dep[d],"_")
cfg$input <- input

cfg$results_folder <- "output/:title::date:"
cfg$recalibrate <- TRUE

#Selects factor costs realization
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$c38_sticky_mode  <- "dynamic"
cfg$gms$s38_depreciation_rate <- depreciation[d]

cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
cfg$crop_calib_max <- 2


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("H13","_dep_SP_",dep[d]))

}
