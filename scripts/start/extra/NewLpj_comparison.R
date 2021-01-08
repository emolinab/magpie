######################################################################################
#### Script to start a MAgPIE run using different factor_costs realizations ##########
######################################################################################

library(gms)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")

# Sources the default configuration file
source("config/default.cfg")

#List of clusterin types
#clustering<-c("n200","c200")
clustering<-c("c200")

#Factor cost realizations
realization<-c("mixed_feb17")


for (k in 1:length(climate)){
    for(j in 1:length(realization)){

        #Change the results folder name
        #NBC STANDS FOR NEW BEST CALIBRATION
        cfg$title<-paste0("OldLPJ",realization[j],"_rcp6p0_",climate[k])

        cfg <- setScenario(cfg,climate[k])

        cfg$input <- c("rev4.51+mrmagpie10_h12_magpie_debug.tgz",
                       "rev4.51+mrmagpie8_h12_cfc9a5551f05ca4efc6cbc7016516432_cellularmagpie_debug.tgz",
                       "rev4.51+mrmagpie10_h12_validation_debug.tgz",
                       "additional_data_rev3.85.tgz",
                       "calibration_H12_mixed_feb17_c200_LUH2v2_managementcalib_aug19__08Jan21.tgz")

        #recalibrate
        cfg$recalibrate <- FALSE


        #recalc_npi_ndc
        #cfg$recalc_npi_ndc <- TRUE

        #forestry
        cfg$gms$forestry  <- "static_sep16"


        #Factor costs realization
        cfg$gms$factor_costs <- realization[j]

        #Climate impact or not

        start_run(cfg=cfg)
        }
      }
