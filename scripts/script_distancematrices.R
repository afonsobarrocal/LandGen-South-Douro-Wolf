
##################################################
#### Author: Sofia Lino & Afonso Barrocal     ####
#### Date: March 28th, 2025                   ####
##################################################

###############################
## GENETIC DISTANCE ANALYSIS ##
###############################

# Load necessary packages
library("adegenet")
library("poppr")

# Read microsatellite data from .txt file
data <- read.table("./genetic_data.txt", header = T, stringsAsFactors = FALSE,sep = "/")

# Convert to df and remove the first column (individuals ID)
genetic_data <- as.data.frame(data[,-1])
row.names(genetic_data) <- data[,1]

# Convert to genind object
genind_obj <- df2genind(genetic_data, sep = "/", ploidy = 2)

# Calculate codominant genotypic distance
codom_dist <- diss.dist(genind_obj, percent = FALSE)

# Convert to matrix for easier viewing
codom_dist_matrix <- as.matrix(codom_dist)

## Ecological distances calculation (Euclidean and Least-cost paths)

# Load required libraries
library("sf")
library("raster")

# library("leastcostpath") # not working
library("gdistance")

# Import "genotypes" (shapefile w/ 3 columns: Individual ID, X, Y)
ind <- st_read("./genotypes.shp")

# Extract individual ID code
ind_ID <- ind$Ind

# Extract coords for each individual
coords <- st_coordinates(ind)
coords <- coords[, 1:2]

# Convert to data frame 
coords <- as.data.frame(coords)

# extract number of individuals
num_individuals <- nrow(coords)

#######################
## FULL model linear ##
#######################

## Load HSM raster
hsm <- raster("./Maxent/results/Full/unhinged/Canis_lupus_avg.asc")  

# create trans object for HSM
trans_layer <- transition(hsm, transitionFunction = mean, directions = 8)
trans_layer <- geoCorrection(trans_layer, type = "c") # type c to correct for distance distortion

# Distance matrix calculation
distance_matrix <- matrix(NA, nrow = num_individuals, ncol = num_individuals)

for (i in 1:(num_individuals - 1)) {
  for (j in (i + 1):num_individuals) {
    
    # Extract the coordinates for the pair of individuals (start and end points)
    start_point <- c(coords$X[i], coords$Y[i])  # Coordinates for individual i
    end_point <- c(coords$X[j], coords$Y[j])    # Coordinates for individual j
    
    # Calculate the least-cost distance between the two points
    least_cost_distance <- costDistance(trans_layer, start_point, end_point)
    
    # Store the result in the matrix (symmetrical)
    distance_matrix[i, j] <- least_cost_distance
    distance_matrix[j, i] <- least_cost_distance
  }
}

# populate row and column names with individual's ID
row.names(distance_matrix)<- ind_ID
colnames(distance_matrix)<- ind_ID

############################
## FULL model exponential ##
############################

# Run exponential transformation
# Define cell size
cs <- 50

# Apply exponential resistance transformation to full model (hsm)
resist_exp <- cs * (100 - (100^hsm))

# Check the resistance range
min_resist <- min(resist_exp[], na.rm = TRUE)
max_resist <- max(resist_exp[], na.rm = TRUE)
cat("Resistance Min:", min_resist, "Max:", max_resist, "\n")

# Standardise resistance
resist_exp_standard <- (resist_exp - min_resist) / (max_resist - min_resist)

# Check the range of the standardized resistance
min_resist_std <- cellStats(resist_exp_standard, stat = "min")
max_resist_std <- cellStats(resist_exp_standard, stat = "max")

# Print the results
cat("Standardized Resistance Min:", min_resist_std, "Max:", max_resist_std, "\n")

# Convert back to suitability
hsm_exp <- 1 - resist_exp_standard

# Create trans object
trans_layer_exp <- transition(hsm_exp, transitionFunction = mean, directions = 8)
trans_layer_exp <- geoCorrection(trans_layer_exp, type = "c") # type c to correct for distance distortion

# Distance matrix calculation
distance_matrix_exp <- matrix(NA, nrow = num_individuals, ncol = num_individuals)

for (i in 1:(num_individuals - 1)) {
  for (j in (i + 1):num_individuals) {
    
    # Extract the coordinates for the pair of individuals (start and end points)
    start_point <- c(coords$X[i], coords$Y[i])  # Coordinates for individual i
    end_point <- c(coords$X[j], coords$Y[j])    # Coordinates for individual j
    
    # Calculate the least-cost distance between each two points
    least_cost_distance_exp <- costDistance(trans_layer_exp, start_point, end_point)
    
    # Store the result in the matrix (symmetrical)
    distance_matrix_exp[i, j] <- least_cost_distance_exp
    distance_matrix_exp[j, i] <- least_cost_distance_exp
  }
}

# populate row and column names with individual's ID
row.names(distance_matrix_exp)<- ind_ID
colnames(distance_matrix_exp)<- ind_ID

####################################
##### Euclidean distance model #####
####################################

# Calculate Euclidean distance using dist()
dist_Euclidean <- as.matrix(dist(coords[, c("X", "Y")]))

