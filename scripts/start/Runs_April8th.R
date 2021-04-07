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

realization<-c("sticky_feb18")
sticky_modes<-c("free","dynamic")
inputs <- c("rev4.59_8f7b9423_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59_8f7b9423_024608f1_cellularmagpie_debug.tgz",
         "rev4.59_8f7b9423_magpie_debug.tgz",
         "additional_sticky.tgz",
         "ZabelPatchH13.tgz"
         )

climate<-c("cc","nocc")


## Half earth Scenarios
cfg$gms$c35_protect_scenario <- "HalfEarth"
