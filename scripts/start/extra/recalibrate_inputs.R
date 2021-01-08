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

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

cfg$results_folder <- "output/:title::date:"
cfg$recalibrate <- TRUE

realization<-c("mixed_feb17","sticky_feb18")
clustering<-c("c200")

for (i in realization){
  for (k in clustering){

#removes previous calibration factors
remove <- dir(pattern=c(".cs3"))
file.remove(remove,recursive=FALSE)

cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp6p0-co2_rev50_c200_690d3718e151be1b450b394c1064b1c5.tgz",
         "rev4.52_h12_magpie.tgz",
         "rev4.52_h12_validation.tgz",
         "calibration_H12_c200_26Feb20.tgz",
         "additional_data_rev3.89.tgz")


cfg$force_download <- TRUE

cfg$gms$yields <- p

cfg$title <- paste0("Current_develop_calib_run_",i,"_")

#Selects factor costs realization
cfg$gms$factor_costs <- i

cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE


# AEI switch

cfg$gms$c41_initial_irrigation_area  <- av


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("Current_develop_H12_",i,"_"))
}
}
