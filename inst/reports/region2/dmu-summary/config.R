### DMU Summary Report
### 2021-03-22
### D.E. Beaudette
###
### configuration file, edit as needed


##########################
### Local Climate Ranges #
##########################
.include.local.ranges <- TRUE

# add area-wide range
.local_range <- data.frame(
  .label = 'CA792',
  variable = factor(
    c('elev', 'ffd', 'maat', 'map', 'slope'),
    labels = c('Elevation (m)', 'Frost-Free Days', 'MAAT (deg C)', 'MAP (mm)', 'Slope (%)')
  ),
  rv = c(3005, 83, 3.28, 984, 43),
  low = c(1469, 40, -1.02, 583, 8),
  high = c(3728, 193, 12.01, 1381, 99)
  
)


