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

#start MAgPIE run
cfg$input <- c(cellular = "rev4.62+EMB_h12_57bd794f_cellularmagpie_debug_c200_UKESM1-0-LL-ssp370_lpjml-ab83aee4.tgz",
               regional = "rev4.62+EMB_h12_magpie_debug.tgz",
               validation = "rev4.61_h12_validation.tgz",
               additional = cfg$input[grep("additional_data", cfg$input)],
               patch = "patch_land_iso.tgz")


cfg$results_folder <- "output/:title:"
cfg$recalibrate <- TRUE
cfg$title <- "calib_run_sticky_ukes7p0"
cfg$gms$c_timesteps <- 1
cfg$output <- c("rds_report")
cfg$sequential <- TRUE
start_run(cfg,codeCheck=FALSE)
magpie4::submitCalibration("calib_H12_sticky_ukes7p0")
