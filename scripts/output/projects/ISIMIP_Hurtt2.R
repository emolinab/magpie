# |  (C) 2008-2021 Potsdam Institute for Climate Impact Research (PIK)
# |  authors, and contributors see CITATION.cff file. This file is part
# |  of MAgPIE and licensed under AGPL-3.0-or-later. Under Section 7 of
# |  AGPL-3.0, you are granted additional permissions described in the
# |  MAgPIE License Exception, version 1.0 (see LICENSE file).
# |  Contact: magpie@pik-potsdam.de

# --------------------------------------------------------------
# description: Interpolates MAgPIE results to 0.5 degree resolution in ISIMIP format 
# Secod part
# comparison script: FALSE
# ---------------------------------------------------------------

library(lucode2)
library(magpie4)
library(luscale)
library(madrat)
library(raster)
library(mrcommons)

if(!exists("source_include")) {
  outputdir <- "/p/projects/magpie/data/ISIMIP/ISIMIP_150322/magpie/output/c1000_150322_Calib/ISIMIP_150322_med_ssp585_IPSL-CM6A-LR_cc_c1000/"

  readArgs("outputdir")
}

map_file                   <- Sys.glob(file.path(outputdir, "clustermap_*.rds"))
gdx                        <- file.path(outputdir,"fulldata.gdx")
land_hr_file               <- file.path(outputdir,"avl_land_full_t_0.5.mz")
urban_land_hr_file         <- file.path(outputdir,"f34_urbanland_0.5.mz")
land_hr_out_file           <- file.path(outputdir,"cell.land_0.5.mz")
croparea_hr_share_out_file <- file.path(outputdir,"cell.croparea_0.5_share.mz")

load(paste0(outputdir, "/config.Rdata"))
if (!file.exists(file.path(outputdir,"cell.land_0.5.mz"))) stop('No disaggrated land use patterns found. Run "disaggregation.R" first!')

### Total land and cropland
dir<-outputdir

#### Saving results
save_path<-"/p/projects/magpie/transfers/ISIMIP/ISIMIP3b_MAgPIE_ISIMIP_140723/"
    if(!dir.exists(save_path)) dir.create(save_path)

scenarios<-c("ssp585noco2",  "ssp126", "ssp370", "ssp585") #

gcms<-c("GFDL-ESM4","MRI-ESM2-0","UKESM1-0-LL","MPI-ESM1-2-HR","IPSL-CM6A-LR","2015soc")

rcp<-NULL
gcm<-NULL
cc<-NULL

for (s in scenarios){
  rcp<- if(grepl(s, outputdir, fixed=TRUE)) s else rcp
}

for (g in gcms){
gcm<-if(grepl(g, outputdir, fixed=TRUE)) g else gcm
}

for (c in c("cc","nocc_hist")){
cc<-if(grepl(c, outputdir, fixed=TRUE)) c else cc
}

  if(cc=="cc"){
    if(!dir.exists(paste(save_path,gcm,sep="/"))) dir.create(paste(save_path,gcm,sep="/"))
      if(!dir.exists(paste(save_path,gcm,rcp,sep="/"))) dir.create(paste(save_path,gcm,rcp,sep="/"))
  }else{
    if(!dir.exists(paste(save_path,"2015soc",sep="/"))) dir.create(paste(save_path,"2015soc",sep="/"))
      if(!dir.exists(paste(save_path,"2015soc",rcp,sep="/"))) dir.create(paste(save_path,"2015soc",rcp,sep="/"))
  }

out_dir<-if (cc=="cc") paste(save_path,gcm,rcp,sep="/") else paste(save_path,"2015soc",rcp,sep="/")
### define functions

convertLUH2 <- function(x) {
  #interpolate years
  years <- getYears(x,as.integer = TRUE)
  x <- toolFillYears(x,seq(range(years)[1],range(years)[2],by=1))


  for(n in seq(1995,2085,15)){
      x_1<- if(n==1995) as.RasterBrick(x[,n:(n+15),]) else  as.RasterBrick(x[,(n+1):(n+15),])
      x_aux<- if(n==1995) x_1 else stack(x_aux,x_1)
  }
  #re-project raster from 0.5 to 0.25 degree
  x <- suppressWarnings(projectRaster(x_aux,raster(res=c(0.25,0.25)),method = "ngb"))
  return(x)

}

sizelimit <- getOption("magclass_sizeLimit")
options(magclass_sizeLimit = 1e+12)
on.exit(options(magclass_sizeLimit = sizelimit))

if(length(map_file)==0) stop("Could not find map file!")
if(length(map_file)>1) {
  warning("More than one map file found. First occurrence will be used!")
  map_file <- map_file[1]
}

