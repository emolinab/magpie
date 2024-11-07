library(magpie4)
library(lucode2)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")

cfg$force_download <- TRUE
cfg$results_folder <- "output/071124/:title:"
cfg$force_replace <- TRUE

scenarios <- c("ssp245","ssp370","ssp119")

SSP <- c("SSP2","SSP3","SSP1")

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


cellular<-c(ssp245="rev4.115_38b49b50_1b5c3817_cellularmagpie_c200_MRI-ESM2-0-ssp245_lpjml-8e6c5eb1.tgz",
            ssp370="rev4.115_38b49b50_fd712c0b_cellularmagpie_c200_MRI-ESM2-0-ssp370_lpjml-8e6c5eb1.tgz",
            ssp119="rev4.115_38b49b50_0bd54110_cellularmagpie_c200_MRI-ESM2-0-ssp119_lpjml-8e6c5eb1.tgz")

regional <- "rev4.115_38b49b50_magpie.tgz"
validation <- "rev4.114+BB-Risk_38b49b50_validation"
cc <-  "cc"

for (s in 1:length(scenarios)) { 
    

#########Calibration##########

if(scenarios[s]=="ssp245"){
cfg$recalibrate_landconversion_cost <- TRUE
calib <- "calibration_Bbc200_05Nov24.tgz"
additional2 <- ""
cfg$gms$tc <- "endo_jan22"

}else{
cfg$recalibrate_landconversion_cost <- FALSE
calib <- "calibration_c200R4415_07ÖNov24.tgz"
additional2 <- paste0(fold,"/",tag,".tgz")
cfg$gms$tc <- "endo_jan22"
}

                cfg <- gms::setScenario(cfg, c(cc, SSP[s]))
                cfg$input <- c( regional    = regional,
                                cellular    = cellular[scenarios[s]],
                                validation  = validation,
                                additional  = "additional_data_rev4.xx.tgz",
                                calibration = calib,
                                additional2 = additional2
                                )

                cfg$gms$c_timesteps <- "5year" #"calib" # 
                cfg$gms$factor_costs <-"sticky_feb18"
                cfg$gms$som <- "cellpool_jan23"

                cfg$title <- paste0("AdaptCap-4115-",scenarios[s])


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
                magpie4::submitCalibration("c200R4415")

                if(scenarios[s]=="ssp245"){

                 fold <- "/p/projects/landuse/users/mbacca/Additional_input/"
                 tag <- "AC-c200R4415-245"
                 dir.create(file.path(fold, tag), showWarnings = FALSE)

                 gdx<-paste0("/p/projects/landuse/users/mbacca/Paper3/MagPIERuns/magpie/output/output/071124/AdaptCap-4115-",scenarios[s],
              "/fulldata.gdx")
                ov_tau <- readGDX(gdx, "ov_tau",select=list(type="level"))
                write.magpie(round(ov_tau,6),paste0(fold,tag,"/","/f13_tau_scenario.csv"))
                gms::tardir(dir=paste0(fold,tag,"/"),
                tarfile=paste0(fold,"/",tag,".tgz"))

                }
            }

