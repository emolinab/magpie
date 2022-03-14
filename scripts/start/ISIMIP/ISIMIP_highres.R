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
  #for (ru in 1:length(runs)){
for (ru in c(1:14,16:18)){

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

  ################ c200 files preparation ############################################################################################################
    #get trade pattern,tc, and afforestation from low resolution run with c200
    folder<-"/p/projects/landuse/users/mbacca/Additional_data_sets/"
    runName<-paste(rcp_re[ru],gcm_re[ru],cc_re[ru],sep="_")
    dir.create(paste0(folder,runName))
    gdx<-paste0("//p/projects/magpie/data/ISIMIP/ISIMIP_100322/magpie/output/c200_110322/",
              as.character(subset(c200_Runs,rcp==rcp_re[ru] & gcm==gcm_re[ru] & scenario==cc_re[ru])[1,"name"]),
              "/fulldata.gdx")
      ov_prod_reg <- readGDX(gdx,"ov_prod_reg",select=list(type="level"))
      ov_supply <- readGDX(gdx,"ov_supply",select=list(type="level"))
      f21_trade_balance <- ov_prod_reg - ov_supply
      write.magpie(round(f21_trade_balance,6),file_name=paste0(folder,runName,"/","/f21_trade_balance.cs3"))
      #tc
      ov_tau <- readGDX(gdx, "ov_tau",select=list(type="level"))
      write.magpie(round(ov_tau,6),paste0(folder,runName,"/","/f13_tau_scenario.csv"))
      #afforestation
      #get regional afforestation patterns from low resolution run with c200
       aff <- dimSums(landForestry(gdx)[,,c("aff","ndc")],dim=3)
       #Take away initial NDC area for consistency with global afforestation limit
       aff <- aff-setYears(aff[,1,],NULL)
       #calculate maximum regional afforestation over time
       aff_max <- setYears(aff[,1,],NULL)
       for (r in getRegions(aff)) {
         aff_max[r,,] <- max(aff[r,,])
       }
       aff_max[aff_max<0] <- 0
       write.magpie(aff_max,file_name=paste0(folder,runName,"/","/f32_max_aff_area.cs4"))

      gms::tardir(dir=paste0(folder,runName,"/"),
      tarfile=paste0(folder,runName,".tgz"))

  ###################################################################################################################################################

      title<-paste("ISIMIP_140322_T_",rcp_re[ru],gcm_re[ru],cc_re[ru],re,sep="_")
        dir.create(paste0("output/",re,"_140322/"))
      cfg$results_folder <- paste0("output/",re,"_140322/",title)
      cfg <- gms::setScenario(cfg,c(cc,SSPs[[rcp]],"ForestryEndo"))

      cfg$input <- c(cellular    = as.character(subset(cell_input,rcp==rcp_re[ru] & gcm==gcm_re[ru] & resolution == re)[1,"name_tgz"]),
                     regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
                     validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation.tgz",
                     additional  = "additional_data_rev4.07.tgz",
                     calibration = "caib_H13_ISIMIP_11Mar22.tgz",
                     patch = paste0(runName,".tgz"))

      cfg$gms$s13_ignore_tau_historical <- 1 #ignoring historical tau ==1
      cfg$gms$factor_costs<- "sticky_feb18"
      cfg$gms$c38_sticky_mode <- "dynamic"
      cfg$force_replace <- TRUE
      cfg$recalc_npi_ndc <- TRUE


      cfg$title <- title

      cfg$gms$c56_pollutant_prices <- bioen_ghg[[rcp_re[ru]]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[rcp_re[ru]]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[rcp_re[ru]]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[rcp_re[ru]]]

      #cfg <- gms::setScenario(cfg,"BASE")
      cfg$gms$c32_aff_policy<-mit[[rcp]]
      cfg$gms$c35_aolc_policy<-mit[[rcp]]
      cfg$gms$c35_ad_policy<-mit[[rcp]]

      #### Fixed parameters
      cfg$gms$trade <- "exo"
      cfg$gms$tc <- "exo"
      cfg$gms$c32_max_aff_area <- "regional"
      #check
      if(cfg$gms$s32_max_aff_area < Inf) {
        indicator <- abs(sum(aff_max)-cfg$gms$s32_max_aff_area)
        if(indicator > 1e-06) warning(paste("Global and regional afforestation limit differ by",indicator,"Mha"))
      }

      #parallel

      cfg$gms$optimization <- "nlp_par"
      #cfg$gms$s80_maxiter <- 10
      cfg$qos <- "short_maxMem"
      start_run(cfg,codeCheck=FALSE)
}
}
