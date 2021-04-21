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
#realization<-c("mixed_feb17")
climate<-c("cc","nocc")
#sticky_modes<-c("regional","dynamic","free")
sticky_modes<-c("dynamic","free")
SmashPump<-c()

inputs<-c("rev4.58_h12_validation.tgz",
         "additional_data_rev3.98.tgz",
         "rev4.59+mrmagpie_LPJmL_new2_h12_5e4fb8e4d1e7450f19bf2d682b4a8338_cellularmagpie_debug.tgz",
         "rev4.59+mrmagpie_LPJmL_new2_h12_magpie_debug.tgz",
         "additional_sticky.tgz")
#calib<-c("calibration_H12_sticky_regional_18Mar21.tgz",
#        "calibration_H12_sticky_dynamic_18Mar21.tgz",
#        "calibration_H12_sticky_free_18Mar21.tgz")
calib<-c("calib_manual.tgz")


    for(r in realization){
      for(c in climate){
            for (so in 1:length(sticky_modes)){

        #Title
        cfg$title<-paste0("Sticky_LPJmL5_manualcalib",sticky_modes[so],"_",c,"_")

        #configuration of scenarios
        cfg <- setScenario(cfg,c)

        #this could be extended for different gcms and rcps
          cfg$input <- c(inputs,calib[so])


        #Force download? recalibrate?
        cfg$force_download <- TRUE
        cfg$recalibrate <- FALSE

        #Factor costs realization
        cfg$gms$factor_costs <- r

        #Way to operate sticky
        cfg$gms$c38_sticky_mode  <- sticky_modes[so]

        #priority
        #cfg$qos <- "priority"
        cfg$output <- c("rds_report")


        start_run(cfg=cfg)
           }
          }
         }
