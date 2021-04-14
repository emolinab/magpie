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
library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

# realization<-c("sticky_feb18")
# sticky_modes<-c("dynamic","free")
# input <- c("rev4.59SmashingPumpkins_h12_validation_debug.tgz",
#          "additional_data_rev3.99.tgz",
#          "rev4.59SmashingPumpkins_h12_024608f1_cellularmagpie_debug.tgz",
#          "rev4.59SmashingPumpkins_h12_magpie_debug.tgz",
#          "additiona_stickyH12.tgz"
#          )
# 
# climate<-c("cc","nocc")
# 
# ## Normal runs
# 
#  normal_calib<-c("calibration_H12_SP_sticky_feb18_dynamic_14Apr21.tgz",
#                  "calibration_H12_SP_sticky_feb18_free_14Apr21.tgz")
# 
# 
#  for (so in 1:length(sticky_modes)){
#    for (c in 1:length(climate)){
# 
#     cfg$title <- paste0("LPJ_St_SP_",sticky_modes[so],"_",climate[c],"_")
# 
#      #configuration of scenarios
#     cfg <- setScenario(cfg,climate[c])
# 
#      #inputs
#      cfg$input <- c(input,normal_calib[so])
#      cfg$force_download <- TRUE
#      cfg$recalibrate <- FALSE
# 
#      #Selects factor costs realization
#      cfg$gms$factor_costs <- "sticky_feb18"
#      cfg$gms$c38_sticky_mode  <- sticky_modes[so]
#      cfg$gms$s38_depreciation_rate <- 0.05
#      cfg$gms$c30_protect_crop  <- "unprotect"
# 
#      cfg$output <- c("rds_report")
# 
#      start_run(cfg=cfg)
# 
#  }}
# 
# 
# 
# # ##Protection scenarios
# percent<-c(10,20,30,40,50)
# 
# 
# for (p in 1:length(percent)){
# for (so in 1:length(sticky_modes)){
# 
# cfg$title <- paste0("LPJ_St_SP_protectSce_",percent[p],"_",sticky_modes[so],"_")
# cfg$input <- c(input,normal_calib[so])
# 
# #configuration of scenarios
# cfg <- setScenario(cfg,climate[1])
# 
# cfg$force_download <- TRUE
# cfg$recalibrate <- FALSE
# 
# #Selects factor costs realization
# cfg$gms$factor_costs <- "sticky_feb18"
# cfg$gms$c38_sticky_mode  <- sticky_modes[so]
# cfg$gms$s38_depreciation_rate <- 0.05
# 
# cfg$gms$c30_protect_crop  <- "protect"
# cfg$gms$s30_perc_protected  <- percent[p]
# 
# cfg$output <- c("rds_report")
# 
# start_run(cfg=cfg)
# }
# }




 ##### Depreciation for cc and nocc
 dep_calib<-c("calibration_H13_dep_0_12Apr21.tgz",
             "calibration_H13_dep_0.01_13Apr21.tgz",
             "calibration_H13_dep_0.1_13Apr21.tgz",
             "calibration_H13_dep_1_13Apr21.tgz")
 depreciation<-c(0,0.01,0.1,1)
 dep<-c("0","001","01","1")

 for (d in 1:length(depreciation)){
   for (c in 1:length(climate)){


 cfg$title <- paste0("LPJ_St_fx_",dep[d],"_",climate[c],"_")
 cfg$input <- c(inputs,dep_calib[d])

 #configuration of scenarios
 cfg <- setScenario(cfg,climate[c])

 cfg$force_download <- TRUE
 cfg$recalibrate <- FALSE

 #Selects factor costs realization
 cfg$gms$factor_costs <- "sticky_feb18"
 cfg$gms$c38_sticky_mode  <- "dynamic"
  cfg$gms$s38_depreciation_rate <- depreciation[d]
  cfg$gms$c30_protect_crop  <- "unprotect"


 cfg$output <- c("rds_report")

 start_run(cfg=cfg)

 }
 }
