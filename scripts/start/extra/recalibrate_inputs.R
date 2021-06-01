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

realization<-c("sticky_feb18")
sticky_modes<-c("dynamic","free")
#realization<-c("mixed_feb17")
#sticky_modes<-c("")

combo<-c(#"7p0_CYGMA_GFDL",
        "8p5_CYGMA_UKESM")
        #"8p5_pDSSAT_UKESM",
        #"8p5_EPIC_UKESM")
        #"7p0_EPIC_GFDL")

hashes_combos<-as.character(c(#"c6f10324",
                 "e61ed473"))
                 #"256c3ab7",
                 #"c0547439"))
                 #"669b91c3")

names_sce<-c("Variable")

input<-c("additional_data_rev4.04.tgz",
               "rev4.59_h12_magpie.tgz",
               "rev4.59test_h12_validation.tgz")
### Normal
for (i in realization){
  for (com in 1:length(combo)){
    for (so in 1:length(sticky_modes)) {

          #configurations
          cfg$title <- paste0("calib_ClIMp_fx_",combo[com],"_",i,"_",names_sce[so])
          cfg$force_download <- TRUE

          cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,
                                "/p/projects/landuse/users/mbacca/Additional_data_sets"=NULL),
                           getOption("magpie_repos"))

          if(i == "mixed_feb17"){
          cfg$crop_calib_max<- 1.5
        }else if(i=="sticky_feb18"){
          cfg$crop_calib_max<- 2
        }

          cfg$recalibrate <- TRUE
          cfg$results_folder <- "output/:title::date:"
          cfg$input <- c(input,
                         paste0("rev4.59SmashingPumpkins+ISIMIPyields_h12_",hashes_combos[com],"_cellularmagpie_debug.tgz"))

          cfg$output <- c("rds_report")
          cfg$best_calib <- TRUE
          cfg$gms$c_timesteps <- 1
          cfg$sequential <- TRUE

          #Special modules
          cfg$gms$factor_costs <- i
          if(i == "sticky_feb18"){
          cfg$gms$c38_sticky_mode  <- sticky_modes[so]
           }

           cfg$gms$yields                       <- "managementcalib_aug19"
           cfg$gms$s14_yld_past_switch          <- 0.25
           cfg$gms$processing                   <- "substitution_may21"
           cfg$gms$crop                         <- "endo_apr21"
           cfg$gms$c41_initial_irrigation_area  <- "LUH2v2"


         start_run(cfg,codeCheck=FALSE)

         magpie4::submitCalibration(paste0("CcImp_fx_",combo[com],"_",names_sce[so]))

       }
     }
   }
