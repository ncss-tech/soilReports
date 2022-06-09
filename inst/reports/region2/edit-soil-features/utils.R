.fix_dupe_hz <- function(p, 
                         method = "first", 
                         idvars = c(idname(p), horizonDepths(p))) {
  .I <- NULL
  h <- data.table::data.table(p@horizons)  
  idx <- switch(match.arg(tolower(method), choices = "first"),
               "first" = h[, .I[1], by = c(idvars)]$V1
               # ...
  )
  replaceHorizons(p) <- h[idx,]
  p
}

.add_extended_data <- function(f) {
  # surface fragments
  csfrags <- dbQueryNASIS(NASIS(), "SELECT * FROM cosurffrags") |> uncode()
  csfrags_l <- simplifyFragmentData(csfrags, "coiidref", "sfragcov_l", prefix = "sfrag", msg = "surface fragment cover")
  csfrags_r <- simplifyFragmentData(csfrags, "coiidref", "sfragcov_r", prefix = "sfrag", msg = "surface fragment cover")
  csfrags_h <- suppressWarnings(simplifyFragmentData(csfrags, "coiidref", "sfragcov_h", prefix = "sfrag", msg = "surface fragment cover")) # expected to be >100%
  colnames(csfrags_l)[2:ncol(csfrags_l)] <- paste0("surface", colnames(csfrags_l)[2:ncol(csfrags_l)], "_l")
  colnames(csfrags_r)[2:ncol(csfrags_r)] <- paste0("surface", colnames(csfrags_r)[2:ncol(csfrags_r)], "_r")
  colnames(csfrags_h)[2:ncol(csfrags_h)] <- paste0("surface", colnames(csfrags_h)[2:ncol(csfrags_h)], "_h")
  csfrags_summary <- merge(csfrags_r, csfrags_l, by = "coiidref", sort = FALSE, all.x = TRUE) |> 
    merge(csfrags_h, by = "coiidref", sort = FALSE, all.x = TRUE)
  csfrags_summary$coiid <- csfrags_summary$coiidref
  site(f) <- csfrags_summary
  
  # # subsurface fragments
  # chfrags <- dbQueryNASIS(NASIS(), "SELECT * FROM chfrags") |> uncode()
  # chfrags_l <- simplifyFragmentData(chfrags, "chiidref", "fragvol_l")
  # chfrags_r <- simplifyFragmentData(chfrags, "chiidref", "fragvol_r")
  # chfrags_h <- suppressWarnings(simplifyFragmentData(chfrags, "chiidref", "fragvol_h")) # expected to be >100%
  # colnames(chfrags_l)[2:ncol(chfrags_l)] <- paste0(colnames(chfrags_l)[2:ncol(chfrags_l)], "_l")
  # colnames(chfrags_r)[2:ncol(chfrags_r)] <- paste0(colnames(chfrags_r)[2:ncol(chfrags_r)], "_r")
  # colnames(chfrags_h)[2:ncol(chfrags_h)] <- paste0(colnames(chfrags_h)[2:ncol(chfrags_h)], "_h")
  # chfrags_summary <- merge(chfrags_r, chfrags_l, by = "chiidref", sort = FALSE, all.x = TRUE) |> 
  #   merge(chfrags_h, by = "chiidref", sort = FALSE, all.x = TRUE)
  # chfrags_summary$chiid <- chfrags_summary$chiidref
  # horizons(f) <- chfrags_summary
  
  # restrictions
  corestr <- data.table::data.table(dbQueryNASIS(NASIS(), "SELECT * FROM corestrictions") |> uncode())
  # omit some restriction kinds
  corestr <- subset(corestr, !corestr$reskind %in% c("abrupt textural change", 
                                                     "strongly contrasting textural stratification",
                                                     "undefined"))
  corestr.first <- corestr[, .SD[which.min(resdept_r),], by = list(coiid = corestr$coiidref)]
  site(f) <- corestr.first
  
  # flooding and ponding
  floodpond <- data.table::data.table(soilDB::get_comonth_from_NASIS_db(SS = FALSE))
  site(f) <- subset(floodpond[, paste0(month, collapse = ","), by = c("coiid", "flodfreqcl", "floddurcl")],
                     !is.na(flodfreqcl) & !flodfreqcl == "none")[, list(floodclass = paste0(paste(
                       tools::toTitleCase(as.character(flodfreqcl)), 
                       ifelse(is.na(floddurcl), "", as.character(floddurcl)), V1), collapse="; ")), by=c("coiid")]
  site(f) <- subset(floodpond[, paste0(month, collapse = ","),  by = c("coiid", "pondfreqcl", "ponddurcl")],
                     !is.na(pondfreqcl) & !pondfreqcl == "none")[, list(pondclass = paste0(paste(
                       tools::toTitleCase(as.character(pondfreqcl)), 
                       ifelse(is.na(ponddurcl), "", as.character(ponddurcl)), V1), collapse="; ")), by=c("coiid")]
  f$floodclass[is.na(f$floodclass)] <- "none"
  f$pondclass[is.na(f$pondclass)] <- "none"
  
  # calculated fragments >10, 3 to 10, 
  q <- "SELECT coiidref AS coiid, chiid, fraggt10_l, fraggt10_r, fraggt10_h, 
                                frag3to10_l, frag3to10_r, frag3to10_h,
                                sieveno10_l, sieveno10_r, sieveno10_h FROM chorizon"
  horizons(f) <- dbQueryNASIS(NASIS(), q)
  
  for (suffix in c("_l", "_r", "_h")) {
    # TODO: check this logic
    gt3wtpct <- pmin(100, f[[paste0("fraggt10", suffix)]] + f[[paste0("frag3to10", suffix)]])
    lt2mmpct <- f[[paste0("sieveno10", suffix)]]
    lt3gt2mmwtpct <- (100 - lt2mmpct)
    gt3vol <- gt3wtpct / 2.65 # cm3 of rock / 100g soil
    lt2mmvol <- lt2mmpct * ((100 - gt3wtpct) / 100) / f[[paste0("dbthirdbar", suffix)]] # cm3 of soil / in <3" fraction of 100g soil 
    lt3gt2mmvol <- lt3gt2mmwtpct * ((100 - gt3wtpct) / 100) / 2.65 # cm3 of rock / in <3" fraction of 100g soil 
    d <- data.frame(gt3vol, lt3gt2mmvol, lt2mmvol)
    # invert L and H for lt3gt2mmwtpct result
    swapsuffix <- ifelse(suffix == "_l", "_h", ifelse(suffix == "_h", "_l", "_r"))
    colnames(d) <- paste0(colnames(d), c(suffix, swapsuffix, suffix))
    d <- (d / rowSums(d)) * 100
    d$coiid <- f$coiid
    d$chiid <- f$chiid
    horizons(f) <- unique(d)
  }
    
  .fix_dupe_hz(f)
}

