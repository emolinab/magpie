# |  (C) 2008-2020 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new calibration for different factor costs, AEI and clustering
# --------------------------------------------------------

library(gms)
library(magpie4)
library(magclass)
options(warn=-1)
# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")
source("scripts/start/extra/lpjml_addon.R")

realization<-c("mixed_feb17","sticky_feb18")
combo<-c("rcp7p0_LPJML_GFDL_newParam"
        )

input <- c("additional_data_rev4.04.tgz",
                       "rev4.59_h12_magpie.tgz",
                       "rev4.59_h12_c5cdbf33_cellularmagpie_c200_GFDL-ESM4-ssp370_lpjml-47a77da3.tgz",
                       "rev4.59test_h12_validation.tgz")

#aux<-1

### Normal
for (i in realization){
  for (com in combo){

    if(i == "sticky_feb18"){
    sticky_modes<-c("dynamic","free")
  }else{
    sticky_modes<-c("")
  }

    for (so in sticky_modes) {

          #configurations
          cfg$title <- paste0("calib_PR_ClIM_",com,"_",i,"_",so)
          cfg$force_download <- TRUE

          if(i == "mixed_feb17"){
          cfg$crop_calib_max<- 1.5
        }else if(i=="sticky_feb18"){
          cfg$crop_calib_max<- 2
        }

          cfg$recalibrate <- TRUE
          cfg$results_folder <- "output/:title::date:"
          cfg$input <- input
          cfg$gms$c_timesteps <- 1
          cfg$sequential <- TRUE

          #Special modules
          cfg$gms$factor_costs <- i
          if(i == "sticky_feb18"){
          cfg$gms$c38_sticky_mode  <- so
           }


         start_run(cfg,codeCheck=FALSE)

         magpie4::submitCalibration(paste0("H12_ClIM_",com,"_",i,"_",so))

        # aux<-aux+1
       }
     }
   }
