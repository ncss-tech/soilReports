### MLRA GIS Summary Report
### 2017-03-17
### D.E. Beaudette and J. Wood
###
### configuration file, edit as needed
###


#############################
### Raster Sample Databases #
#############################

# you will need all three of these
prism.path <- 'C:/Users/Dylan.Beaudette/Desktop/MLRA-samples/db/mlra-prism-data.rda'
geomorphons.path <- 'C:/Users/Dylan.Beaudette/Desktop/MLRA-samples/db/mlra-geomorphons-data.rda'
nlcd.path <- 'C:/Users/Dylan.Beaudette/Desktop/MLRA-samples/db/mlra-nlcd-data.rda'

####################
### MLRA selection #
####################

# define a subset of MLRA
mu.set <- c('17', '15', '18', '22A', '22B', '47')


###########################
### quantiles of interest #
###########################

# the most important quantiles (percentiles / 100) are: 0.1, 0.5 (median), and 0.9
# optionally reduce the number of quantiles for narrower tables
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)

