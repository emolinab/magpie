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

realization<-c("sticky_feb18","mixed_feb17")
sticky_modes<-c("dynamic")
inputs <- c("rev4.59_8f7b9423_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59_8f7b9423_024608f1_cellularmagpie_debug.tgz",
         "rev4.59_8f7b9423_magpie_debug.tgz",
         "additional_sticky.tgz",
         "ZabelPatchH13.tgz"
         )

climate<-c("cc")

he_calib<-c("calibration_H12_HE_sticky_feb18_06Apr21.tgz",
            "calibration_H12_HE_mixed_feb17_06Apr21.tgz")
# Half Earth
aux<-1
for (i in realization){
#  if(i != "sticky_feb18"){
  for (so in sticky_modes){

cfg$title <- paste0("LPj5_",i,"_HalfEarth_",climate,"_")

#configuration of scenarios
cfg <- setScenario(cfg,climate)

#inputs
cfg$input <- c(inputs,he_calib[aux])
cfg$force_download <- TRUE
cfg$recalibrate <- FALSE

#Selects factor costs realization
cfg$gms$factor_costs <- i
cfg$gms$c38_sticky_mode  <- so

# Half earth scenario
cfg$gms$c35_protect_scenario <- "HalfEarth"

cfg$output <- c("rds_report")

start_run(cfg=cfg)

aux<-aux+1
}}
#}
#### Normal runs with changes substitution and patrick's suitable area
normal_calib<-c("calibration_H12_calibLPJ5_sticky_feb18_06Apr21.tgz",
            "calibration_H12_calibLPJ5_mixed_feb17_07Apr21.tgz")
# Half Earth
aux<-1

for (i in realization){
  for (so in sticky_modes){

    cfg$title <- paste0("LPJ5_",i,"_Normal_",climate,"_")

    #configuration of scenarios
    cfg <- setScenario(cfg,climate)

    #inputs
    cfg$input <- c(inputs,normal_calib[aux])
    cfg$force_download <- TRUE
    cfg$recalibrate <- FALSE

    #Selects factor costs realization
    cfg$gms$factor_costs <- i
    cfg$gms$c38_sticky_mode  <- so

    cfg$output <- c("rds_report")

    start_run(cfg=cfg)

    aux<-aux+1


}}
######
#depreciation

dep_calib<-c("calibration_H12_dep_0_07Apr21.tgz",
            "calibration_H12_dep_0.01_07Apr21.tgz",
            "calibration_H12_dep_0.1_07Apr21.tgz",
            "calibration_H12_dep_1_07Apr21.tgz")
# Half Earth
aux<-1
depreciation<-c(0,0.01,0.1,1)

for (d in depreciation){


cfg$title <- paste0("LPJ5_StickyDy_Dep_",d,"_",climate,"_")
cfg$input <- c(inputs,dep_calib[aux])

#configuration of scenarios
cfg <- setScenario(cfg,climate)
#
cfg$force_download <- TRUE
cfg$recalibrate <- FALSE

#Selects factor costs realization
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$c38_sticky_mode  <- "dynamic"
cfg$gms$s38_depreciation_rate <- d


cfg$output <- c("rds_report")

start_run(cfg=cfg)

aux<-aux+1
}

###### Protect existing cropland area
calib<-"calibration_H12_calibLPJ5_sticky_feb18_06Apr21.tgz"
percent<-c(0.1,0.3,0.5,0.7,0.9)

for (p in percent){


cfg$title <- paste0("LPJ5_StickyDy_ProtectLand_",p,"_",climate,"_")
cfg$input <- c(inputs,calib)

#configuration of scenarios
cfg <- setScenario(cfg,climate)

cfg$force_download <- TRUE
cfg$recalibrate <- FALSE

#Selects factor costs realization
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$c38_sticky_mode  <- "dynamic"
cfg$gms$s38_depreciation_rate <- 0.05

cfg$gms$c30_protect_crop  <- TRUE
cfg$gms$s30_perc_protected  <- p

cfg$output <- c("rds_report")

start_run(cfg=cfg)

}
