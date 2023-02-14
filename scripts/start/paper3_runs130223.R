# |  (C) 2008-2023 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ------------------------------------------------
# description: start run with default.cfg settings
# position: 1
# ------------------------------------------------
library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")


###<-
inputs_cell<-list()
inputs_reg<-list()
inputs_cell[["gs_ON"]]<-"rev4.79+Test_histT_gsadapt_ssp370_MRI-ESM2-0_8f7b9423_a488bcdd_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-c44114ba.tgz"
inputs_cell[["gs_OFF"]]<-"rev4.79+Test_histT_ssp370_MRI-ESM2-0_8f7b9423_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz"
inputs_reg[["gs_ON"]]<-"WARNINGS1_rev4.79+Test_histT_ssp370_MRI-ESM2-0_8f7b9423_magpie.tgz"
inputs_reg[["gs_OFF"]]<-"WARNINGS1_rev4.79+Test_histT_ssp370_MRI-ESM2-0_8f7b9423_magpie.tgz"

bioen_ghg <- list()
bioen_ghg[["SSP3"]] <- "R21M42-SSP2-NPI"
cfg$gms$sm_fix_cc <- 2020
cfg$gms$sm_fix_SSP2 <- 2020

mit <- list()
mit[["ssp370"]]<-"npi"

cfg$results_folder <- "output/:title:"
cfg$recalibrate <- TRUE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$force_download <- TRUE

#Base run
#     cfg <- gms::setScenario(cfg, c("nocc_hist","SSP3"))
#     scen<-paste0("gs_OFF")
# cfg$input <- c(regional    = inputs_reg[[scen]],
#                cellular   = inputs_cell[[scen]],
#                validation  = "rev4.79+Test_histT_ssp370_MRI-ESM2-0_8f7b9423_validation.tgz",
#                additional  = "additional_data_rev4.36.tgz")
#
# cfg$gms$factor_costs <- "sticky_feb18"
# cfg$best_calib <- TRUE
# cfg$best_calib_landconversion_cost <- TRUE
# cfg$gms$s38_depreciation_rate <- 0.03
# cfg$gms$s38_immobile <- 0
#
#     cfg$title <- "P3T130223_baseScenario_nocc_dep03_mobile-gsadapt_OFF"
#
#     cfg$gms$c56_pollutant_prices <- bioen_ghg[["SSP3"]]
#       cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[["SSP3"]]
#       cfg$gms$c60_2ndgen_biodem <- bioen_ghg[["SSP3"]]
#       cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[["SSP3"]]
#
#       cfg$gms$c32_aff_policy<-mit[["ssp370"]]
#       cfg$gms$c35_aolc_policy<-mit[["ssp370"]]
#       cfg$gms$c35_ad_policy<-mit[["ssp370"]]
#
#     start_run(cfg)
#     magpie4::submitCalibration("H13_mobile_gsadapt_OFF")


# Base run + climate change

   cfg <- gms::setScenario(cfg, c("cc","SSP3"))
    scen<-paste0("gs_OFF")
cfg$input <- c(inputs_reg    = inputs_reg[[scen]],
               inputs_cell   = inputs_cell[[scen]],
               validation  = "rev4.79+Test_histT_ssp370_MRI-ESM2-0_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.36.tgz",
#####<-
               calibration = "calibration_H13_mobile_gsadapt_OFF_13Feb23.tgz")

cfg$gms$factor_costs <- "sticky_feb18"
cfg$gms$s38_depreciation_rate <- 0.03
cfg$gms$s38_immobile <- 0

    cfg$title <- "P3T130223_baseScenario_+cc_dep03_mobile-gsadapt_OFF"

    cfg$gms$c56_pollutant_prices <- bioen_ghg[["SSP3"]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[["SSP3"]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[["SSP3"]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[["SSP3"]]

      cfg$gms$c32_aff_policy<-mit[["ssp370"]]
      cfg$gms$c35_aolc_policy<-mit[["ssp370"]]
      cfg$gms$c35_ad_policy<-mit[["ssp370"]]

    start_run(cfg)

#Base run + climate change + gsadapt
    cfg <- gms::setScenario(cfg, c("cc","SSP3"))
    scen<-paste0("gs_ON")
cfg$input <- c(inputs_reg    = inputs_reg[[scen]],
               inputs_cell   = inputs_cell[[scen]],
               validation  = "rev4.79+Test_histT_ssp370_MRI-ESM2-0_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.36.tgz")

cfg$gms$factor_costs <- "sticky_feb18"
cfg$best_calib <- TRUE
cfg$best_calib_landconversion_cost <- TRUE
cfg$gms$s38_depreciation_rate <- 0.03
cfg$gms$s38_immobile <- 0

    cfg$title <- "P3T130223_baseScenario_+cc_dep03_mobile+gsadapt_ON"

    cfg$gms$c56_pollutant_prices <- bioen_ghg[["SSP3"]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[["SSP3"]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[["SSP3"]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[["SSP3"]]

      cfg$gms$c32_aff_policy<-mit[["ssp370"]]
      cfg$gms$c35_aolc_policy<-mit[["ssp370"]]
      cfg$gms$c35_ad_policy<-mit[["ssp370"]]

    start_run(cfg)
    magpie4::submitCalibration("H13_mobile_gsadapt_ON")

#Base run + climate change + gsadapt + immobile

    cfg <- gms::setScenario(cfg, c("cc","SSP3"))
    scen<-paste0("gs_ON")
cfg$input <- c(inputs_reg    = inputs_reg[[scen]],
               inputs_cell   = inputs_cell[[scen]],
               validation  = "rev4.79+Test_histT_ssp370_MRI-ESM2-0_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.36.tgz")

cfg$gms$factor_costs <- "sticky_feb18"
cfg$best_calib <- TRUE
cfg$best_calib_landconversion_cost <- TRUE
cfg$gms$s38_depreciation_rate <- 0.03
cfg$gms$s38_immobile <- 1

    cfg$title <- "P3T130223_baseScenario_+cc_dep03_immobile+gsadapt_ON"

    cfg$gms$c56_pollutant_prices <- bioen_ghg[["SSP3"]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[["SSP3"]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[["SSP3"]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[["SSP3"]]

      cfg$gms$c32_aff_policy<-mit[["ssp370"]]
      cfg$gms$c35_aolc_policy<-mit[["ssp370"]]
      cfg$gms$c35_ad_policy<-mit[["ssp370"]]

    start_run(cfg)
    magpie4::submitCalibration("H13_immobile_gsadapt_ON")
