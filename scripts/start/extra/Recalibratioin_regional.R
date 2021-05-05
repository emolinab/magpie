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
library(gms)
# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

input1<-list()
###################################################################################################
realization<-c("mixed_feb17")
H<-c("newparam")
input1[["newparam"]]<-c("rev4.59irrig_is_rainf_h12_magpie_debug.tgz",
               "rev4.59irrig_is_rainf_h12_83796d6b_cellularmagpie_debug.tgz",
               "rev4.59irrig_is_rainf_h12_validation_debug.tgz",
               "additional_data_rev4.02.tgz"
             )



    for (hn in H){
      for (i in 1:length(realization)){


cfg$title <- paste0("calib_",hn,"_",realization[i],"_")


cfg$input <-input1[[hn]]
#Selects factor costs realization
cfg$gms$factor_costs <- realization[i]
cfg$force_download <- TRUE


cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE

if(realization[i]=="sticky_feb18"){
  cfg$crop_calib_max <- 2
}else{
  cfg$crop_calib_max <- 1.5
}

cfg$results_folder <- "output/:title::date:"
cfg$recalibrate <- TRUE

cfg$gms$yields                       <- "managementcalib_aug19"
cfg$gms$s14_yld_past_switch          <- 0.25
cfg$gms$c41_initial_irrigation_area  <- "LUH2v2"
cfg                                  <- setScenario(cfg,"cc")



start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration(paste0(hn,"_",realization[i],))

}
}
