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
prism.path <- 'mlra-prism-data.rda'
geomorphons.path <- 'mlra-geomorphons-data.rda'
nlcd.path <- 'mlra-nlcd-data.rda'
soil.path <- 'mlra-soil-data.rda'
namrad.path <- 'mlra-namrad-data.rda'

####################
### MLRA selection #
####################

# define a subset of MLRA
# mu.set <- c('17', '15', '18', '22A', '136', '144B', '58A', '93A', '42')
mu.set <- c('17', '15', '18', '22A')

###########################
### quantiles of interest #
###########################

# the most important quantiles (percentiles / 100) are: 0.1, 0.5 (median), and 0.9
# optionally reduce the number of quantiles for narrower tables
p.quantiles <- c(0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95)


