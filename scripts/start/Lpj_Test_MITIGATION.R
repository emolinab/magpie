######################################################################################
#### Script to start a MAgPIE run using different factor_costs realizations ##########
######################################################################################

library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

#Factor cost realizations
realization<-c("mixed_feb17")
#realization<-c("mixed_feb17")
climate<-c("cc","nocc")
gcms<-c("GFDL")
rcps<-c("70")
SSPs<-c("SSP1","SSP2","SSP3","SSP4","SSP5")
input<-c("rev4.59SmashingPumpkins_h12_validation_debug.tgz",
         "additional_data_rev3.99.tgz",
         "rev4.59SmashingPumpkins_h12_024608f1_cellularmagpie_debug.tgz",
         "rev4.59SmashingPumpkins_h12_magpie_debug.tgz",
         "additiona_stickyH12.tgz",
         "Zabel_SmPumH12.tgz")
calibration<-c("calibration_H12_NLP_mixed_feb17_SP_15Apr21.tgz")


aux<-0

for (g in gcms){
    for(r in realization){
      for(c in climate){
           for (s in SSPs){

             if(s == "SSP2"){
               mitigation_scenario<-c("BAU","POL")
             }else{
               mitigation_scenario<-c("BAU")
             }

            for (m in mitigation_scenario){

        #Title
        cfg$title<-paste0("LPJmL_SP_H12_",g,"_rcp",m,"_",r,"_",c,"_",s)

        #configuration of scenarios
        cfg <- setScenario(cfg,c(c,s))

        cfg$input <- c(input,calibration[1])

        #BAU or policy
        if (m == "BAU") {
          cfg$recalibrate <- TRUE
          cfg <- setScenario(cfg,c(s,"NPI"))
          cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-NPi"
          cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-NPi"

        } else if (m == "POL"){
          cfg$recalibrate <- FALSE
          cfg <- setScenario(cfg,c(s,"NDC"))
          cfg$gms$c56_pollutant_prices <- "SSPDB-SSP2-26-REMIND-MAGPIE"
          cfg$gms$c60_2ndgen_biodem <- "SSPDB-SSP2-26-REMIND-MAGPIE"
        }


        #Force download? recalibrate?
        cfg$force_download <- TRUE
        cfg$recalibrate <- FALSE

        #Factor costs realization
        cfg$gms$factor_costs <- r

        #priority
        cfg$qos <- "priority"
        cfg$output <- c("rds_report")


        start_run(cfg=cfg)
           }
          }
         }
        }
      }
