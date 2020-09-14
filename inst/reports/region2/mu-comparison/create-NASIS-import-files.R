# NASIS Abiotic Factor Import File Generator
#
# Create elevation, frost-free days, air temperature and annual precipitation
#  pipe-delimited .txt files for import via NASIS Calculations:
#
#   - Component >> Import Elevation
#   - Component >> Import Frost Free Days
#   - Component >> Import MAAT
#   - Component >> Import MAP
#
# Author: Andrew G. Brown
# Date: 2020/09/10
# 
# Description:
#  This script relies on selected set containing legend mapunit, mapunit, datamapunit 
#  for target levels of `mu.col` (typically "musym", "nationalmusym","dmuiid") from 
#  region2/mu-comparison report. Populate your NASIS selected set with the mapunits  
#  summarized by the report output.
#

### LIBRARIES
library(aqp)
library(soilDB)

### SETUP

# column name identifier containing mapunit-level ID in report 
#  * a unique mapunit-level column name from soilDB::get_mapunit_from_NASIS())
mu.col <- "musym"

# NASIS import calculation pipe-delimited text files are stored in C:/temp
outputdir <- "C:/temp"

# column name suffixes (quantiles) corresponding to Low-RV-High, respectively
q.lorvhi <- c("Q5", "Q50", "Q95")

# output file from mapunit-comparison report providing mapunit symbol level summary stats
q.file <- "output/mucol-stats.csv"

# column names (using e.g. simplified DBF-safe names)
q.vars <- list("elevation.txt" = "Elevationm",
               "frostfreedays.txt" = "FrostFrDys",
               "maat.txt" = "MnAnnlArTC",
               "map.txt" = "MnAnnlPrcp")

# round off to nearest X? 
q.round <- list("elevation.txt" = 5,
                "frostfreedays.txt" = 5,
                "maat.txt" = 1,
                "map.txt" = 5)

###### 

### GET NASIS DATA
f <- fetchNASIS('components')
f.mapunit <- get_mapunit_from_NASIS()

### SANITY CHECKS

# setup options
stopifnot(length(q.lorvhi) == 3)
stopifnot(file.exists(q.file))
if (!dir.exists(outputdir))
  dir.create(outputdir, recursive = TRUE)

# NASIS selected set
stopifnot(length(f) > 0)
stopifnot(nrow(f.mapunit) > 0)

### CREATE LOOKUP TABLE
site(f) <- f.mapunit
mu.lut <- f$dmuiid
names(mu.lut) <- f[[mu.col]]

### GET REPORT OUTPUT 
q.data <- read.csv(q.file)

### PROCESS EACH VARIABLE (1 input file/calculation each)
res <- lapply(q.vars, function(vari) {
  q.data.names <- paste0(vari, "_", q.lorvhi)
  
  # make sure the q.lorvhi and q.vars are set correctly
  stopifnot(all(q.data.names %in% colnames(q.data)))
  
  # subset columns
  q.data.sub <- q.data[,q.data.names]
  
  # NASIS files take DMUIID as input 
  # TODO: talk to Kyle about updates for coiid-specific imports?
  q.data.sub[["dmuiid"]] <- mu.lut[as.character(q.data[[mu.col]])]
  q.data.sub[complete.cases(q.data.sub),c(4,1:3)]
})

# append trailing slash if needed
nod <- nchar(outputdir)
outputdir <- paste0(outputdir, ifelse(substr(outputdir, nod, nod) == "/", "", "/"))

# round values to target precision and write pipe-delimited tables
lapply(1:length(res), function(i) {
  res[[i]][,2:4] <- round(res[[i]][,2:4] / q.round[i]) * q.round[i]
  write.table(res[[i]], file = paste0(outputdir, names(res)[i]), 
              row.names = FALSE, col.names = FALSE, sep = "|")
  res[[i]]
})
