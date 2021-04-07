# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate new calibration factors for different factor costs, resolutions and rcps
# --------------------------------------------------------

#For sensitivity analysis
library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

###### Protect existing cropland area
calib<-"calibration_H12_calibLPJ5_sticky_feb18_06Apr21.tgz"
percent<-c(0.1,0.3,0.5,0.7,0.9)
inputs <- c("rev4.59_8f7b9423_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59_8f7b9423_024608f1_cellularmagpie_debug.tgz",
         "rev4.59_8f7b9423_magpie_debug.tgz",
         "additional_sticky.tgz",
         "ZabelPatchH13.tgz"
         )

climate<-c("cc")

for (p in percent){


cfg$title <- paste0("LPJ5_StickyDy_ProtectLand_",p,"_",climate,"_")
cfg$input <- c(inputs,calib)

#configuration of scenarios
cfg <- setScenario(cfg,climate)

cfg$force_download <- TRUE
cfg$recalibrate <- FALSE

#Selects factor costs realization
cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$c38_sticky_mode  <- "dynamic"
cfg$gms$s38_depreciation_rate <- 0.05

cfg$gms$c30_protect_crop  <- TRUE
cfg$gms$s30_perc_protected  <- p

cfg$output <- c("rds_report")

start_run(cfg=cfg)

}
