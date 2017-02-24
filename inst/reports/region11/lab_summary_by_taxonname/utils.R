get_new <- function(q = q) {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  
  
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection = "DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors = FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # done
  return(d)
}

pindex <- function(x, interval){
  if (class(x)[1] == "data.frame") {x1 <- ncol(x); x2 <- 1}
  if (class(x)[1] == "SoilProfileCollection") {x1 <- length(x); x2 <-0}
  if (class(x)[1] == "table") {x1 <- ncol(x); x2 <- 0}
  n <- x1 - x2
  times <- ceiling(n / interval)
  x <- rep(1:(times + x2), each = interval, length.out = n)
  }

na_replace <- function(x){
  if(class(x)[1] == "character" | class(x)[1] == "logical") 
    {x <- replace(x, is.na(x) | x == "NA", "missing")} 
  else (x <-  x)
  }

na_remove <- function(df, by = 2){
  df[, which(apply(df, by, function(x) !all(is.na(x))))]
  }

precision.f <- function(x){
  if (!all(is.na(x))) {
    y = {format(x, scientific = FALSE, trim = TRUE) ->.;
      unlist(as.data.frame(strsplit(., "\\."))[2, ]) ->.;
      as.character(.) ->.;
      max(nchar(.))}
    } else y = 0
  if (is.na(y)) y = 0 else y = y
  return(y)
  }


sum5n <- function(x, n = NULL) {
  variable <- unique(x$variable)
  precision <- precision.f(x$value)
  n <- length(na.omit(x$value))
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- paste0("(", paste0(round(ci, precision), collapse=", "), ")", "(", n, ")") # add 'range' column for pretty-printing
  return(ci["range"])
}

sum5n2 <- function(x) {
  variable <- unique(x$variable)
  v <- na.omit(x$value) # extract column, from long-formatted input data
  precision <- if(variable == 'Circularity') 1 else 0
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- with(ci, paste0("(", paste0(round(ci, precision), collapse=", "), ")")) # add 'range' column for pretty-printing
  return(ci["range"])
}

ogr_extract <- function(pd, geodatabase, cache, project){
  ogr2ogr(
    src_datasource_name = paste0(pd, geodatabase),
    dst_datasource_name = cache,
    layer = "Project_Record",
    where = paste0("PROJECT_NAME IN (", noquote(paste("'", project, "'", collapse=",", sep="")),")"),
    s_srs = CRS("+init=epsg:5070"),
    t_srs = CRS("+init=epsg:5070"),
    overwrite = T,
    simplify = 2,
    verbose = TRUE)
}
  

