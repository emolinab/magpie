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
climate<-c("cc","nocc")


for (k in 1:length(climate)){
    for(j in 1:length(realization)){

        #Change the results folder name
        #NBC STANDS FOR NEW BEST CALIBRATION
        cfg$title<-paste0("OldLPJ",realization[j],"_rcp6p0_",climate[k],"_")

        cfg <- setScenario(cfg,climate[k])

        cfg$input <- c("isimip_rcp-IPSL_CM5A_LR-rcp6p0-co2_rev50_c200_690d3718e151be1b450b394c1064b1c5.tgz",
                 "rev4.52_h12_magpie.tgz",
                 "rev4.52_h12_validation.tgz",
                 "calibration_Current_develop_H12_mixed_feb17_c200_08Jan21.tgz",
                 "additional_data_rev3.89.tgz")

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
