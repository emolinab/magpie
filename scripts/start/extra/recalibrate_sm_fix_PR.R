# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new calibration factors
# --------------------------------------------------------

library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")
realizations<-c("mixed_feb17","sticky_feb18","sticky_feb18")
sticky_mode<-c("","free","dynamic")

cfg$input <- c(cfg$input[grep("additional_data", cfg$input)],
               "rev4.61_h12_magpie.tgz",
               "rev4.61_h12_42b44dcd_cellularmagpie_c200_GFDL-ESM4-ssp370_lpjml-ab83aee4.tgz",
               "rev4.61_h12_validation.tgz",
               "calibration_H12_newlpjml_bestcalib_fc-sticky-dynamic_crop-endoApr21-allM_20May21.tgz")


for (r in 1:length(realizations)){

      #Calibration
      cfg$results_folder <- "output/:title:"
      cfg$recalibrate <- TRUE
      cfg$title <- paste0("calib_run_sm_fix_",realizations[r],"_",sticky_mode[r],"_")
      cfg$gms$c_timesteps <- 1
      cfg$output <- c("rds_report")
      cfg$sequential <- TRUE

      #Addon
      # in case of recalibration, following settings should be applied
      if (realization[r]=="mixed_feb17"){
      cfg$crop_calib_max                   <- 1
    }else{
      cfg$crop_calib_max                   <- 2
    }
      cfg$best_calib                       <- TRUE

      # preliminary test settings for new default
      # (including new yield, crop, factor cost realizations)
      cfg$gms$yields                       <- "managementcalib_aug19"
      cfg$gms$s14_yld_past_switch          <- 0.25
      cfg$gms$processing                   <- "substitution_may21"
      cfg$gms$crop                         <- "endo_apr21"
      cfg$gms$factor_costs                 <- "sticky_feb18"
      cfg$gms$c41_initial_irrigation_area  <- "LUH2v2"



      #Realizations
      cfg$gms$factor_costs    <- realizations[r]
      cfg$gms$c38_sticky_mode <- sticky_mode[r]
      cfg$gms$sm_fix_cc       <- 1995


      start_run(cfg,codeCheck=FALSE)
      magpie4::submitCalibration(paste0("Calib_H12_sm_fix_",realizations[r],"_",sticky_mode[r],"_"))
}
