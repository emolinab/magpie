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


cfg$title   <- paste0("e1312TestBilatNew_default")

#start_run(cfg=cfg)

cfg$title   <- paste0("e1312TestBilatNew_bilat_0.5maxStdDev_noResBioen")
#cfg$gms$s35_hvarea <- 0 # def = 2
#cfg$gms$s73_timber_demand_switch <- 0     # def = 1
#cfg$gms$s32_hvarea <- 0 # def = 2



cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
cfg$gms$s21_stddev_lib_factor <- 0.5
# cfg$gms$s21_trade_tariff <- 0

start_run(cfg=cfg)



cfg$title   <- paste0("e1312TestBilatNew_NoTariff")


 cfg$gms$s21_trade_tariff <- 0

#start_run(cfg=cfg)


cfg$title   <- paste0("1312BilatImportRatio_RotConstraint_NoTariff")


cfg$gms$croparea    <- "detail_apr24"               # def = simple_apr24
cfg$gms$s30_rotation_scenario_start <- 2015    # def = 2025
cfg$gms$s30_implementation <- 0   # def = 0

#start_run(cfg=cfg)

#cfg$title   <- paste0("BilatPR8_OFF_T0")
#start_run(cfg=cfg)

#cfg$title   <- paste0("BilatPRFade_ON_fadeout")
#cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
#cfg$gms$s21_trade_tariff_fadeout <-1            # def =1

#start_run(cfg=cfg)


#cfg$title   <- paste0("BilatPRFade_ON_Nofadeout")
#cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
#cfg$gms$s21_trade_tariff_fadeout <-0          # def =1

#start_run(cfg=cfg)

#cfg$recalibrate_landconversion_cost <- "ifneeded"  #def "ifneeded"
#cfg$force_download = TRUE


#cfg$title   <- paste0("BilatPR8_ON_T0")
#cfg$gms$trade <- "selfsuff_reduced_bilateral22"             # def = selfsuff_reduced
#cfg$gms$s21_trade_tariff <- 0               # def =1

#cfg$recalibrate = TRUE
#cfg$recalibrate_landconversion_cost <- TRUE  #def "ifneeded"
#cfg$force_download = TRUE
#start_run(cfg=cfg)
