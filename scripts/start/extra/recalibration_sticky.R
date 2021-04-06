# |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
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

cfg$results_folder <- "output/:title::date:"
cfg$recalibrate <- TRUE

realization<-c("sticky_feb18","mixed")
sticky_modes<-c("dynamic")
input <- c("rev4.58_h12_validation.tgz",
         "additional_data_rev3.98.tgz",
         "rev4.59+mrmagpie_LPJmL_new2_h12_5e4fb8e4d1e7450f19bf2d682b4a8338_cellularmagpie_debug.tgz",
         "rev4.59+mrmagpie_LPJmL_new2_h12_magpie_debug.tgz",
         "additional_sticky.tgz"
         )


for (i in realization){
  for (so in sticky_modes){

cfg$title <- paste0("calib_run_",i,"_HalfEarth_")
cfg$input <- input

#Selects factor costs realization
cfg$gms$factor_costs <- i
cfg$gms$c38_sticky_mode  <- so

# Half earth scenario
cfg$gms$c35_protect_scenario <- "HalfEarth"

cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
cfg$crop_calib_max <- 2


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("H12","_HE_",i))

}}

for (i in realization){
  for (so in sticky_modes){

cfg$title <- paste0("calib_run_",i,"_calibLPJ5_")
cfg$input <- input

#Selects factor costs realization
cfg$gms$factor_costs <- i
cfg$gms$c38_sticky_mode  <- so

cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
cfg$crop_calib_max <- 2


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("H12","_calibLPJ5_",i))

}}

depreciation<-c(0,0.01,0.1,1)

for (d in depreciation){


cfg$title <- paste0("calib_run_dep_",d,"_")
cfg$input <- input

#Selects factor costs realization
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$c38_sticky_mode  <- "dynamic"
cfg$gms$s38_depreciation_rate <- d

cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
cfg$crop_calib_max <- 2


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("H12","_dep_",d))

}
