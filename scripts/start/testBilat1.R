# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# -------------------------------------------------------------
# description: default run with new yield realization and data
# ------------------------------------------------------------

library(gms)
library(lucode2)

source("scripts/start_functions.R")
source("config/default.cfg")
cfg$recalibrate = FALSE

#cfg$gms$sm_fix_SSP2 <- 2025
# change sm fix in trade module to 2010
cfg$force_download <- FALSE

#residues bioenergy demand off 
cfg$gms$c60_res_2ndgenBE_dem <- "ssp2"     # def = ssp2
# cap those above 1 if newly above 1, re-distribute

cfg$gms$croparea    <- "detail_apr24"               # def = simple_apr24
 cfg$info$flag <- "bT2110"
# support function to create standardized title
.title <- function(cfg, ...) return(paste(cfg$info$flag, sep = "_", ...))


ssp_params <- data.frame(
  ssp = c("SSP1", "SSP2", "SSP3", "SSP4", "SSP5"),
  stddev_lib = c(1.5, 1.0, 0.5, 1.0, 2.0),
  import_supply = c(0.5, 1.0, 0.5, 2.0, 2.0),
  tariff_fadeout = c(0, 0, 0, 0, 0),
  stringsAsFactors = FALSE
)

for (ssp in c("SSP1", "SSP2", "SSP3", "SSP4", "SSP5")) {
     cfg$gms$trade <- "selfsuff_reduced"
    cfg$title <- .title(cfg, paste("OFF", ssp, "NPi2025", sep = "-"))
    cfg <- setScenario(cfg, c(ssp, "NPI", "rcp4p5"))
    cfg$gms$c56_mute_ghgprices_until <- "y2150"
    cfg$gms$c56_pollutant_prices <- paste0("R34M410-", ssp, "-NPi2025")
    cfg$gms$c60_2ndgen_biodem    <- paste0("R34M410-", ssp, "-NPi2025")
   # start_run(cfg, codeCheck = FALSE)

   cfg$title <- .title(cfg, paste("ON", ssp, "NPi2025", sep = "-"))
    cfg$gms$trade <- "selfsuff_reduced_bilateral22"
    # Get parameters from mapping
    cfg$gms$s21_trade_tariff_fadeout <- ssp_params$tariff_fadeout[ssp_params$ssp == ssp]
    cfg$gms$s21_tariff_factor <- 1
    cfg$gms$s21_stddev_lib_factor <- ssp_params$stddev_lib[ssp_params$ssp == ssp]
    cfg$gms$s21_import_supply_scenario <- ssp_params$import_supply[ssp_params$ssp == ssp]
     start_run(cfg, codeCheck = FALSE)
}





cfg$title   <- paste0("0910_TestBilat_newFAO_defSSP2")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 0
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 1
cfg$gms$s21_import_supply_scenario <- 1

# start_run(cfg=cfg)



cfg$title   <- paste0("0910_TestBilat_newFAO_SSP1_15stddev")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 0
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 1.5
cfg$gms$s21_import_supply_scenario <- 0.5
#start_run(cfg=cfg)


cfg$title   <- paste0("0910_TestBilat_newFAO_SSP3")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 0
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 0.5
cfg$gms$s21_import_supply_scenario <- 0.5
#start_run(cfg=cfg)



cfg$title   <- paste0("0910_TestBilat_newFAO_SSP4")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 0
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 1
cfg$gms$s21_import_supply_scenario <- 2  
#start_run(cfg=cfg)


cfg$title   <- paste0("0910_TestBilat_newFAO_SSP5")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 0
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 2
cfg$gms$s21_import_supply_scenario <- 2
 #start_run(cfg=cfg)


# cfg$title   <- paste0("1312BilatImportRatio_RotConstraint_NoTariff")


# cfg$gms$croparea    <- "detail_apr24"               # def = simple_apr24
# cfg$gms$s30_rotation_scenario_start <- 2015    # def = 2025
# cfg$gms$s30_implementation <- 0   # def = 0
