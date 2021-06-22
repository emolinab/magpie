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
source("scripts/start/extra/lpjml_addon.R")

realizations<-c("mixed_feb17","sticky_feb18","sticky_feb18")
sticky_mode<-c("","free","dynamic")


for (r in 1:length(realizations)){

      cfg$results_folder <- "output/:title:"
      cfg$recalibrate <- TRUE
      cfg$title <- paste0("calib_run_sm_fix_",r,"_",s,"_")
      cfg$gms$c_timesteps <- 1
      cfg$output <- c("rds_report")
      cfg$sequential <- TRUE

      cfg$gms$factor_costs    <- realizations[r]
      cfg$gms$c38_sticky_mode <- sticky_mode[r]
      cfg$gms$sm_fix_cc       <- 1995


      start_run(cfg,codeCheck=FALSE)
      magpie4::submitCalibration(paste0("Calib_H12_sm_fix_",r,"_",s,"_"))
}