# populate row and column names with individual's ID
row.names(dist_Euclidean)<- ind_ID
colnames(dist_Euclidean)<- ind_ID

########################################
## Resource availability model (resou)##
########################################

# Load Resou raster
hsm_resou <- raster("./Maxent/results/Resou/unhinged/Canis_lupus_avg.asc")
crs(hsm_landsc) <- "EPSG:3857"

# create trans object for resources hsm
resou_trans_layer <- transition(hsm_resou, transitionFunction = mean, directions = 8)
resou_trans_layer <- geoCorrection(resou_trans_layer, type = "c") # type c to correct for distance distortion

# Create matrix for least-cost path calculations
lcp_resou <- matrix(NA, nrow = num_individuals, ncol = num_individuals)

for (i in 1:(num_individuals - 1)) {
  for (j in (i + 1):num_individuals) {
    
    # Extract the coordinates for the pair of individuals (start and end points)
    start_point <- c(coords$X[i], coords$Y[i])  # Coordinates for individual i
    end_point <- c(coords$X[j], coords$Y[j])    # Coordinates for individual j
    
    # Calculate the least-cost distance between each two points
    least_cost_distance <- costDistance(resou_trans_layer, start_point, end_point)
    
    # Store the result in the matrix (symmetrical)
    lcp_resou[i, j] <- least_cost_distance
    lcp_resou[j, i] <- least_cost_distance
  }
}

# populate row and column names with individual's ID
row.names(lcp_resou)<- ind_ID
colnames(lcp_resou)<- ind_ID

###########################################
## Risks and disturbances model (Disturb)##
###########################################

# Load Disturb raster
hsm_disturb <- raster("./Maxent/results/Disturb/hinged/Canis_lupus_avg.asc")
crs(hsm_disturb) <- "EPSG:3857"

# create trans object for hsm
disturb_trans_layer <- transition(hsm_disturb, transitionFunction = mean, directions = 8)
disturb_trans_layer <- geoCorrection(disturb_trans_layer, type = "c") # type c to correct for distance distortion

# Create matrix for least-cost path calculations
lcp_disturb <- matrix(NA, nrow = num_individuals, ncol = num_individuals)

for (i in 1:(num_individuals - 1)) {
  for (j in (i + 1):num_individuals) {
    
    # Extract the coordinates for the pair of individuals (start and end points)
    start_point <- c(coords$X[i], coords$Y[i])  # Coordinates for individual i
    end_point <- c(coords$X[j], coords$Y[j])    # Coordinates for individual j
    
    # Calculate the least-cost distance between the two points
    least_cost_distance <- costDistance(disturb_trans_layer, start_point, end_point)
    
    # Store the result in the matrix (symmetrical)
    lcp_disturb[i, j] <- least_cost_distance
    lcp_disturb[j, i] <- least_cost_distance
  }
}

# populate row and column names with individual's ID
row.names(lcp_disturb)<- ind_ID
colnames(lcp_disturb)<- ind_ID

#######################################
## Individuals' order does not match ##
#######################################

### Align individuals to match across all matrices
genetic_ind <- rownames(codom_dist_matrix)
ind_ids <- ind$Ind
ordered_ind <- intersect(genetic_ind, ind_ids)

# Reorder and rename for easier reading
# genetic distances
genetic_dist <- codom_dist_matrix[ordered_ind,ordered_ind]

# euclidean distances
dist_Euclidean <- dist_Euclidean[ordered_ind,ordered_ind]

# linear lcp distances
distance_matrix <- distance_matrix[ordered_ind,ordered_ind]

# exponential lcp distances
distance_matrix_exp <- distance_matrix_exp[ordered_ind,ordered_ind]

# resou lcp distances
lcp_resou <- lcp_resou[ordered_ind, ordered_ind]

# disturb lcp distances
lcp_disturb <- lcp_disturb[ordered_ind, ordered_ind]

# Finally, standardize each matrix

## create function to standardize by range (sdr)
sdr <- function(x){
  # calculate minimum
  a <- min(x, na.rm = T)
  
  # calculate maximum
  b <- max(x, na.rm = T)
  
  # calculate range
  c <- b-a
  
  # standardize
  obj <- (x-a)/c
  
  # remove unnecessary objects
  rm(a,b,c)
  
  # return result
  return(obj)
}

# standardize by range
dist_Euclid_std <- sdr(dist_Euclidean)
lcp_std <- sdr(distance_matrix)
lcp_exp_std <- sdr(distance_matrix_exp)
lcp_resou_std <- sdr(lcp_resou)
lcp_disturb_std <- sdr(lcp_disturb)

# Save matrices to a CSV file
write.csv(codom_dist_matrix, "genetic_dist.csv")
write.csv(lcp_std, "distance_matrix.csv", row.names = TRUE)
write.csv(lcp_exp_std, "distance_matrix_exp.csv", row.names = TRUE)
write.csv(dist_Euclid_std, "dist_euclid.csv")
write.csv(lcp_resou_std, "lcp_resou.csv", row.names = TRUE)
write.csv(lcp_disturb_std, "lcp_disturb.csv", row.names = TRUE)
