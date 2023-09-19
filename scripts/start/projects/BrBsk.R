library(magpie4)
library(lucode2)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$force_download <- TRUE
dir.create("output/c200_190923")
cfg$results_folder <- "output/c200_190923/:title:"

cfg$output <- c("rds_report")

scenarios<-c("ssp126",
             "ssp370",
             "ssp585"
           )

SSP <- c("SSP1",
         "SSP3",
         "SSP5"
       )

gcms<-c("GFDL-ESM4"#,
        #"MRI-ESM2-0",
        #"UKESM1-0-LL",
       #"MPI-ESM1-2-HR",
       #"IPSL-CM6A-LR"
      )

bioen_ghg<-list()
bioen_ghg[["ssp126"]]<-"R21M42-SSP1-PkBudg1300"
bioen_ghg[["ssp585"]]<-"R21M42-SSP5-NPI"
bioen_ghg[["ssp370"]]<-"R21M42-SSP2-NPI"

mit<-list()
mit[["ssp126"]]<-"ndc"
mit[["ssp585"]]<-"npi"
mit[["ssp370"]]<-"npi"

input_cellular<-c(ssp126="WARNINGS2_rev4.89+BrBsk+_8f7b9423_fdecee42_cellularmagpie_c200_GFDL-ESM4-ssp126_lpjml-c5bacf3f.tgz",
                  ssp370="WARNINGS1_rev4.89+BrBsk+_8f7b9423_18676c56_cellularmagpie_c200_GFDL-ESM4-ssp370_lpjml-c5bacf3f.tgz",
                  ssp585="WARNINGS2_rev4.89+BrBsk+_8f7b9423_87af5d79_cellularmagpie_c200_GFDL-ESM4-ssp585_lpjml-c5bacf3f.tgz")
                  
cfg$gms$sm_fix_cc <- 2020
cfg$gms$sm_fix_SSP2 <-2020

aux<-1

for(s in 1:length(scenarios)){
  for(g in 1:length(gcms)){
    climate<-if(gcms[g]=="GFDL-ESM4") c("cc","nocc_hist") else c("cc")
    for(c in 1:length(climate)){

      cfg <- gms::setScenario(cfg,c(climate[c],SSP[s]))


      cfg$input <- c(cellular    = input_cellular[scenarios[s]],
                     regional    = "rev4.89+BrBsk+_8f7b9423_magpie.tgz",
                     validation  = "rev4.89+BrBsk+_8f7b9423_validation.tgz",
                     additional  = "additional_data_rev4.07.tgz")
      
      cfg$input <- if(aux>1) c(cfg$input, calibration="calibration_h13_19Sep23.tgz")

      cfg$gms$factor_costs<- "sticky_feb18"
      cfg$force_download <- TRUE

      cfg$title <- paste0("BrBsk",scenarios[s],gcms[g],climate[c])


      cfg$gms$c56_pollutant_prices <- bioen_ghg[[scenarios[s]]]
      cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[scenarios[s]]]
      cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[scenarios[s]]]
      cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[scenarios[s]]]

      cfg$gms$c32_aff_policy<-mit[[scenarios[s]]]
      cfg$gms$c35_aolc_policy<-mit[[scenarios[s]]]
      cfg$gms$c35_ad_policy<-mit[[scenarios[s]]]

      cfg$recalc_npi_ndc <- TRUE
      cfg$qos <- "priority"

      start_run(cfg,codeCheck=FALSE)
      if (aux==1) magpie4::submitCalibration("H13")
    }
  }
}