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

cfg$force_download <- TRUE
cfg$results_folder <- "output/:title::date:"


cfg$output <- c("rds_report")
cfg$force_download <- TRUE

scenarios <- c("SSP2","SSP3","SSP1") #
cfg$recalc_npi_ndc <- TRUE


###### Calibration run #######

  cfg$title <- "LegumES-calib-H16EU"

  output_folder <- paste0("output/", cfg$title)
  if(dir.exists(output_folder)) {
  message("Removing existing output folder: ", output_folder)
  unlink(output_folder, recursive = TRUE)
}
cfg$recalibrate <- FALSE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$gms$c_timesteps <- "calib"
cfg$output <- c("rds_report")
cfg$force_replace <- TRUE
cfg$qos <- "priority"
cfg <- setScenario(cfg, "SSP1", scenario_config = "config/projects/LegumES_configF.csv")
cfg$input["patch"] <- "CalibH16EU.tgz"

start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration("H16EU")


###############################

  cfg$gms$c_timesteps <- "5year"

######## Scenarios runs ########

for(sce in scenarios){

  cfg$title <- paste0("LegumES-Test-H16EU-biTrade-",sce)

  cfg$recalibrate_landconversion_cost <- FALSE

  # output_folder <- paste0("output/", cfg$title)
  # if(dir.exists(output_folder)){
  # message("Removing existing output folder: ", output_folder)
  # unlink(output_folder, recursive = TRUE)
  # }
  
  cfg$recalibrate <- FALSE
  cfg$qos         <- "standby_highMem" 
  cfg <- setScenario(cfg=cfg, scenario=sce, scenario_config = "config/projects/LegumES_configF.csv")
  cfg$input["patch"] <- "AddFile.tgz"


  start_run(cfg = cfg) 

}

################################