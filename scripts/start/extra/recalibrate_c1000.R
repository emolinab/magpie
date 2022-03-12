# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------
# description: calculate and store new yield calib factors for realizations of factor costs (land conversion cost calibration factors are only calculated if needed)
# --------------------------------------------------------

library(magpie4)
library(magclass)

# Load start_run(cfg) function which is needed to start MAgPIE runs
title<-"calib_c1000_H13_11032022_B"

##########PREPARES FILES#########################
#parallel
folder<-"/p/projects/landuse/users/mbacca/Additional_data_sets/"
dir.create(paste0(folder,title))
#get trade pattern from low resolution run with c200
gdx<-"/p/projects/magpie/data/ISIMIP/ISIMIP_100322/magpie/output/c200_110322/ISIMIP_110322_ssp126_MRI-ESM2-0_cc/fulldata.gdx"
ov_prod_reg <- readGDX(gdx,"ov_prod_reg",select=list(type="level"))
ov_supply <- readGDX(gdx,"ov_supply",select=list(type="level"))
f21_trade_balance <- ov_prod_reg - ov_supply
write.magpie(round(f21_trade_balance,6),file_name=paste0(folder,"/",title,"/f21_trade_balance.cs3"))
#tc
ov_tau <- readGDX(gdx, "ov_tau",select=list(type="level"))
write.magpie(round(ov_tau,6),paste0(folder,"/",title,"/f13_tau_scenario.csv"))
#afforestation
#get regional afforestation patterns from low resolution run with c200
 aff <- dimSums(landForestry(gdx)[,,c("aff","ndc")],dim=3)
 #Take away initial NDC area for consistency with global afforestation limit
 aff <- aff-setYears(aff[,1,],NULL)
 #calculate maximum regional afforestation over time
 aff_max <- setYears(aff[,1,],NULL)
 for (r in getRegions(aff)) {
   aff_max[r,,] <- max(aff[r,,])
 }
 aff_max[aff_max<0] <- 0
 write.magpie(aff_max,file_name=paste0(folder,"/",title,"/f32_max_aff_area.cs4"))

gms::tardir(dir=paste0(folder,"/",title),
tarfile=paste0(folder,"/",title,".tgz"))
######################################################################################################

source("scripts/start_functions.R")

#start MAgPIE run
source("config/default.cfg")



cfg$input <- c(cellular    = "rev4.65+ISIMIP_140122_8f7b9423_0f262b1a_cellularmagpie_c1000_MRI-ESM2-0-ssp126_lpjml-c5bacf3f.tgz",
               regional    = "rev4.65+ISIMIP_140122_8f7b9423_magpie.tgz",
               validation  = "rev4.65+ISIMIP_140122_8f7b9423_validation.tgz",
               additional  = "additional_data_rev4.07.tgz",
               calibration = "caib_H13_ISIMIP_11Mar22.tgz",
               patch = paste0(folder,"/",title,".tgz")
               )

cfg <- gms::setScenario(cfg,c("ForestryEndo"))
cfg$gms$s13_ignore_tau_historical <- 1 #ignoring historical tau == 1
cfg$gms$factor_costs<- "sticky_feb18"
cfg$gms$c38_sticky_mode <- "dynamic"
cfg$force_replace <- TRUE
cfg$recalc_npi_ndc <- TRUE

cfg$results_folder <- "output/:title:"
cfg$recalibrate <- FALSE
cfg$recalibrate_landconversion_cost <- TRUE
cfg$title <- title
cfg$output <- c("rds_report")

#### Fixed parameters
cfg$gms$trade <- "exo"
cfg$gms$tc <- "exo"
cfg$gms$c32_max_aff_area <- "regional"
#check
if(cfg$gms$s32_max_aff_area < Inf) {
  indicator <- abs(sum(aff_max)-cfg$gms$s32_max_aff_area)
  if(indicator > 1e-06) warning(paste("Global and regional afforestation limit differ by",indicator,"Mha"))
}

cfg$gms$optimization <- "nlp_par"
cfg$gms$c_timesteps <- 18
cfg$qos <- "medium"


magpie4::submitCalibration("c1000_H13_B")
start_run(cfg,codeCheck=FALSE)
