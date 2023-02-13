# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
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

factor_req <- c("sticky_feb18","per_ton_fao_may22")
gsadapt <- c(TRUE, FALSE)
ssp <- c("SSP5") # higher trade balance reduction
climate<-c("cc","nocc_hist")

###<-
inputs_cell<-list()
inputs_reg<-list()
inputs_cell[["gs_TRUE"]]<-
inputs_cell[["gs_FALSE"]]<-
inputs_reg[["gs_TRUE"]]<-
inputs_reg[["gs_FALSE"]]<-

bioen_ghg <- list()
bioen_ghg[["SSP5"]] <- "R21M42-SSP5-NPI"

mit <- list()
mit[["ssp585"]]<-"npi"

cfg$results_folder <- "output/:title:"
cfg$recalibrate <- TRUE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$force_download <- TRUE

#NoCC Runs

for(f in factor_req){
   for (g in gsadapt){
    for (s in ssp){
    for (cl in climate){

    cfg <- gms::setScenario(cfg,c(cl,s))
    scen<-paste0("gs_",g)

###<-
cfg$input <- c(inputs_reg    = inputs_reg[[scen]],
               inputs_cell   = inputs_cell[[scen]],
               validation  = "rev4.77+Test_P3_gsadapt2_ssp585_MRI-ESM2-0_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.36.tgz")
   
cfg$gms$factor_costs <- f
cfg$best_calib <- TRUE
cfg$gms$s38_depreciation_rate <- 0.03

    cfg$title <- paste("P3T3",f,s,"gsadapt",g,cl,sep = "_")

    cfg$gms$c56_pollutant_prices <- bioen_ghg[[s]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[s]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[s]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[s]]

      cfg$gms$c32_aff_policy<-mit[[s]]
      cfg$gms$c35_aolc_policy<-mit[[s]]
      cfg$gms$c35_ad_policy<-mit[[s]]

    start_run(cfg)

    if(cl=="cc" && s=="SSP5"){
    magpie4::submitCalibration(paste("H13",f,"gsadapt",g,sep = "_"))
    }
   }
}
   }
}

### tgz preparation and read in of Tau NoCC

folder<-"/p/projects/landuse/users/mbacca/Additional_data_sets/"
###<-
folder_runs<-""

runs<-c("P3T3_sticky_feb18_SSP5_gsadapt_TRUE_nocc_hist",
        "P3T3_sticky_feb18_SSP5_gsadapt_FALSE_nocc_hist")
        
    for(r in runs){
    
    runName<-r
    if(!file.exists(paste0(folder,runName,".tgz"))){
    dir.create(paste0(folder,runName))

    ####<-

    gdx<-paste0(folder_runs,"/",runName,"/fulldata.gdx")
      #tc
      ov_tau <- readGDX(gdx, "ov_tau",select=list(type="level"))
      write.magpie(round(ov_tau,6),paste0(folder,runName,"/","/f13_tau_scenario.csv"))
      gms::tardir(dir=paste0(folder,runName,"/"),
      tarfile=paste0(folder,runName,".tgz"))
    }
    }

###<-
calibration<-list()
calibration[["gsadapt_TRUE"]][["sticky_feb18"]]<-
calibration[["gsadapt_TRUE"]][["per_ton_fao_may22"]]<-
calibration[["gsadapt_FALSE"]][["sticky_feb18"]]<-
calibration[["gsadapt_FALSE"]][["per_ton_fao_may22"]]<-

for(f in factor_req){
   for (g in gsadapt){


    runName<-paste0("P3T3_",f,"_SSP5_gsadapt_",g,"_nocc_hist")
    cfg <- gms::setScenario(cfg,c("cc","SSP5"))
    scen<-paste0("gs_",g)

###<-
cfg$input <- c(inputs_reg    = inputs_reg[[scen]],
               inputs_cell   = inputs_cell[[scen]],
               validation  = "rev4.77+Test_P3_gsadapt2_ssp585_MRI-ESM2-0_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.36.tgz"
               calibration = calibration[[scen]][[f]],
               patch =paste0(folder,"/",runName,".tgz"))
   
cfg$gms$factor_costs <- f
cfg$gms$tc <- "exo"

cfg$gms$s38_depreciation_rate <- 0.03

    cfg$title <- paste("P3T3",f,s,"gsadapt",g,cl,sep = "_")
    start_run(cfg)

    if(cl=="cc" && s=="SSP5"){
    magpie4::submitCalibration(paste("H13",f,"gsadapt",g,sep = "_"))
    }
   }
}
