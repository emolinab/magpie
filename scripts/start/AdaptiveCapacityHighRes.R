library(magpie4)
library(lucode2)
library(gdx2)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$force_download <- TRUE
cfg$results_folder <- "output/071124/:title:"
cfg$force_replace <- TRUE

scenarios <- c("ssp245") #,"ssp370","ssp119"

SSP <- c("SSP2") #,"SSP3","SSP1"

bioen_ghg <- list()
bioen_ghg[["ssp245"]] <- "R21M42-SSP2-NPI"
bioen_ghg[["ssp370"]] <- "R21M42-SSP2-NPI"
bioen_ghg[["ssp119"]] <- "R21M42-SSP1-PkBudg1300"


mit <- list()
mit[["ssp245"]] <- "npi"
mit[["ssp370"]] <- "npi"
mit[["ssp119"]] <- "ndc"


cfg$gms$sm_fix_cc <- 2020
cfg$gms$sm_fix_SSP2 <- 2020


cellular<-c(ssp245="rev4.115_38b49b50_1937e5d5_cellularmagpie_c1000_MRI-ESM2-0-ssp245_lpjml-8e6c5eb1.tgz",
            ssp370="rev4.115_38b49b50_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
            ssp119="rev4.115_38b49b50_0bd54110_cellularmagpie_c200_MRI-ESM2-0-ssp119_lpjml-8e6c5eb1.tgz")

regional <- "rev4.115_38b49b50_magpie.tgz"
validation <- "rev4.115_38b49b50_validation.tgz"
cc <-  "cc"

for (s in 1:length(scenarios)) { 
    

#########Calibration##########

if(scenarios[s]=="ssp245"){
cfg$recalibrate_landconversion_cost <- TRUE
calib <- "calibration_Bbc200_05Nov24.tgz"

}else{
cfg$recalibrate_landconversion_cost <- FALSE
calib <- "calibration_c200R4415_07Nov24.tgz"
}


                cfg <- gms::setScenario(cfg, c(cc, SSP[s]))
                cfg$input <- c( regional    = regional,
                                cellular    = cellular[scenarios[s]],
                                validation  = validation,
                                additional  = "additional_data_rev4.57.tgz",
                                calibration = calib,
                                additional2 = paste0("AC-c200-dat-",scenarios[s],".tgz")
                                )

                cfg$gms$c_timesteps <- "5year" #"calib" # 
                cfg$gms$factor_costs <-"sticky_feb18"
                cfg$gms$som <- "cellpool_jan23"
                cfg$gms$tc <- "exo"

                cfg$title <- paste0("AdaptCap-4115-c1000-",scenarios[s])


                cfg$gms$c56_pollutant_prices <- bioen_ghg[[scenarios[s]]]
                cfg$gms$c56_pollutant_prices_noselect <- bioen_ghg[[scenarios[s]]]
                cfg$gms$c60_2ndgen_biodem <- bioen_ghg[[scenarios[s]]]
                cfg$gms$c60_2ndgen_biodem_noselect <- bioen_ghg[[scenarios[s]]]

                cfg$gms$c32_aff_policy <- mit[[scenarios[s]]]
                cfg$gms$c35_aolc_policy <- mit[[scenarios[s]]]
                cfg$gms$c35_ad_policy <- mit[[scenarios[s]]]

                #### Fixed parameters parallel
                cfg$gms$trade <- "exo"
                cfg$gms$tc <- "exo"
                cfg$gms$c32_max_aff_area <- "regional"
                #check
                if(cfg$gms$s32_max_aff_area < Inf) {
                 indicator <- abs(sum(aff_max)-cfg$gms$s32_max_aff_area)
                 if(indicator > 1e-06) warning(paste("Global and regional afforestation limit differ by",indicator,"Mha"))
                }

                cfg$recalc_npi_ndc <- TRUE
                cfg$gms$optimization <- "nlp_par"
                cfg$qos <- "priority_maxMem"

                start_run(cfg, codeCheck = FALSE)
                

                if(scenarios[s]=="ssp245"){
                 magpie4::submitCalibration("c1000R4415")
                }
            }

