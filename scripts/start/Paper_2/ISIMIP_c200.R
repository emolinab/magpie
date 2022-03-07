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
dir.create("output/c200_ggcms_260122")
cfg$results_folder <- "output/c200_ggcms_070322/:title:"

#the high resolution can be adjusted in the output script "highres.R"
cfg$output <- c("rds_report","extra/disaggregation")

scenarios<-c("ssp126",
             "ssp585"
             #"ssp370"

           )

SSP <- c("SSP1",
         "SSP5"
         #"SSP3"
       )

gcms<-c("GFDL-ESM4",
        "MRI-ESM2-0",
        "UKESM1-0-LL",
        "MPI-ESM1-2-HR",
        "IPSL-CM6A-LR"
      )

ggcms<-c(#"EPIC-IIASA",
         #"pDSSAT",
         "LPjmL"#,
         #"CYGMA1p74"
       )

bioen_ghg<-list()
bioen_ghg[["ssp126"]]<-"R21M42-SSP1-PkBudg1300"
bioen_ghg[["ssp585"]]<-"R21M42-SSP5-NPI"
bioen_ghg[["ssp370"]]<-"R21M42-SSP2-NPI"

mit<-list()
mit[["ssp126"]]<-"ndc"
mit[["ssp585"]]<-"npi"
mit[["SSP370"]]<-"npi"


cell_input<-as.data.frame(read.csv("scripts/start/Paper_2/tgz_info_gg.csv"))

cfg$gms$sm_fix_cc <- 2015
cfg$gms$sm_fix_SSP2 <-2015

for (gg in ggcms){
for(s in 1:length(scenarios)){
  for(g in 1:length(gcms)){
    climate<-if(gcms[g]=="GFDL-ESM4" & gg=="LPjmL") c("cc","nocc_hist") else c("cc")
    for(c in 1:length(climate)){

      cfg <- gms::setScenario(cfg,c(climate[c],SSP[s]))


      cfg$input <- c(cellular    = as.character(subset(cell_input,rcp==scenarios[s] & gcm==gcms[g] & resolution == "c200" & ggcm==gg)[1,"name_tgz"]),
                     #cellular    = "rev4.64+ISIMIP_11102021_h12_23d4d8fb_cellularmagpie_c200_MRI-ESM2-0-ssp585_lpjml-e8ab65dd.tgz",
                     regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
                     validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation",
                     additional  = "additional_data_rev4.07.tgz",
                     calibration = "calibration_H13_ISIMIP_150122_15Jan22.tgz")

      cfg$gms$s13_ignore_tau_historical <- 1 #ignoring historical tau == 1
      cfg$gms$factor_costs<- "sticky_feb18"
      cfg$gms$c38_sticky_mode <- "dynamic"
      cfg$force_download <- TRUE

      cfg$title <- paste("Paper_260122_gg_ag_",gg,scenarios[s],gcms[g],climate[c],sep="_")


      cfg$gms$c56_pollutant_prices <- bioen_ghg[[scenarios[s]]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[scenarios[s]]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[scenarios[s]]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[scenarios[s]]]

      cfg$gms$c32_aff_policy<-mit[[scenarios[s]]]
      cfg$gms$c35_aolc_policy<-mit[[scenarios[s]]]
      cfg$gms$c35_ad_policy<-mit[[scenarios[s]]]

      cfg$recalc_npi_ndc <- TRUE

      #cfg <- gms::setScenario(cfg,"BASE")
      start_run(cfg,codeCheck=FALSE)
    }
  }
}
}
