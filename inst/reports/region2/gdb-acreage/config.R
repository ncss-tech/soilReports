## config.R 

## base path to one or more geodatabases
poly.path <- "E:/CA649/Geodata/GDB"

## geodatabase file name
# gdb.name <- "FGDB_CA731_Join_Project_2021_0716.gdb"
# gdb.name <- "FGCA649_Projects_2021_07_16.gdb"
gdb.name <- "FGDB_CA750_Join_Project_2021_0716.gdb"

# include DMU description in DT interactive table? (always in CSV output)
include_dmudesc <- FALSE

# output txt file for legend acre updates with 'MUSYM' or 'MUKEY'?
musymacres_field <- 'MUSYM'

## geodatabase path
poly.dsn <- file.path(poly.path, gdb.name)

## search for two capital letters followed by 3 numbers and underscore (ssa symbol)
area.symbol <- gsub(".*([A-Z]{2}[0-9]{3})_.*", "\\1", poly.dsn)
poly.layer <- paste0(tolower(area.symbol), "_a")
poly.bounds <- paste0(tolower(area.symbol), "_b")

order.by.col <- "Change" # options: Change, MUSYM, Legend_Acres, Spatial_Acres, Status, MURecID, Match