# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------------
# description: Disaggregation and sort of results
# comparison script: FALSE
# ---------------------------------------------------------------

library(magpie4)
library(lucode2)
library(magpiesets)
library(luscale)
library(ncdf4)
library(raster)

results<-as.data.frame(read.csv("scripts/start/ISIMIP/runs_names_files.csv"))
results_folder<-"/p/projects/landuse/users/mbacca/magpie_versions/ISIMIP/ISIMIP_RC/magpie/output/c1000_041121_ndc"
save_path<-"/p/projects/magpie/data/ISIMIP_06112021/"

ssps<-as.character(unique(results[,"rcp"]))
gcms<-as.character(unique(results[,"gcm"]))
#gcms<-gcms[gcms=="2015soc"]
resolution<-"c1000"

##### Mapping
C4_annual <- c("maiz","trce")
C4_perennial <- c("sugr_cane","begr")
C3_annual <- c("tece","rice_pro","rapeseed","sunflower","potato","cassav_sp","sugr_beet","others","cottn_pro","foddr")
C3_perennial <- c("oilpalm","betr")
C3_Nfixing <- c("soybean","groundnut","puls_pro")

for (s in ssps){
  for(g in gcms){

  dir<-if(g!="2015soc") paste0(results_folder,"/ISIMIP_041121_ndc_",s,"_",g,"_cc_",resolution) else paste0(results_folder,"/ISIMIP_041121_ndc_",s,"_GFDL-ESM4_nocc_hist_",resolution)
  gdx<-paste0(dir,"/fulldata.gdx")
  path<-paste(save_path,g,s,sep="/")

# #### Cropland (Should I include foddr, begr,betr?)
cropland<-croparea(gdx,level="grid",products="kcr",product_aggr=FALSE,water_aggr=FALSE,dir=dir)
cropl_total<-write.magpie(setNames(dimSums(cropland,dim=3),"cropland_total"),file_name=paste0(path,"/cropland_total.nc"),file_type="nc")
cropl_rain<-write.magpie(setNames(dimSums(cropland[,,"rainfed"],dim=3),"cropland_rainfed"),file_name=paste0(path,"/cropland_rainfed.nc"),file_type="nc")
cropl_irrig<-write.magpie(setNames(dimSums(cropland[,,"irrigated"],dim=3),"cropland_irrigated"),file_name=paste0(path,"/cropland_irrigated.nc"),file_type="nc")

#### C4ann
C4_annual_total<-write.magpie(setNames(dimSums(cropland[,,C4_annual],dim=3),"C4_annual_total"),file_name=paste0(path,"/c4ann_total.nc"),file_type="nc")
C4_annual_rain<-write.magpie(setNames(dimSums(cropland[,,C4_annual][,,"rainfed"],dim=3),"C4_annual_rainfed"),file_name=paste0(path,"/c4ann_rainfed.nc"),file_type="nc")
C4_annual_irrig<-write.magpie(setNames(dimSums(cropland[,,C4_annual][,,"irrigated"],dim=3),"C4_annual_irrigated"),file_name=paste0(path,"/c4ann_irrigated.nc"),file_type="nc")

#### C4per
C4_perennial_total<-write.magpie(setNames(dimSums(cropland[,,C4_perennial],dim=3),"C4_perennial"),file_name=paste0(path,"/c4per_total.nc"),file_type="nc")
C4_perennial_rain<-write.magpie(setNames(dimSums(cropland[,,C4_perennial][,,"rainfed"],dim=3),"C4_perennial_rainfed"),file_name=paste0(path,"/c4per_rainfed.nc"),file_type="nc")
C4_perennial_irrig<-write.magpie(setNames(dimSums(cropland[,,C4_perennial][,,"irrigated"],dim=3),"C4_perennial_irrigated"),file_name=paste0(path,"/c4per_irrigated.nc"),file_type="nc")

#### C4ann
C3_annual_total<-write.magpie(setNames(dimSums(cropland[,,C3_annual],dim=3),"C3_annual_total"),file_name=paste0(path,"/c3ann_total.nc"),file_type="nc")
C3_annual_rain<-write.magpie(setNames(dimSums(cropland[,,C3_annual][,,"rainfed"],dim=3),"C3_annual_rainfed"),file_name=paste0(path,"/c3ann_rainfed.nc"),file_type="nc")
C3_annual_irrig<-write.magpie(setNames(dimSums(cropland[,,C3_annual][,,"irrigated"],dim=3),"C3_annual_irrigated"),file_name=paste0(path,"/c3ann_irrigated.nc"),file_type="nc")

#### C3per
C3_perennial_total<-write.magpie(setNames(dimSums(cropland[,,C3_perennial],dim=3),"C3_perennial_total"),file_name=paste0(path,"/c3per_total.nc"),file_type="nc")
C3_perennial_rain<-write.magpie(setNames(dimSums(cropland[,,C3_perennial][,,"rainfed"],dim=3),"C3_perennial_rainfed"),file_name=paste0(path,"/c3per_rainfed.nc"),file_type="nc")
C3_perennial_irrig<-write.magpie(setNames(dimSums(cropland[,,C3_perennial][,,"irrigated"],dim=3),"C3_perennial_irrigated"),file_name=paste0(path,"/c3per_irrigated.nc"),file_type="nc")

#### C3nfx
C3_Nfixing_total<-write.magpie(setNames(dimSums(cropland[,,C3_Nfixing],dim=3),"C3_Nfixing_total"),file_name=paste0(path,"/c3nfx_total.nc"),file_type="nc")
C3_Nfixing_rain<-write.magpie(setNames(dimSums(cropland[,,C3_Nfixing][,,"rainfed"],dim=3),"C3_Nfixing_rainfed"),file_name=paste0(path,"/c3nfx_rainfed.nc"),file_type="nc")
C3_Nfixing_irrig<-write.magpie(setNames(dimSums(cropland[,,C3_Nfixing][,,"irrigated"],dim=3),"C3_Nfixing_irrigated"),file_name=paste0(path,"/c3nfx_irrigated.nc"),file_type="nc")

#### rangelands and pastures
pastures<-write.magpie(setNames(land(gdx,level="grid",type="past",dir=dir),"pasture_rangelands"),file_name=paste0(path,"/PastureRangelands.nc"),file_type="nc")

#### urban areas
urban<-write.magpie(setNames(land(gdx,level="grid",type="urban",dir=dir),"Urban"),file_name=paste0(path,"/Urban.nc"),file_type="nc")

#### bioenergy
bioenergy_tree<-write.magpie(setNames(dimSums(cropland[,,"betr"],dim=3),"bioenergy_trees"),file_name=paste0(path,"/bioenergy_trees.nc"),file_type="nc")
bioenergy_grass<-write.magpie(setNames(dimSums(cropland[,,"begr"],dim=3),"bioenergy_grass"),file_name=paste0(path,"/bioenergy_grass.nc"),file_type="nc")

#### fertilizer

# fer_in_reg<-setNames(readGDX(gdx,"ov50_nr_inputs")[,,"level"],"total")
# weight_fertilizer_kcr<-NitrogenBudgetWithdrawals(gdx,kcr="kcr",net=TRUE,level="grid",dir=dir)
# weight_fertilizer_sum<-dimSums(weight_fertilizer_kcr,dim=3)
# mapping<-as.data.frame(getNames(weight_fertilizer_kcr,dim=1))
# colnames(mapping)<-"kcr"
# mapping$total<-"total"
#
# fer_in_grid<-gdxAggregate(gdx,fer_in_cell_kcr,weight=weight_fertilizer_sum,to="grid",absolute=TRUE,dir=dir)
# fer_in_grid_kcr<-toolAggregate(fer_in_grid,rel=mapping,from="total",to="kcr",weight=weight_fertilizer_kcr,dim=3)
#
# fer_in_grid_c3ann<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C3_annual],dim=3.1),"c3ann"),file_name=paste0(path,"/fertl_c3ann.nc"),file_type="nc")
# fer_in_grid_c3per<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C3_perennial],dim=3.1),"c3per"),file_name=paste0(path,"/fertl_c3per.nc"),file_type="nc")
# fer_in_grid_c3nfx<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C3_Nfixing],dim=3.1),"c3nfx"),file_name=paste0(path,"/fertl_c3nfx.nc"),file_type="nc")
# fer_in_grid_c4ann<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C4_annual],dim=3.1),"c4ann"),file_name=paste0(path,"/fertl_c4ann.nc"),file_type="nc")
# fer_in_grid_c4per<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C4_perennial],dim=3.1),"c4per"),file_name=paste0(path,"/fertl_c4per.nc"),file_type="nc")

#### FAST NOT SO DETAILED DISAGGREGATION
# fer_in_reg<-setNames(readGDX(gdx,"ov50_nr_inputs")[,,"level"],"total")
# weight_fertilizer_kcr<-NitrogenBudgetWithdrawals(gdx,kcr="kcr",net=TRUE,level="reg")
# mapping<-as.data.frame(getNames(weight_fertilizer_kcr,dim=1))
# colnames(mapping)<-"kcr"
# mapping$total<-"total"
#
# fer_in_kcr<-toolAggregate(fer_in_reg,rel=mapping,from="total",to="kcr",weight=weight_fertilizer_kcr,dim=3)
#
# cropland_weight<-dimSums(cropland,dim=3.2)
# mapping<-readRDS(paste0(dir,"/clustermap_rev4.64+ISIMIP_300921_noDeb_c500_h12.rds"))
# fer_in_grid_kcr<-toolAggregate(fer_in_kcr,rel=mapping,from="region",to="cell",weight=cropland_weight,dim=1)
#
#
# fer_in_grid_c3ann<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C3_annual],dim=3.1),"c3ann"),file_name=paste0(path,"/fertl_c3ann.nc"),file_type="nc")
# fer_in_grid_c3per<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C3_perennial],dim=3.1),"c3per"),file_name=paste0(path,"/fertl_c3per.nc"),file_type="nc")
# fer_in_grid_c3nfx<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C3_Nfixing],dim=3.1),"c3nfx"),file_name=paste0(path,"/fertl_c3nfx.nc"),file_type="nc")
# fer_in_grid_c4ann<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C4_annual],dim=3.1),"c4ann"),file_name=paste0(path,"/fertl_c4ann.nc"),file_type="nc")
# fer_in_grid_c4per<-write.magpie(setNames(dimSums(fer_in_grid_kcr[,,C4_perennial],dim=3.1),"c4per"),file_name=paste0(path,"/fertl_c4per.nc"),file_type="nc")


  }
}
