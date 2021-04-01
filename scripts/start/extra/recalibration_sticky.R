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

realization<-c("mixed_feb17","sticky_feb18")
#realization<-c("sticky_feb18")

for (i in realization){

cfg$title <- paste0("calib_run_CAZsplit",i,"_")


cfg$input <- c("rev4.59_8f7b9423_validation_debug.tgz",
         "additional_data_rev3.98.tgz",
         "rev4.59_8f7b9423_024608f1_cellularmagpie_debug.tgz",
         "rev4.59_8f7b9423_magpie_debug.tgz"
         )

#Selects factor costs realization
cfg$gms$factor_costs <- i


cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0("H12","_CAZsplit_",i,"_"))

}
