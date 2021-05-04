######################################################################################
#### Script to start a MAgPIE run using different factor_costs realizations ##########
######################################################################################

library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

input1<-list()
calibration_mixed<-list()
calibration_sticky<-list()

#Factor cost realizations
#realization<-c("mixed_feb17")
realization<-c("sticky_feb18")
climate<-c("cc","nocc")
SSPs<-c("SSP2")
#SP1<-c("SP_new","SP_old")
SP1<-c("EPIC")

input1[["EPIC"]] <- c("rev4.59SmashingPumpkins+ISIMIPyieldsTEST+ISIMIPyields_EPIC-IIASA:ukesm1-0-ll:ssp585:default_h12_df1b093f_cellularmagpie_debug.tgz",
         "rev4.59SmashingPumpkins+ISIMIPyieldsTEST+ISIMIPyields_EPIC-IIASA:ukesm1-0-ll:ssp585:default_h12_magpie_debug.tgz",
         "rev4.59SmashingPumpkins+ISIMIPyieldsTEST+ISIMIPyields_EPIC-IIASA:ukesm1-0-ll:ssp585:default_h12_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "additiona_stickyH12.tgz",
         "Zabelirrig_SP.tgz"
       )#

#calibration_mixed[["mixed_feb17"]][["SP_old"]]<-"calibration_SP_old_mixed_feb17___19Apr21.tgz"
calibration_mixed[["mixed_feb17"]][["EPIC"]]<-"calibration_H12_EPIC_mixed_feb17__03May21.tgz"

calibration_sticky[["EPIC"]][["dynamic"]]<-"calibration_H12_EPIC_sticky_feb18_dynamic_03May21.tgz"
calibration_sticky[["EPIC"]][["free"]]<-"calibration_H12_EPIC_sticky_feb18_free_03May21.tgz"

  for(sp in SP1){
    for(r in realization){
      for(c in climate){

       if(r == "mixed_feb17"){
          sticky_mode<-c("free")
        }else{
          sticky_mode<-c("dynamic")
        }
        #sticky_mode<-c("free")

        for (so in sticky_mode){
           for (s in SSPs){

             if(s == "SSP2"){
               #mitigation_scenario<-c("BAU","POL")
               mitigation_scenario<-c("BAU")
             }else{
               mitigation_scenario<-c("BAU")
             }

            for (m in mitigation_scenario){

        #Title
        if (r == "mixed_feb17"){
          cfg$title<-paste0("LPJ_EPIC_",sp,"_",r,"_",c,"_",m,"_")
        }else{
          cfg$title<-paste0("LPJ_EPIC_",sp,"_",r,"_",so,"_",c,"_",m,"_")
        }



        if (r == "mixed_feb17"){
          cfg$input <-c(input1[[sp]],calibration_mixed[["mixed_feb17"]][[sp]])
        }else{
          cfg$input <-c(input1[[sp]],calibration_sticky[[sp]][[so]])
        }



        #BAU or policy
        if (m == "BAU") {
          cfg <- setScenario(cfg,c(c,s,"NPI"))
          cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-NPi"
          cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-NPi"

        } else if (m == "POL"){
          cfg <- setScenario(cfg,c(c,s,"NDC"))
          cfg$gms$c56_pollutant_prices <- "SSPDB-SSP2-26-REMIND-MAGPIE"
          cfg$gms$c60_2ndgen_biodem <- "SSPDB-SSP2-26-REMIND-MAGPIE"
        }


        #Force download? recalibrate?
        cfg$force_download <- TRUE
        cfg$recalibrate <- FALSE

        #Factor costs realization
        cfg$gms$factor_costs <- r
        cfg$gms$c38_sticky_mode <- so

        #priority
        cfg$output <- c("rds_report")


        start_run(cfg=cfg)
           }
          }
         }
        }
      }
    }