raster_extract <- function(x){
  # Load grids
  files <- c(
    slope     = paste0(office_folder, "ned10m_", office, "_slope5.tif"),
    aspect    = paste0(office_folder, "ned10m_", office, "_aspect5.tif"),
    elev      = paste0(office_folder, "ned30m_", office, ".tif"),
    wetness   = paste0(office_folder, "ned30m_", office, "_wetness.tif"),
    valley    = paste0(office_folder, "ned30m_", office, "_mvalleys.tif"),
    relief    = paste0(office_folder, "ned30m_", office, "_z2stream.tif"),
    lulc      = paste0(office_folder, "nlcd30m_", office, "_lulc2011.tif"),
    ppt       = paste0(region_folder, "prism800m_11R_ppt_1981_2010_annual_mm.tif"),
    temp      = paste0(region_folder, "prism800m_11R_tmean_1981_2010_annual_C.tif"),
    ffp       = paste0(region_folder, "rmrs1000m_11R_ffp_1961_1990_annual_days.tif")
    )
  
  # test for missing files
  test <- sapply(files, function(x) file.exists(x))
  if (!any(test)) message("file not found ", files[!test])
  
  # import rasters
  geodata_r <- lapply(files, function(x) raster(x))
  
  # stack rasters with matching extent, resolution and projection
  stack_info <- {lapply(geodata_r, function(x) data.frame(
    bb = paste(bbox(extent(x)), collapse = ", "),
    res= paste(res(x), collapse = ", "),
    proj = proj4string(x)
    )) ->.; do.call("rbind", .)
    }

  stack_info <- transform(stack_info,
                          group = paste(bb, res, proj)
                          )
  test2 <- unique(stack_info$group)
  
  geodata_l <- list()
  for (i in seq_along(test2)) {
    geodata_l[[i]] <- {geodata_r[stack_info$group %in% test2[i]] ->.;
                             stack(unlist(.))
                             }}
  # extract data
  geodata <- {lapply(geodata_l, function(y) extract(y, x)) ->.;
    as.data.frame(do.call("cbind", .))
    }
  
  # Prep data
  if ("slope" %in% names(geodata)) {
    slope <- c(0, 2, 6, 12, 18, 30, 50, 75, 350)
    geodata$slope_classes <- cut(geodata$slope, breaks = slope, right=FALSE)
    levels(geodata$slope_classes) <- c("0-2","2-6","6-12","12-18","18-30","30-50","50-75","75-350")
  }
  
  if ("aspect" %in% names(geodata)) {
    geodata$aspect <- circular(geodata$aspect, template="geographic", units="degrees", modulo="2pi")
    aspect <- c(0, 23, 68, 113, 158, 203, 248, 293, 338, 360) 
    geodata$aspect_classes <- cut(geodata$aspect, breaks = aspect, right=FALSE)
    levels(geodata$aspect_classes) <- c("N","NE","E","SE","S","SW","W","NW","N")
  }
  
  if ("valley" %in% names(geodata)) {
    valley <- c(0, 0.5, 30)
    geodata$valley_classes <- cut(geodata$valley, breaks = valley, right=FALSE)
    levels(geodata$valley_classes) <- c("upland","lowland")
  }
  
  if ("lulc" %in% names(geodata)) {
    geodata$lulc_classes <- factor(geodata$lulc, 
                                   levels = c(95, 90, 82, 81, 71, 52, 43, 42, 41, 31, 24, 23, 22, 
                                              21, 12, 11),
                                   labels = c("Emergent Herbaceuous Wetlands", "Woody Wetlands", 
                                              "Cultivated Crops", "Hay/Pasture", "Grassland/Herbaceous", 
                                              "Shrub/Scrub", "Mixed Forest", "Evergreen Forest", 
                                              "Deciduous Forest", "Barren Land", 
                                              "Developed, High Intensity", "Developed, Medium Intensity", 
                                              "Developed, Low Intensity", "Developed, Open Space", 
                                              "Perennial Snow/Ice", "Open Water")
                                   )
  }
  
  return(geodata = geodata)
}


.metadata_replace <- function(df){
  get_metadata <- function() {
    # must have RODBC installed
    if(!requireNamespace('RODBC'))
      stop('please install the `RODBC` package', call.=FALSE)
    
    q <- "SELECT mdd.DomainID, DomainName, ChoiceValue, ChoiceLabel, ChoiceDescription, ColumnPhysicalName, ColumnLogicalName
    
    FROM MetadataDomainDetail mdd
    INNER JOIN MetadataDomainMaster mdm ON mdm.DomainID = mdd.DomainID
    INNER JOIN (SELECT MIN(DomainID) DomainID, MIN(ColumnPhysicalName) ColumnPhysicalName, MIN(ColumnLogicalName) ColumnLogicalName FROM MetadataTableColumn GROUP BY DomainID) mtc ON mtc.DomainID = mdd.DomainID
    
    ORDER BY DomainID, ChoiceValue"
    
    # setup connection local NASIS
    channel <- RODBC::odbcDriverConnect(connection = "DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
    
    # exec query
    d <- RODBC::sqlQuery(channel, q, stringsAsFactors = FALSE)
    
    # close connection
    RODBC::odbcClose(channel)
    
    # done
    return(d)
  }
  
  # load current metadata table
  metadata <- get_metadata()
  # unique set of possible columns that will need replacement
  possibleReplacements <- unique(metadata$ColumnPhysicalName)
  # names of raw data
  nm <- names(df)
  # index to columns with codes to be replaced
  columnsToWorkOn.idx <- which(nm %in% possibleReplacements)
  
  # iterate over columns with codes
  for (i in columnsToWorkOn.idx){
    # get the current metadata
    sub <- metadata[metadata$ColumnPhysicalName %in% nm[i], ]
    # replace codes with values
    df[, i] <- factor(df[, i], levels = sub$ChoiceValue, labels = sub$ChoiceLabel)
  }
  
  return(df)
}