### Crops mapping and
mapping_map<-readRDS(map_file)
gdx<-paste0(outputdir,"/fulldata.gdx")
mapping<-calcOutput(type = "LUH2MAgPIE", aggregate = FALSE, share = "LUHofMAG", bioenergy = "fix", missing = "fill",rice="total")[,2010,]
if(!dir.exists(paste0(save_path,"/mappingLUH2MAgPIE/"))) dir.create(paste0(save_path,"/mappingLUH2MAgPIE"))
if(!file.exists(paste0(save_path,"/mappingLUH2MAgPIE/LUH2MAgPIE.csv"))) write.csv(as.data.frame(mapping),file=paste0(save_path,"/mappingLUH2MAgPIE/LUH2MAgPIE.csv"))
countries<-intersect(getCells(mapping),unique(mapping_map$country))
mapping_map<-subset(mapping_map,country %in% countries)
mapping_grid<-setYears(speed_aggregate(mapping[countries,,],rel=mapping_map,weight=NULL,from="country",to="cell",dim=1),NULL)

land_hr <- read.magpie(land_hr_out_file)
land_hr <- land_hr[,-1,]

# calculates grid cell area of the earths sphere
cal_area <- function(ix,iy,res=0.5,mha=1) { # pixelarea in m2, mha as factor
  mha*(111.263*1000*res)*(111.263*1000*res)*cos(iy*pi/180.)
}

# grid cell area as magclass object
coord <- mrcommons:::magpie_coord
grarea <- new.magpie(cells_and_regions=mapping_map$cell,
                     fill=cal_area(coord[,"lon"],coord[,"lat"], mha=10^-10))
#grarea <- round(grarea,6)

# adjust total grid land area so that it is smaller than the gridcell area (some cells have a larger area acually; should be investigated)
frac <- grarea/dimSums(land_hr, dim=3)
frac[frac>1] <- 1
land_hr <- land_hr*frac

land_hr_shr <- land_hr/dimSums(land_hr, dim=3)
land_hr_shr[is.na(land_hr_shr)] <- 0

#### Tau Rates
tau_calc  <- gdxAggregate(gdx,collapseNames(readGDX(gdx,"ov_tau")[,,"level"]),weight=NULL,to="iso",absolute=FALSE,dir=outputdir)
years<-seq(1995,2100)
years<-years[!(years%in%getYears(tau_calc,as.integer=TRUE))]
tau_calc <- time_interpolate(tau_calc, interpolated_year = years, integrate_interpolated_years = TRUE, extrapolation_type = "linear")
tau_base  <- gdxAggregate(gdx,collapseNames(readGDX(gdx,"fm_tau1995")),weight=NULL,to="iso",absolute=FALSE,dir=outputdir)
tau_final <- (setNames(round(tau_calc/tau_base,3),"TC"))
write.magpie(tau_final,paste0(out_dir,"/TechnologicalChangeFactor.csv"), comment="Technological change factor")

#### Protein uptake per capita (iso-level)

protein <- Kcal(gdx, level="iso", attributes="protein", per_capita=TRUE, dir=outputdir)/1000*365
protein <- time_interpolate(protein,   interpolated_year = years,   integrate_interpolated_years = TRUE, extrapolation_type = "linear")
write.magpie(round(protein,1),paste0(out_dir,"/ProteinConsumption.csv"), comment="Protein Consumption per capita kg/cap/year")

#### Nitrogen budget 
###Crops
NB <- readRDS(paste0(outputdir,"/NitrogenBudget.rds"))
weight_kr <- readRDS(paste0(outputdir,"/NitrogenBudgetWeight.rds"))

weight_kr_luh<-weight_kr*mapping_grid
rm(weight_kr)
names<-unique(getNames(dimSums(mapping_grid,dim=3.2)))
weight<-new.magpie(cells_and_regions=getCells(weight_kr_luh),years=getYears(weight_kr_luh),names=names)

for(n in names){
weight[,,n]<-dimSums(weight_kr_luh[,,n],dim=3.1)
}

#### Fertilizer and manure use rates
FertNB<-NB[,,c("fertilizer","manure")]
FertNB[FertNB<0] <- 0
FertNB <- collapseNames(((FertNB * weight) / dimSums(weight,dim=3,na.rm = TRUE)))

crop_threshold <- 0.0001

states_hr<-readRDS(paste0(outputdir,"/states.rds"))[,,c(getNames(collapseNames(FertNB[,,"manure"])),"grazing")]*dimSums(land_hr,dim=3)
crop_hr <- states_hr[, , getNames(collapseNames(FertNB[, , "manure"]))]
past_hr<- states_hr[,,"grazing"]

