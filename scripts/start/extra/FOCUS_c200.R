# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de


# ----------------------------------------------------------
# description: Start a set of runs with default and high resolution
# ----------------------------------------------------------

library(magpie4)
library(lucode2)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$force_download <- TRUE
dir.create("output/FOCUS_310522")
cfg$results_folder <- "output/FOCUS_310522/:title:"

#the high resolution can be adjusted in the output script "highres.R"
cfg$output <- c("rds_report","extra/disaggregation")

scenarios<-c("SSP1",
            "SSP2",
            "SSP3")

bioen_ghg<-list()

bioen_ghg[["SSP1"]]<-"R21M42-SSP1-PkBudg1300"
bioen_ghg[["SSP2"]]<-"R21M42-SSP2-NPI"
bioen_ghg[["SSP3"]]<-"R21M42-SSP2-NPI"

mit<-list()
mit[["SSP1"]]<-"ndc"
mit[["SSP2"]]<-"npi"
mit[["SSP3"]]<-"npi"


cfg$gms$sm_fix_cc <- 2015
cfg$gms$sm_fix_SSP2 <-2015

 for(s in scenarios){

      cfg <- gms::setScenario(cfg,c("nocc_hist",s))

      cellular<- if(s=="SSP1") "rev4.72+FOCUS_h12_6819938d_cellularmagpie_c200_MRI-ESM2-0-ssp126_lpjml-8e6c5eb1.tgz" else if (s=="SSP2")
                               "rev4.72+FOCUS_h12_1b5c3817_cellularmagpie_c200_MRI-ESM2-0-ssp245_lpjml-8e6c5eb1.tgz" else if (s=="SSP3")
                               "rev4.72+FOCUS_h12_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz"

      cfg$input <- c(cellular    = cellular,
                     regional    = "rev4.72_h12_magpie.tgz",
                     validation  = "rev4.72_h12_validation.tgz",
                     additional  = "additional_data_rev4.17.tgz",
                     calibration = "calibration_H12_sticky_feb18_28May22.tgz")

      cfg$gms$s13_ignore_tau_historical <- 1 #ignoring historical tau == 1
      cfg$gms$factor_costs<- "sticky_feb18"
      cfg$force_download <- TRUE

      cfg$title <- paste("FOCUS_310522",s,sep="_")


      cfg$gms$c56_pollutant_prices <- bioen_ghg[[s]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[s]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[s]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[s]]

      cfg$gms$c32_aff_policy<-mit[[s]]
      cfg$gms$c35_aolc_policy<-mit[[s]]
      cfg$gms$c35_ad_policy<-mit[[s]]

      cfg$recalc_npi_ndc <- TRUE

      #cfg <- gms::setScenario(cfg,"BASE")
      start_run(cfg,codeCheck=FALSE)
    }
