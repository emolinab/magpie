######################################################################################
#### Script to start a MAgPIE run using different factor_costs realizations ##########
######################################################################################

library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

realization<-c("mixed_feb17","sticky_feb18")


    for(j in 1:length(realization)){

        #Change the results folder name
        #NBC STANDS FOR NEW BEST CALIBRATION
        cfg$title<-paste0("FacReq_region_differentiated_",realization[j],"_rcp6p0_cc_ON")

        cfg <- setScenario(cfg,"cc")

        cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp2p6-co2_rev50_c200_690d3718e151be1b450b394c1064b1c5.tgz",
                 "rev4.52_h12_magpie.tgz",
                 "rev4.52_h12_validation.tgz",
                 "additional_data_rev3.89.tgz",
                 "additionl_regional_differentiated.tgz")

        #recalibrate
        cfg$recalibrate <- TRUE

        cfg$gms$factor_costs <- realization[j]

        #Climate impact or not

        start_run(cfg=cfg)
        }