FertNB[crop_hr<crop_threshold] <- NA
FertNBiso <- (dimSums(FertNB[, , c("fertilizer", "manure")], dim = 1.2, na.rm = TRUE) / dimSums(crop_hr, dim = 1.2, na.rm = TRUE)) * 1000

write.magpie(round(FertNBiso[,,"fertilizer"],1),paste0(out_dir,"/SyntheticFertilizerRate.csv"), comment="Synthetic fertilizer. unit: kgN/ha")
write.magpie(round(FertNBiso[,,"manure"],1),paste0(out_dir,"/ManureRate.csv"), comment="Manure. unit: kgN/ha")

#### deposition, uptake and harvest 

NB2 <- NB[, , c("deposition", "fixation_crops", "fixation_freeliving", "harvest", "fertilizer", "manure")]
NB2ha <- NB2 / dimSums(crop_hr, dim = 3, na.rm = TRUE) * 1000 # kgN-per-ha
NB2ha[!is.finite(NB2ha) || NB2ha<0] <- 0

NB2ha2_D <- convertLUH2(NB2ha[,,"deposition"])
write.magpie(NB2ha2_D,paste0(out_dir,"/Deposition_Nr_crops.nc"),comment = "unit: kgN-per-ha",datatype="FLT8S",zname="time",xname="lon",yname="lat")

NB2ha2_F <- convertLUH2(NB2ha[,,c("fixation_crops","fixation_freeliving")])
write.magpie(NB2ha2_F,paste0(out_dir,"/Fixation_Nr_crops.nc"),comment = "unit: kgN-per-ha",datatype="FLT8S",zname="time",xname="lon",yname="lat")

NB2ha2_U <- convertLUH2(NB2ha[,,c("harvest")])
write.magpie(NB2ha2_U,paste0(out_dir,"/Uptake_Nr_crops.nc"),comment = "unit: kgN-per-ha",datatype="FLT8S",zname="time",xname="lon",yname="lat")

NB2ha2_Fe <- convertLUH2(NB2ha[, , c("fertilizer")])
write.magpie(NB2ha2_Fe, paste0(out_dir, "/Fertilizer_Nr_crops.nc"), comment = "unit: kgN-per-ha", datatype = "FLT8S", zname = "time", xname = "lon", yname = "lat")

NB2ha2_Ma <- convertLUH2(NB2ha[, , c("manure")])
write.magpie(NB2ha2_Ma, paste0(out_dir, "/Manure_Nr_crops.nc"), comment = "unit: kgN-per-ha", datatype = "FLT8S", zname = "time", xname = "lon", yname = "lat")

###Pasture

if (file.exists(paste0(outputdir, "/NitrogenBudgetPasture.rds"))) {
  NBPast <- readRDS(paste0(outputdir, "/NitrogenBudgetPasture.rds"))  
} else {
  # read-in NR budget in mio t N
  NBPast <- NitrogenBudgetPasture(gdx, level = "grid", dir = outputdir)
  saveRDS(NBPast, paste0(outputdir, "/NitrogenBudgetPasture.rds"))
}

NBPast[NBPast < 0] <- 0
NBPast[past_hr < crop_threshold] <- NA

NBPast2 <- NBPast[, , c("deposition", "fixation_freeliving", "harvest", "grazing")]
NBPast2ha <- NBPast2 / dimSums(past_hr, dim = 3, na.rm = TRUE) * 1000 # kgN-per-ha
NBPast2ha[!is.finite(NBPast2ha)] <- 0

NBPast2ha_D <- convertLUH2(NBPast2ha[, , "deposition"])
write.magpie(NBPast2ha_D, paste0(out_dir, "/Deposition_Nr_Grass.nc"), comment = "unit: kgN-per-ha", datatype = "FLT8S", zname = "time", xname = "lon", yname = "lat")

NBPast2ha_F <- convertLUH2(NBPast2ha[, , c("fixation_freeliving")])
write.magpie(NBPast2ha_F, paste0(out_dir, "/Fixation_Nr_Grass.nc"), comment = "unit: kgN-per-ha", datatype = "FLT8S", zname = "time", xname = "lon", yname = "lat")

NBPast2ha_U <- convertLUH2(NBPast2ha[, , c("harvest", "grazing")])
write.magpie(NBPast2ha_U, paste0(out_dir, "/UpBiomass_Nr_Grass.nc"), comment = "unit: kgN-per-ha", datatype = "FLT8S", zname = "time", xname = "lon", yname = "lat")
