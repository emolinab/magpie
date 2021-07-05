library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
source("scripts/start_functions.R")
source("config/default.cfg")
source("scripts/start/extra/lpjml_addon.R")
# Scenarios
realization<-"sticky_feb18"
type<-c("free","dynamic")
climate<-c("cc","nocc_hist")

#start MAgPIE run
cfg$input <- c(cellular = "rev4.62+EMB_h12_57bd794f_cellularmagpie_debug_c200_UKESM1-0-LL-ssp370_lpjml-ab83aee4.tgz",
               regional = "rev4.62+EMB_h12_magpie_debug.tgz",
               validation = "rev4.61_h12_validation.tgz",
               additional = cfg$input[grep("additional_data", cfg$input)],
               patch = "patch_land_iso.tgz",
               calibration = "calibration_calib_H12_sticky_ukes7p0_05Jul21.tgz")


  for(t in type){
    for (c in climate){

    cfg <- setScenario(cfg,c)

    cfg$gms$factor_costs<- "sticky_feb18"
    cfg$gms$c38_sticky_mode <- t

    cfg$title <- paste0("Split2020_ukes7p0_",c,"_",t)
    cfg$output <- c("rds_report","extra/disaggregation")




    start_run(cfg,codeCheck=FALSE)
    }}