.phclasses <- function(halfclass = FALSE) {
  lut1 <- read.table(header = TRUE, 
                     text = 'DescriptiveTerm pH_low pH_high
  "Ultra Acid" 0 3.5
  "Extremely Acid" 3.55 4.4
  "Very Strongly Acid" 4.45 5.0
  "Strongly Acid" 5.05 5.5
  "Moderately Acid" 5.55 6.0
  "Slightly Acid" 6.05 6.5
  "Neutral" 6.55 7.3
  "Slightly Alkaline" 7.35 7.8
  "Moderately Alkaline" 7.85 8.4
  "Strongly Alkaline" 8.45 9.0
  "Very Strongly Alkaline" 9.05 14')
  if (halfclass) {
    lut2 <- lut1
    lut2$pH_high <- lut2$pH_low + ((lut2$pH_high - lut2$pH_low) / 2)
    lut1$pH_low <- lut2$pH_high
    lut <- rbind(data.frame(id = "Low", lut2), data.frame(id = "High", lut1))
    lut <- lut[order(lut$pH_low),]
  } else {
    lut1$id <- ""
    lut <- lut1
  }
  lut
}

.phclass <- function(x, halfclass = FALSE) {
  lut1 <- .phclasses(halfclass = halfclass)
  idx <- findInterval(x, lut1[["pH_low"]])
  clz <- trimws(tolower(paste(lut1[["id"]], lut1[["DescriptiveTerm"]])))
  factor(clz[idx], levels = clz, ordered = TRUE)
}

.phrange <- function(x, halfclass = FALSE) {
  if (any(grepl('high|low', x, ignore.case = TRUE))) halfclass <- TRUE
  lut1 <- .phclasses(halfclass = halfclass)
  clz <- trimws(tolower(paste(lut1[["id"]], lut1[["DescriptiveTerm"]])))
  res <- lut1[clz %in% tolower(x), c("pH_low", "pH_high")]
  res2 <- res[0,][1,]
  res2$pH_low <- min(res$pH_low)
  res2$pH_high <- max(res$pH_high)
  rownames(res2) <- NULL
  res2
}

ph_to_rxnclass <- function(x, halfclass = FALSE) {
  .phclass(x, halfclass = halfclass)
}

rxnclass_to_ph <- function(x, digits = 1, simplify = TRUE) {
  if (!is.list(x)) x <- list(x)
  res <- lapply(x, function(y) round(.phrange(y), digits = digits))
  if (length(res) == 1 && simplify) {
    return(res[[1]]) 
  }
  res
}

.quantfun <- function(x, log = FALSE, na.rm = TRUE) {
  nv <- c(n = sum(!is.na(x)), n_na = sum(is.na(x)), n_total = length(x))
  q <- quantile(
    x,
    probs = c(0, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 1),
    na.rm = na.rm
  )
  if (log) q <- exp(q)
  t(round(c(q, nv), 1))
}
