
##################################################
#### Author:   Sofia Lino & Afonso Barrocal   ####
#### Date: March 28th, 2025                   ####
##################################################

## Correlation between variables
# load packages
library(terra)
library(readr)

# import rasters
paths <- list.files(path = "./new/full/asci", pattern = "asc", full.names = T)
rasters <- rast(paths)

# import wolf presences
presences <- read_csv("presences.csv")

# Convert raster stack to a data frame of pixel values
raster_values <- as.data.frame(rasters, na.rm = TRUE) 

# Compute correlation matrix
cor_matrix <- cor(raster_values, method = "pearson")
View(cor_matrix)
write.csv(cor_matrix, "correlation.csv")


