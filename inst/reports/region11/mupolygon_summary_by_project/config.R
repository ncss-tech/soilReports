# Custom code, don't modify!!!

ogr_extract <- function(pd, geodatabase, cache, project){
  ogr2ogr(
    src_datasource_name = paste0(pd, geodatabase),
    dst_datasource_name = cache,
    layer = "MUPOLYGON",
    where = paste0("MUKEY IN (", noquote(paste("'", project, "'", collapse=",", sep="")),")"),
    s_srs = CRS("+init=epsg:5070"),
    t_srs = CRS("+init=epsg:5070"),
    overwrite = T,
    simplify = 2,
    verbose = TRUE)
}


raster_extract <- function(x){
  # Load grids
  files <- c(
    slope     = paste0(office_folder, "ned10m_", ssoffice, "_slope5.tif"),
    aspect    = paste0(office_folder, "ned10m_", ssoffice, "_aspect5.tif"),
    elev      = paste0(office_folder, "ned30m_", ssoffice, ".tif"),
    wetness   = paste0(office_folder, "ned30m_", ssoffice, "_wetness.tif"),
    valley    = paste0(office_folder, "ned30m_", ssoffice, "_mvalleys.tif"),
    relief    = paste0(office_folder, "ned30m_", ssoffice, "_z2stream.tif"),
    lulc      = paste0(office_folder, "nlcd30m_", ssoffice, "_lulc2011.tif"),
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
