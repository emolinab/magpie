# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

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


#the high resolution can be adjusted in the output script "highres.R"
cfg$output <- c("rds_report","extra/disaggregation")

scenarios<-c("ssp126",
             "ssp370",
             "ssp585"
           )

gcms<-c("GFDL-ESM4",
        "MRI-ESM2-0",
        "UKESM1-0-LL",
        "MPI-ESM1-2-HR",
        "IPSL-CM6A-LR"
      )

bioen_ghg<-list()
bioen_ghg[["ssp126"]]<-"R21M42-SSP1-PkBudg1300"
bioen_ghg[["ssp585"]]<-"R21M42-SSP5-NPI"
bioen_ghg[["ssp370"]]<-"R21M42-SSP2-NPI"

SSPs<-list()
SSPs[["ssp126"]]<-"SSP1"
SSPs[["ssp585"]]<-"SSP5"
SSPs[["ssp370"]]<-"SSP3"

mit<-list()
mit[["ssp126"]]<-"ndc"
mit[["ssp585"]]<-"npi"
mit[["ssp370"]]<-"npi"

cell_input<-as.data.frame(read.csv("scripts/start/ISIMIP/tgz_info.csv"))
c200_Runs<-as.data.frame(read.csv("scripts/start/ISIMIP/runs_names.csv"))

rcp<-NULL
gcm<-NULL
cc<-NULL

rcp_re<-NULL
gcm_re<-NULL
cc_re<-NULL

runs<-as.character(c200_Runs$name)
cfg$gms$sm_fix_cc <- 2015
cfg$gms$sm_fix_SSP2 <-2015

resolution<-c("c1000")

for(re in resolution){
  for (ru in 1:length(runs)){

  dir.create("output/",re)
  cfg$results_folder <- paste0("output/",re,"_260122/:title:")


  for (s in scenarios){
  rcp<- if(grepl(s, runs[ru], fixed=TRUE)) s else rcp
  }

  for (g in gcms){
  gcm<-if(grepl(g, runs[ru], fixed=TRUE)) g else gcm
  }

  for (c in c("cc","nocc_hist")){
  cc<-if(grepl(c, runs[ru], fixed=TRUE)) c else cc
  }

     rcp_re[ru]<-rcp
     gcm_re[ru]<-gcm
     cc_re[ru]<-cc

      cfg <- gms::setScenario(cfg,c(cc,SSPs[[rcp]]))

      cfg$input <- c(cellular    = as.character(subset(cell_input,rcp==rcp_re[ru] & gcm==gcm_re[ru] & resolution == re)[1,"name_tgz"]),
                     regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
                     validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation",
                     additional  = "additional_data_rev4.07.tgz",
                     calibration = "calibration_H13_ISIMIP_150122_15Jan22.tgz")

      cfg$gms$s13_ignore_tau_historical <- 1 #ignoring historical tau ==1
      cfg$gms$factor_costs<- "sticky_feb18"
      cfg$gms$c38_sticky_mode <- "dynamic"
      cfg$force_download <- TRUE

      cfg$title <- paste("ISIMIP_260122_",rcp_re[ru],gcm_re[ru],cc_re[ru],re,sep="_")

      cfg$gms$c56_pollutant_prices <- bioen_ghg[[rcp_re[ru]]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[rcp_re[ru]]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[rcp_re[ru]]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[rcp_re[ru]]]

      #get trade pattern from low resolution run with c200
      gdx<-paste0("output/c200_260122/",as.character(subset(c200_Runs,rcp==rcp_re[ru] & gcm==gcm_re[ru] & scenario==cc_re[ru])[1,"name"]),"/fulldata.gdx")
      ov_prod_reg <- readGDX(gdx,"ov_prod_reg",select=list(type="level"))
      ov_supply <- readGDX(gdx,"ov_supply",select=list(type="level"))
      f21_trade_balance <- ov_prod_reg - ov_supply
      write.magpie(round(f21_trade_balance,6),paste0("modules/21_trade/input/f21_trade_balance.cs3"))

      #cfg <- gms::setScenario(cfg,"BASE")
      cfg$gms$c32_aff_policy<-mit[[scenarios[s]]]
      cfg$gms$c35_aolc_policy<-mit[[scenarios[s]]]
      cfg$gms$c35_ad_policy<-mit[[scenarios[s]]]

      cfg$recalc_npi_ndc <- TRUE

      #parallel
      cfg$gms$trade <- "exo"
      cfg$gms$optimization <- "nlp_par"
      #cfg$gms$s80_maxiter <- 10
      #cfg$qos <- "priority"
      start_run(cfg,codeCheck=FALSE)
}
}
