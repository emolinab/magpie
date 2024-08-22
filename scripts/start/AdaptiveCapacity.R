library(magpie4)
library(lucode2)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$force_download <- TRUE
cfg$results_folder <- "output/220824/:title:"
cfg$force_replace <- TRUE

scenarios <- c("ssp245")

SSP <- c("SSP2")

bioen_ghg <- list()
bioen_ghg[["ssp245"]] <- "R21M42-SSP2-NPI"


mit <- list()
mit[["ssp245"]] <- "npi"


cfg$gms$sm_fix_cc <- 2020
cfg$gms$sm_fix_SSP2 <- 2020


cellular<-c(ssp245="WARNINGS13_rev4.111BrBsk2024_38b49b50_1b5c3817_cellularmagpie_c200_MRI-ESM2-0-ssp245_lpjml-8e6c5eb1.tgz")

regional <- "WARNINGS93_rev4.111BrBsk2024_38b49b50_magpie.tgz"
validation <- "WARNINGS78_rev4.111BrBsk2024_38b49b50_validation.tgz"


for (s in 1:length(scenarios)) { #
    cc <-  "cc" # else c("cc", "nocc_hist") # :length(scenarios) if (s == 1)
    for (c in cc){ # "nocc_hist",
#
#########Calibration##########
## Yield calibration
cfg$recalibrate <- TRUE
# # # # Up to which accuracy shall be recalibrated?
cfg$calib_accuracy <- 0.05 # def = 0.05
# What is the maximum number of iterations if the precision goal is not reached?
cfg$calib_maxiter <- 20 # def = 20
cfg$damping_factor <- 0.96 # def= 0.96
cfg$gms$s14_use_yield_calib <- 1
# cfg$best_calib <- FALSE 

#cfg$best_calib <- TRUE # def = TRUE

# # Land conversion cost calibration
cfg$recalibrate_landconversion_cost <- TRUE
cfg$calib_accuracy_landconversion_cost <- 0.05 # def = 0.05
#What is the maximum number of iterations if the precision goal is not reached?
cfg$calib_maxiter_landconversion_cost <- 20 # def = 40
#cfg$best_calib_landconversion_cost <- FALSE # def = FALSE


#############################            

                cfg <- gms::setScenario(cfg, c(c, SSP[s]))
                cfg$gms$crop <- "rotation_apr22"
                cfg$input <- c( regional    = regional,
                                cellular    = cellular[scenarios[s]],
                                validation  = validation,
                                additional  = "additional_data_rev4.51.tgz"
                                )
                cfg$gms$c_timesteps <- "5year" #"calib" # 
                cfg$gms$factor_costs <-"sticky_feb18"
                cfg$gms$c38_fac_req <- "reg"

                cfg$title <- paste0("AdaptCapacity-",scenarios[s],"_",c)


                cfg$gms$c56_pollutant_prices <- bioen_ghg[[scenarios[s]]]
                cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[scenarios[s]]]
                cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[scenarios[s]]]
                cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[scenarios[s]]]

                cfg$gms$c32_aff_policy <- mit[[scenarios[s]]]
                cfg$gms$c35_aolc_policy <- mit[[scenarios[s]]]
                cfg$gms$c35_ad_policy <- mit[[scenarios[s]]]

                cfg$recalc_npi_ndc <- TRUE
                cfg$qos <- "priority"

                start_run(cfg, codeCheck = FALSE)
    magpie4::submitCalibration("BbAC2")
            }
        }