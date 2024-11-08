library(magpie4)
library(gdx2)


scenarios <- c("ssp245") #,"ssp370","ssp119"
fold <- "/p/projects/landuse/users/mbacca/Additional_input/"
fold_run <- "/p/projects/landuse/users/mbacca/Paper3/MagPIERuns/magpie/output/071124/AdaptCap-4115-"


for(s in scenarios){

tag <- paste0("AC-c200-dat-",s)
dir.create(file.path(fold, tag), showWarnings = FALSE)

gdx<-paste0(fold_run,s, "/fulldata.gdx")

    if(!file.exists(paste0(fold,tag,".tgz"))){

      ov_prod_reg <- readGDX(gdx,"ov_prod_reg",select=list(type="level"))
      ov_supply <- readGDX(gdx,"ov_supply",select=list(type="level"))
      f21_trade_balance <- ov_prod_reg - ov_supply
      write.magpie(round(f21_trade_balance,6),file_name=paste0(fold,tag,"/f21_trade_balance.cs3"))
      #tc
      ov_tau <- readGDX(gdx, "ov_tau",select=list(type="level"))
      write.magpie(round(ov_tau,6),paste0(fold,tag,"/f13_tau_scenario.csv"))
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
       write.magpie(aff_max,file_name=paste0(fold,tag,"/f32_max_aff_area.cs4"))

      gms::tardir(dir=paste0(fold,tag,"/"),
      tarfile=paste0(fold,tag,".tgz"))
}

}



                 