
##############################################
#### Author: Sofia Lino & Hugo Rebelo     ####
#### Date: March 28th, 2025               ####
##############################################

install.packages ("ecodist")
library(ecodist)

# import cluster matrix
Clusters <- read.csv("./Clusters.csv", header = TRUE, stringsAsFactors = FALSE)

# Create cluster matrix
row.names(cluster_matrix) <- as.matrix(Clusters[,1])

## correlations between variables
# with genetic dist
cor.test(genetic_dist[upper.tri(genetic_dist)], cluster_matrix[upper.tri(cluster_matrix)],
         method = "pearson") # corr between genetic distance and clusters
cor.test(genetic_dist, dist_Euclid_std, method = "pearson") 
cor.test(genetic_dist, lcp_std, method = "pearson") 
cor.test(genetic_dist, lcp_exp_std, method = "pearson") 
cor.test(genetic_dist, lcp_disturb_std, method = "pearson") 
cor.test(genetic_dist, lcp_resou_std, method = "pearson") 

# with each other
cor.test(dist_Euclid_std, lcp_std, method = "pearson") 
cor.test(dist_Euclid_std, lcp_exp_std, method = "pearson") 
cor.test(dist_Euclid_std, lcp_resou_std, method = "pearson")
cor.test(dist_Euclid_std, lcp_disturb_std, method = "pearson") 
cor.test(lcp_std, lcp_exp_std, method = "pearson") 
cor.test(lcp_std, lcp_resou_std, method = "pearson") 
cor.test(lcp_std, lcp_disturb_std, method = "pearson")
cor.test(lcp_exp_std, lcp_resou_std, method = "pearson")
cor.test(lcp_exp_std, lcp_disturb_std, method = "pearson") 
cor.test(lcp_disturb_std, lcp_resou_std, method = "pearson") 

## MRDM with univariate models

mod1 <- MRM(genetic_dist[upper.tri(genetic_dist)] ~ dist_Euclid_std[upper.tri(dist_Euclid_std)],
            nperm = 10000, mrank = FALSE)
mod1

mod2 <- MRM(genetic_dist[upper.tri(genetic_dist)] ~ lcp_std[upper.tri(lcp_std)],
            nperm = 10000, mrank = FALSE)
mod2

mod3 <- MRM(genetic_dist[upper.tri(genetic_dist)] ~ lcp_exp_std[upper.tri(lcp_exp_std)],
            nperm = 10000, mrank = FALSE)
mod3

mod4 <- MRM(genetic_dist[upper.tri(genetic_dist)] ~ lcp_resou_std[upper.tri(lcp_resou_std)],
            nperm = 10000, mrank = FALSE)
mod4
mod5 <- MRM(genetic_dist[upper.tri(genetic_dist)] ~ lcp_disturb_std[upper.tri(lcp_disturb_std)],
            nperm = 10000, mrank = FALSE)
mod5

## residuals regression w/ clusters

cor_clusters <- lm(genetic_dist[upper.tri(genetic_dist)] ~ cluster_matrix[upper.tri(cluster_matrix)])
summary(cor_clusters)
res_clusters <- residuals(cor_clusters)

## MRDM against residuals of regression between genetic and clusters

mod10 <- MRM(res_clusters ~ dist_Euclid_std[upper.tri(dist_Euclid_std)], nperm = 10000, mrank = FALSE)
mod10

mod20 <- MRM(res_clusters ~ lcp_std[upper.tri(lcp_std)], nperm = 10000, mrank = FALSE)
mod20

mod30 <- MRM(res_clusters ~ lcp_exp_std[upper.tri(lcp_exp_std)], nperm = 10000, mrank = FALSE)
mod30

mod40 <- MRM(res_clusters ~ lcp_resou_std[upper.tri(lcp_resou_std)], nperm = 10000, mrank=FALSE)
mod40

mod50 <- MRM(res_clusters ~ lcp_disturb_std[upper.tri(lcp_disturb_std)], nperm = 10000, mrank=FALSE)
mod50
