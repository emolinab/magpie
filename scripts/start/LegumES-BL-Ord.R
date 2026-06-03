# |  (C) 2008-2025 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


# -----------------------------------------------------------------------
# description: Start a set of baseline scenarios for the LegumES project
# -----------------------------------------------------------------------

library(gms)

source("scripts/start_functions.R")
source("config/default.cfg")

cfg$results_folder <- "output/:title::date:"


cfg$output <- c("output_check", "extra/disaggregation","rds_report_eu_h16") #,"rds_report_eu_h16", "rds_report"
cfg$force_download <- TRUE

scenarios <- c("SSP2","SSP3","SSP4","SSP5") # "SSP2","SSP3","SSP4","SSP5","SSP1"
cfg$recalc_npi_ndc <- TRUE


###### Calibration run #######

#   cfg$title <- "LegumES-calib-H16EU-level07"

#   output_folder <- paste0("output/", cfg$title)
#   if(dir.exists(output_folder)) {
#   message("Removing existing output folder: ", output_folder)
#   unlink(output_folder, recursive = TRUE)
# }
# cfg$recalibrate_landconversion_cost <- TRUE
# cfg$calib_maxiter_landconversion_cost <- 20
# cfg$best_calib_landconversion_cost <- TRUE
# cfg$calib_accuracy_landconversion_cost <- 0.01    
# cfg$gms$c_timesteps <- "calib"
# cfg$force_replace <- TRUE
# cfg$qos <- "priority"
# cfg$level_gradient_mix  <- 0.7 
# cfg <- setScenario(cfg, "SSP2", scenario_config = "config/projects/LegumES_configF-1.csv")
# #cfg$input["patch"] <- "AddFile.tgz"

# start_run(cfg,codeCheck=FALSE)
# magpie4::submitCalibration("H16EU-Leg-level05")


###############################

cfg$gms$c_timesteps <- "5year"

####### Scenarios runs ########

for(sce in scenarios){

  cfg$title <- paste0("LegumES-H16EU-",sce)

  cfg$recalibrate_landconversion_cost <- FALSE
  
  cfg$qos         <- "standby_highMem" 
  cfg <- setScenario(cfg=cfg, scenario=sce, scenario_config = "config/projects/LegumES_configF-1.csv")

# if(sce == "SSP1"){
# cfg$input["patch"] <- "Patch.tgz"
# cfg$gms$c30_rotation_rules <- "legumes" 
# }else{
#   cfg$input["patch"] <- ""
# cfg$gms$c30_rotation_rules <- "default" 
# }


  start_run(cfg = cfg) 

}

##############################