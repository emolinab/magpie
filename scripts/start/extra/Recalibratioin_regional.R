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

###################################################################################################
realization<-c("mixed_feb17","sticky_feb18")
mode_sticky<-c("dynamic")
H<-c("H12","H13")
input1<-list()
input1[["H12"]]<-c("rev4.59SmashingPumpkins_h12_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59SmashingPumpkins_h12_024608f1_cellularmagpie_debug.tgz",
         "rev4.59SmashingPumpkins_h12_magpie_debug.tgz",
         "additiona_stickyH12.tgz",
         "Zabel_SmPumH12.tgz"
         )

input1[["H13"]]<-c("rev4.59SmashingPumpkins2_8f7b9423_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59SmashingPumpkins2_8f7b9423_dc80b559_cellularmagpie_debug.tgz",
         "rev4.59SmashingPumpkins2_8f7b9423_magpie_debug.tgz",
         "additional_sticky.tgz",
         "ZabelPatchH13.tgz "
         )



    for (hn in H){
      for (i in realization){

cfg$title <- paste0("calib_NLP_",hn,"_SP_",i)


cfg$input <-input1[[hn]]
#Selects factor costs realization
cfg$gms$factor_costs <- i
cfg$gms$c38_sticky_mode<-mode_sticky[1]


cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0(hn,"_NLP_",i,"_SP"))

}
}
