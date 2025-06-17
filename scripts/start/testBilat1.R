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

cfg$gms$sm_fix_SSP2 <- 2025
cfg$force_download <- FALSE


cfg$gms$croparea    <- "detail_apr24"               # def = simple_apr24


cfg$title   <- paste0("1706TestBilat2_newFAO_off")

start_run(cfg=cfg)

cfg$title   <- paste0("1706TestBilat_newFAO_defSSP2")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 0
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 1
cfg$gms$s21_import_supply_scenario <- 1

start_run(cfg=cfg)


cfg$title   <- paste0("1706TestBilat_newFAO_SSP1")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 1
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 2
cfg$gms$s21_import_supply_scenario <- 0.5
start_run(cfg=cfg)


cfg$title   <- paste0("1706TestBilat_newFAO_SSP3")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 0
cfg$gms$s21_tariff_factor <- 2
cfg$gms$s21_stddev_lib_factor <- 1
cfg$gms$s21_import_supply_scenario <- 1
start_run(cfg=cfg)



cfg$title   <- paste0("1706TestBilat_newFAO_SSP4")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 1
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 5
cfg$gms$s21_import_supply_scenario <- 2
start_run(cfg=cfg)


cfg$title   <- paste0("1706TestBilat_newFAO_SSP5")
cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_trade_tariff_fadeout <- 1
cfg$gms$s21_tariff_factor <- 1
cfg$gms$s21_stddev_lib_factor <- 5
cfg$gms$s21_import_supply_scenario <- 2
start_run(cfg=cfg)


cfg$title   <- paste0("1312BilatImportRatio_RotConstraint_NoTariff")


cfg$gms$croparea    <- "detail_apr24"               # def = simple_apr24
cfg$gms$s30_rotation_scenario_start <- 2015    # def = 2025
cfg$gms$s30_implementation <- 0   # def = 0
