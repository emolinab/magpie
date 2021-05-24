######################################################################################
#### Script to start a MAgPIE run using different factor_costs realizations ##########
######################################################################################

library(gms)
library(magpie4)
library(magclass)
options(warn=-1)
# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

realization<-c("mixed_feb17")


combo<-c("7p0_CYGMA_GFDL",
        "8p5_CYGMA_UKESM",
        "8p5_pDSSAT_UKESM",
        "8p5_EPIC_UKESM",
        "7p0_EPIC_GFDL")

hashes_combos<-as.character(c("c6f10324",
                 "e61ed473",
                 "256c3ab7",
                 "c0547439",
                 "669b91c3"))

climate<-c("cc","nocc")

input<-c("additional_data_rev4.04.tgz",
               "rev4.59_h12_magpie.tgz",
               "rev4.59test_h12_validation.tgz")
calib1<-list()
calib2<-list()


calib1[["mixed_feb17"]][["7p0_CYGMA_GFDL"]]<-"calibration_ClIM_7p0_CYGMA_GFDL_mixed_feb17__21May21.tgz"
calib1[["mixed_feb17"]][["8p5_CYGMA_UKESM"]]<-"calibration_ClIM_8p5_CYGMA_UKESM_mixed_feb17__22May21.tgz"
calib1[["mixed_feb17"]][["8p5_pDSSAT_UKESM"]]<-"calibration_ClIM_8p5_pDSSAT_UKESM_mixed_feb17__22May21.tgz"
calib1[["mixed_feb17"]][["8p5_EPIC_UKESM"]]<-"calibration_ClIM_8p5_EPIC_UKESM_mixed_feb17__22May21.tgz"
calib1[["mixed_feb17"]][["7p0_EPIC_GFDL"]]<-"calibration_ClIM_7p0_EPIC_GFDL_mixed_feb17__22May21.tgz"

calib2[["free"]][["7p0_CYGMA_GFDL"]]<-"calibration_ClIM_7p0_CYGMA_GFDL_sticky_feb18_free_21May21.tgz"
calib2[["free"]][["8p5_CYGMA_UKESM"]]<-"calibration_ClIM_8p5_CYGMA_UKESM_sticky_feb18_free_22May21.tgz"
calib2[["free"]][["8p5_pDSSAT_UKESM"]]<-"calibration_ClIM_8p5_pDSSAT_UKESM_sticky_feb18_free_22May21.tgz"
calib2[["free"]][["8p5_EPIC_UKESM"]]<-"calibration_ClIM_8p5_EPIC_UKESM_sticky_feb18_free_22May21.tgz"
calib2[["free"]][["7p0_EPIC_GFDL"]]<-"calibration_ClIM_7p0_EPIC_GFDL_sticky_feb18_free_22May21.tgz"

calib2[["dynamic"]][["7p0_CYGMA_GFDL"]]<-"calibration_ClIM_7p0_CYGMA_GFDL_sticky_feb18_dynamic_22May21.tgz"
calib2[["dynamic"]][["8p5_CYGMA_UKESM"]]<-"calibration_ClIM_8p5_CYGMA_UKESM_sticky_feb18_dynamic_22May21.tgz"
calib2[["dynamic"]][["8p5_pDSSAT_UKESM"]]<-"calibration_ClIM_8p5_pDSSAT_UKESM_sticky_feb18_dynamic_22May21.tgz"
calib2[["dynamic"]][["8p5_EPIC_UKESM"]]<-"calibration_ClIM_8p5_EPIC_UKESM_sticky_feb18_dynamic_22May21.tgz"
calib2[["dynamic"]][["7p0_EPIC_GFDL"]]<-"calibration_ClIM_7p0_EPIC_GFDL_sticky_feb18_dynamic_24May21.tgz"


### Normal
for (i in realization){
  for (com in 1:length(combo)){

    if(i == "sticky_feb18"){
    sticky_modes<-c("dynamic","free")
  }else{
    sticky_modes<-c("")
  }

    for (so in sticky_modes) {
      for (c in climate){

          cfg<-gms::setScenario(cfg,c)
          #configurations
          cfg$title<-paste0("CcIm_",combo[com],"_",i,"_",so,"_",c,"_")

          if(i == "sticky_feb18"){

            cfg$input <- c(input,
                           calib2[[so]][[combo[com]]],
                           paste0("rev4.59SmashingPumpkins+ISIMIPyields_h12_",hashes_combos[com],"_cellularmagpie_debug.tgz"))

         }else if(i== "mixed_feb17"){

          cfg$input <- c(input,
                         calib1[["mixed_feb17"]][[combo[com]]],
                         paste0("rev4.59SmashingPumpkins+ISIMIPyields_h12_",hashes_combos[com],"_cellularmagpie_debug.tgz"))
          }


          cfg$output <- c("rds_report")
          cfg$gms$yields                       <- "managementcalib_aug19"
          cfg$gms$s14_yld_past_switch          <- 0.25
          cfg$gms$processing                   <- "substitution_may21"
          cfg$gms$c41_initial_irrigation_area  <- "LUH2v2"

          #Special modules
          cfg$gms$factor_costs <- i
          if(i == "sticky_feb18"){
          cfg$gms$c38_sticky_mode  <- so
           }


         start_run(cfg,codeCheck=FALSE)


       }
     }
   }
}
