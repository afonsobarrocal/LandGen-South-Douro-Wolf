
#################################
#### Author: Afonso Barrocal ####
#### Date: March 28th, 2025  ####
#################################

### Processing variable layers ###

# load package
library("terra")

# create path vector
paths <- list.files(path = "./data/tif", pattern = "tif", full.names = T)[-c(1,3:13,15:24,26,27)]

# import rasters
exp_vars <- do.call(c,list(rast(paths)))

# import livestock resampled
livest <- rast("./data/tif/Livestock_resampled.tif")

# import attitudes resampled
attitudes <- rast("./data/tif/Attindex_resampled.tif")
attitudes <- resample(attitudes, exp_vars, method = "near")

# import dist agric
dist_agric <- rast("./data/tif/Dist_agric.tif")

# import dist bare rock
dist_bare <- rast("./data/tif/Dist_barerock.tif")

# import dist shrub
dist_shrub <- rast("./data/tif/Dist_shrub.tif")

# import dist pastures
dist_pasture <- rast("./data/tif/Dist_pastures.tif")

# import dist eucalypt
dist_eucalypt <- rast("./data/tif/Dist_eucalypt.tif")

# import dist broadleaf
dist_bleaf <- rast("./data/tif/Dist_broadleaf.tif")

# import dist conifer
dist_conifer <- rast("./data/tif/Dist_conifer.tif")

# import Human Population Density
hpd <- rast("./data/tif/Humandens_Eurostat_50m.tif")

# import Roe deer
roe <- rast("./data/tif/Roe deer_resampled.tif")

# import distance to fires
fire <- rast("./data/tif/Distance_fires.tif")

# import distance to urban
urban <- rast("./data/tif/Distance_urban.tif")

# import distance to natural water
natwater <- rast("./data/tif/Distance_naturalwater.tif")

# import distance to unpaved roads
unpaved <- rast("./data/tif/Distance_unpavedroads.tif")

# import distance to paved roads
paved <- rast("./data/tif/Distance_pavedroads.tif")

# processing 
ext(dist_agric) <- ext(exp_vars)
ext(dist_bare) <- ext(exp_vars)
ext(dist_shrub) <- ext(exp_vars)
ext(dist_pasture) <- ext(exp_vars)
ext(dist_eucalypt) <- ext(exp_vars)
ext(dist_bleaf) <- ext(exp_vars)
ext(dist_conifer) <- ext(exp_vars)
ext(fire) <- ext(exp_vars)
ext(urban) <- ext(exp_vars)
ext(natwater) <- ext(exp_vars)
ext(unpaved) <- ext(exp_vars)
ext(paved) <- ext(exp_vars)
ext(hpd) <- ext(exp_vars)
ext(roe) <- ext(exp_vars)
ext(livest) <- ext(exp_vars)

# merge variables
exp_vars <- c(exp_vars,roe,hpd,fire,urban,natwater,unpaved,paved,
              dist_agric,dist_bare,dist_shrub,dist_pasture,
              dist_bleaf,dist_conifer,dist_eucalypt,livest,attitudes)

crs(exp_vars) <- "ESPG:3857"
exp_vars <- subst(exp_vars,NaN,NA)

names(exp_vars)

# changing names
names(exp_vars) <- c("dem","dist_artwat","tri","roe",
                     "popd","dist_fire","dist_urb", "dist_natwat",
                     "dist_unpaved","dist_paved", "dist_agric","dist_bare",
                     "dist_shrub","dist_pasture","dist_bleaf","dist_conif",
                     "dist_eucalypt","livest","attitudes")

plot(exp_vars)

# remove unnecessary objects
rm(hpd,roe,fire,urban,natwater,unpaved,paved,paths,livest,attitudes,
   dist_agric,dist_bare,dist_bleaf,dist_conifer,dist_eucalypt,
   dist_pasture, dist_shrub)
invisible(gc())

# create FULL bias layer
bias <- (1-exp_vars[[9]]/max(values(exp_vars[[9]]), na.rm = T))
bias <- subst(bias,NA,-9999)

# exporting bias file
writeRaster(bias,paste0("./data/tif/new/full/bias_file_unpaved.asc"),
            NAflag=-9999, overwrite = T)

# remove unnecessary objects
rm(bias)
invisible(gc())

# exporting FULL varibles
for(i in seq_along(names(exp_vars))){
  # processing NA's into -9999
  dummy <- subst(exp_vars[[i]],NA,-9999)
  
  # exporting values
  writeRaster(exp_vars[[i]],paste0("./data/tif/new/full/",names(exp_vars[[i]]),".asc"),
              NAflag=-9999, overwrite = T)
  
  # remove unnecessary object
  rm(i,dummy)
  invisible(gc())
}
