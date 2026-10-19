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
cfg$recalc_npi_ndc <- TRUE
cfg$gms$c_timesteps <- "5year"
cfg$recalibrate_landconversion_cost <- FALSE
cfg$qos <- "standby_highMem" 


cfg_base <- cfg  


scenarios <- c("SSP2","SSP2-Diet","SSP2-NitPrice","SSP2-TradeBan") # "SSP2","SSP3","SSP4","SSP5","SSP1"




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
# magpie4::submitCalibration("H16EU-Leg-level07")




###############################






####### Scenarios runs ########


for(sce in scenarios){


  cfg <- cfg_base 


  cfg$title <- paste0("LegumES-H16EU-EUR-T2-",sce)  


  cfg <- setScenario(cfg=cfg, scenario=sce, scenario_config = "config/projects/LegumES_configF-1.csv")


  start_run(cfg = cfg, codeCheck = FALSE) 


}


##############################


scenarios <- c("SSP2-NitEff","SSP2-BioEnergy") 


for(sce in scenarios){
  cfg <- cfg_base 


  cfg$force_download <- TRUE
  cfg$title <- paste0("LegumES-H16EU-EUR-T2-",sce)
  cfg <- setScenario(cfg=cfg, scenario="SSP2", scenario_config = "config/projects/LegumES_configF-1.csv")


  if(sce == "SSP2-NitEff"){
    # file.copy(from = "/p/projects/landuse/users/mbacca/Collaborations/LegumES/Patch/f50_ndfa.cs4", 
    #           to = "/modules/50_nr_soil_budget/input/")
    cfg$input["patch"] <- "Patch_NitEff.tgz"
 }else if(sce == "SSP2-BioEnergy"){
    # file.copy(from = "/p/projects/landuse/users/mbacca/Collaborations/LegumES/Patch/f20_processing_shares.cs3", 
    #           to = "/modules/20_processing/input")
    cfg$input["patch"] <- "Patch_BioEnergy.tgz"
 }




  start_run(cfg = cfg, codeCheck = FALSE) 


}