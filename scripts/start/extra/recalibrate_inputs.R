# |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new calibration for different factor costs, AEI and clustering
# --------------------------------------------------------


library(magpie4)
library(magclass)
options(warn=-1)
# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")


realization<-c("mixed_feb17","sticky_feb18","sticky_feb18")
sticky_modes<-c("dynamic","dynamic","free")

input <- c("rev4.59SmashingPumpkins+ISIMIPyieldsTEST+ISIMIPyields_EPIC-IIASA:ukesm1-0-ll:ssp585:default_h12_df1b093f_cellularmagpie_debug.tgz",
         "rev4.59SmashingPumpkins+ISIMIPyieldsTEST+ISIMIPyields_EPIC-IIASA:ukesm1-0-ll:ssp585:default_h12_magpie_debug.tgz",
         "rev4.59SmashingPumpkins+ISIMIPyieldsTEST+ISIMIPyields_EPIC-IIASA:ukesm1-0-ll:ssp585:default_h12_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "additiona_stickyH12.tgz",
         "Zabelirrig_SP.tgz"
         )
#,
# ### Normal
for (i in realization){
  if(realization=="mixed_feb17")
  {
    sticky_modes<-"free"
  }else{
    sticky_modes<-c("dynamic","free")
  }
  for (so in sticky_modes) {

 cfg$force_download <- TRUE

 if(i=="sticky_feb18"){
   cfg$title <- paste0("calib_run_EPIC_",i,"_",so)
 }else{
    cfg$title <- paste0("calib_run_EPIC_",i,"_")
 }

 cfg$input <- input

 cfg$results_folder <- "output/:title::date:"
 cfg$recalibrate <- TRUE
#
#Selects factor costs realization
 cfg$gms$factor_costs <- i
 cfg$gms$c38_sticky_mode  <- so

 if(i=="sticky_feb18"){
   cfg$crop_calib_max <- 2
 }else{
   cfg$crop_calib_max <- 1
 }

 cfg$gms$c_timesteps <- 1
 cfg$output <- c("rds_report")
 cfg$sequential <- TRUE




 start_run(cfg,codeCheck=FALSE)
 if(i=="sticky_feb18"){
   magpie4::submitCalibration(paste0("H12","_EPIC_",i,"_",so))
 }else{
   magpie4::submitCalibration(paste0("H12","_EPIC_",i,"_"))
 }
 }
}
