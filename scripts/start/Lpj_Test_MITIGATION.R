######################################################################################
#### Script to start a MAgPIE run using different factor_costs realizations ##########
######################################################################################

library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

#Factor cost realizations
realization<-c("mixed_feb17","sticky_feb18")
climate<-c("cc","nocc")
gcms<-c("GFDL")
rcps<-c("70")
SSPs<-c("SSP1","SSP2","SSP3","SSP4","SSP5")


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
        cfg$title<-paste0("T_LPJmL5_",g,"_rcp",m,"_",r,"_",c,"_",s)

        #configuration of scenarios
        cfg <- setScenario(cfg,c(c,s))

        if(realization[j]=="sticky_feb18") {
          #this could be extended for different gcms and rcps
          cfg$input <- c("rev4.58_h12_validation.tgz",
                   "additional_data_rev3.98.tgz",
                   "rev4.58+mrmagpie_LPJmL_new_h12_ee4336a969c590c612a80f2a9db04bdc_cellularmagpie_debug.tgz",
                   "rev4.58+mrmagpie_LPJmL_new_h12_magpie_debug.tgz",
                    "newlpj_sticky__120321.tgz")

        }else if (realization[j]=="mixed_feb17"){
          cfg$input <- c("rev4.58_h12_validation.tgz",
                   "additional_data_rev3.98.tgz",
                   "rev4.58+mrmagpie_LPJmL_new_h12_ee4336a969c590c612a80f2a9db04bdc_cellularmagpie_debug.tgz",
                   "rev4.58+mrmagpie_LPJmL_new_h12_magpie_debug.tgz",
                   "newlpj_mixed_120321.tgz")

        }

        #BAU or policy
        if (mitigation_scenario == "BAU") {
          cfg$recalibrate <- TRUE
          cfg <- setScenario(cfg,c(s,"NPI"))
          cfg$gms$c56_pollutant_prices <- "R2M41-SSP2-NPi"
          cfg$gms$c60_2ndgen_biodem <- "R2M41-SSP2-NPi"

        } else if (mitigation_scenario == "POL"){
          cfg$recalibrate <- FALSE
          cfg <- setScenario(cfg,c(s,"NDC"))
          cfg$gms$c56_pollutant_prices <- "SSPDB-SSP2-26-REMIND-MAGPIE"
          cfg$gms$c60_2ndgen_biodem <- "SSPDB-SSP2-26-REMIND-MAGPIE"
        }


        #Force download?
        cfg$force_download <- TRUE

        #Factor costs realization
        cfg$gms$factor_costs <- realization[j]

        #priority
        cfg$qos <- "priority"


        start_run(cfg=cfg)
           }
          }
         }
        }
      }
