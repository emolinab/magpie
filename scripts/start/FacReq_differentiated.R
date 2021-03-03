######################################################################################
#### Script to start a MAgPIE run using different factor_costs realizations ##########
######################################################################################

library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

realization<-c("sticky_feb18")
climate<-c("cc","nocc")



    for(j in 1:length(realization)){
      for(i in 1:length(climate)){

        #Change the results folder name
        #NBC STANDS FOR NEW BEST CALIBRATION
        cfg$title<-paste0("StickyDynamic_FR_GLO",realization[j],"_rcp6p0_",climate[i],"_")

        cfg <- setScenario(cfg,climate[i])

        cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp6p0-co2_rev50_c200_690d3718e151be1b450b394c1064b1c5.tgz",
                 "rev4.57_h12_magpie.tgz",
                 "rev4.57_h12_validation.tgz",
                 "additional_data_rev3.98.tgz",
                 "additional_sticky.tgz")

        #force download
        cfg$force_download <- TRUE
        #recalibrate
        cfg$recalibrate <- TRUE

        cfg$gms$factor_costs <- realization[j]

        #Climate impact or not

        start_run(cfg=cfg)
        }
}
