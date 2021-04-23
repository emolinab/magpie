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
mode_sticky<-c("dynamic","dynamic")
name<-c("","dy")
H<-c("SP_new")
input1<-list()
#input1[["SP_old"]]<-c("rev4.59SmashingPumpkins_h12_validation_debug.tgz",
##         "additional_data_rev3.99.tgz",
´#         "rev4.59SmashingPumpkins_h12_024608f1_cellularmagpie_debug.tgz",
#         "rev4.59SmashingPumpkins_h12_magpie_debug.tgz",
#         "additiona_stickyH12.tgz",
#         "Zabel_SmPumH12.tgz"
#         )

input1[["SP_new"]]<-c("rev4.59SmashingPumpkins_h12_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59irrig_is_rainf_h12_83796d6b_cellularmagpie_debug.tgz",
         "rev4.59irrig_is_rainf_h12_magpie_debug.tgz",
         "additiona_stickyH12.tgz",
         "Zabelirrig_SP.tgz"
         )

    for (hn in H){
      for (i in 1:length(realization)){


cfg$title <- paste0("calib_LPJ_irrigSP_",hn,"_",realization[i],"_",name[i],"_")


cfg$input <-input1[[hn]]
#Selects factor costs realization
cfg$gms$factor_costs <- realization[i]
cfg$gms$c38_sticky_mode<-mode_sticky[i]
cfg$force_download <- TRUE


cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE

if(realization[i]=="sticky_feb18"){
  cfg$crop_calib_max <- 2
}else{
  cfg$crop_calib_max <- 1
}

cfg$results_folder <- "output/:title::date:"
cfg$recalibrate <- TRUE


start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0(hn,"_GP_",realization[i],"_",name[i],"_"))

}
}
