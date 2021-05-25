library(gms)
library(magpie4)
library(magclass)
options(warn=-1)
# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")

source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")


 combo<-c("7p0_LPJML_GFDL_")
 climate<-c("cc")#,"nocc"
 realization<-c("sticky_feb18")#,"mixed_feb17"

 input <- c("additional_data_rev4.04.tgz",
                        "rev4.59_h12_magpie.tgz",
                        "rev4.59_h12_c5cdbf33_cellularmagpie_c200_GFDL-ESM4-ssp370_lpjml-47a77da3.tgz",
                        "rev4.59test_h12_validation.tgz",
                        "tau_scenario_lp.tgz")

 calib1<-list()
 calib2<-list()

 calib1[["mixed_feb17"]]<-"calibration_ClIM_7p0_LPJML_GFDL__mixed_feb17__21May21.tgz"
 calib2[["sticky_feb18"]][["dynamic"]]<-"calibration_ClIM_7p0_LPJML_GFDL__sticky_feb18_dynamic_21May21.tgz"
 calib2[["sticky_feb18"]][["free"]]<-"calibration_ClIM_7p0_LPJML_GFDL__sticky_feb18_free_22May21.tgz"



### Normal
for (i in realization){
  for (com in combo){

    if(i == "sticky_feb18"){
    sticky_modes<-c("dynamic")#,"free"
  }else{
    sticky_modes<-c("")
  }

    for (so in sticky_modes) {
      for (c in climate){

          cfg<-gms::setScenario(cfg,c)
          #configurations
          cfg$title<-paste0("CcIm_TauExo_",com,"_",i,"_",so,"_",c,"_")
          cfg$repositories <- append(list("https://rse.pik-potsdam.de/data/magpie/public"=NULL,
                                "/p/projects/landuse/users/mbacca/Additional_data_sets"=NULL),
                           getOption("magpie_repos"))


          if(i == "sticky_feb18"){

            cfg$input <- c(input#,
                           #calib2[["sticky_feb18"]][[so]]
                         )

         }else if(i== "mixed_feb17"){

          cfg$input <- c(input,
                         calib1[["mixed_feb17"]])
          }


          cfg$output <- c("rds_report")
          cfg$gms$yields                       <- "managementcalib_aug19"
          cfg$gms$s14_yld_past_switch          <- 0.25
          cfg$gms$processing                   <- "substitution_may21"
          cfg$gms$c41_initial_irrigation_area  <- "LUH2v2"
          #cfg$gms$s14_limit_calib <- 0

          #Special modules
          cfg$gms$factor_costs <- i
          if(i == "sticky_feb18"){
          cfg$gms$c38_sticky_mode  <- so
           }
           cfg$gms$tc <- "exo"


         start_run(cfg,codeCheck=FALSE)


       }
     }
   }
}
