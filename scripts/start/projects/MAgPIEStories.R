# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# ----------------------------------------------------------
# description: Sticky cost runs
# position: 5
# ----------------------------------------------------------


##### Version log (YYYYMMDD - Description - Author(s))
## v0.1 - 20200923 - Sticky cost runs - EMJB,AM

library(lucode2)
library(magclass)
library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")


#Inputs

# Sticky mode
mode <- c("dynamic")
#recalibrate

cfg$gms$sm_fix_cc <- 2015
cfg$gms$sm_fix_SSP2 <-2015

for(cc in c("cc","nocc")){
  for (sm in mode){


    calib<- "calibration_H12_sticky_feb18_dynamic_30Nov21.tgz"

    cfg$input <- c(cellular    = "rev4.65Paper_170122_8f7b9423_f2acbfe3_cellularmagpie_c200_UKESM1-0-LL-ssp585_lpjml-8e6c5eb1.tgz",
                   regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
                   validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation.tgz",
                   calibration  = "calibration_H13_ISIMIP_150122_15Jan22.tgz",
                   additional  = "additional_data_rev4.07.tgz",)



    cfg$force_download <- TRUE
    # Set cc
    cfg<-gms::setScenario(cfg,c(cc,"SSP5"))

    # Set factor costs
    cfg$gms$factor_costs     <-   "sticky_feb18"
    cfg$gms$c38_sticky_mode  <-   sm

    if (sm != "dynamic"){
    cfg$gms$c17_prod_init <- "off"
    }

    cfg$gms$c56_pollutant_prices <- "R21M42-SSP5-NPI"
    cfg$gms$c56_pollutant_prices_noselect <- "R21M42-SSP5-NPI"
    cfg$gms$c60_2ndgen_biodem <- "R21M42-SSP5-NPI"
    cfg$gms$c60_2ndgen_biodem_noselect <- "R21M42-SSP5-NPI"

    cfg$gms$c32_aff_policy<-"npi"
    cfg$gms$c35_aolc_policy<-"npi"
    cfg$gms$c35_ad_policy<-"npi"

    cfg$recalc_npi_ndc <- TRUE

    #Change the results folder name
    cfg$title<-paste0("Sticky_",sm,"_",cc,"_MAgPIEStories")
    cfg$qos <- "short"

    # Start run
    start_run(cfg=cfg)
}
}
