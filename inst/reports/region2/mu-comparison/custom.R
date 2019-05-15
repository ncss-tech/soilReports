## Mapunit summary utility functions

## Note: warnings will corrupt md markup that is created by this function
makeCategoricalOutput <- function(dat, do.spatial.summary=TRUE) {
  
  # this just takes first name; fn intended to be called via lapply w/ list of dataframes 1 frame per var
  variable.name <- unique(dat$variable)[1]
  pat <- variableNameToPattern(variable.name)
  
  metadat <- lvls <- lbls <- list()
  
  # if no specific metadata for this variable, use the variable name as used in config file as header
  if(is.null(pat)) {
    metadat$header <- variable.name 
    metadat$description <- ""
    metadat$levels <- unique(dat$value)
    # does nothing special... one value = one label as character
    metadat$labels <- metadat$levels
    
    # local copies, for what?
    lvls <- metadat$levels
    lbls <- metadat$labels
    
    ## TODO: better colors for varyinf number of possible categories
    # default colors, not very nice
    # note: use a color ramp function for an arbitrary number of colors
    metadat$colors <- colorRampPalette(brewer.pal(pmin(length(metadat$levels), 9), 'Set1'))(length(metadat$levels))
    
    metadat$decimals <- 2
    dat$value <- factor(dat$value, levels=metadat$levels, labels=metadat$labels)
    
  } else {
    # metadata is defined in categorical_definitions.R
    ## note: this object exists outside of the scope of this function
    metadat <- categorical.defs[[pat]] 
    flag <- FALSE
    
    # do not have to specify keep all classes, optional parameter.
    if(!is.null(metadat$keep.all.classes)) {
      if(metadat$keep.all.classes) 
        flag <- TRUE
    }
    
    # default behavior is to remove extraneous classes for table readability
    if(!flag) {
      lvls <- metadat$levels[metadat$levels %in% dat$value]
      lbls <- metadat$labels[metadat$levels %in% lvls]
    } else {
      # TODO: document this
      lvls <- metadat$levels
      lbls <- metadat$labels
    }
    
    dat$value <- factor(dat$value, levels=lvls, labels=lbls)
  }
  
  cat(paste0("  \n### ", metadat$header,"  \n"))
  if(!is.null(metadat$description))  {
    cat(paste0("  \n",metadat$description,"  \n"))
  }
  if(!is.null(metadat$usage))  {
    cat("  \n  **Suggested usage:**  \n")
    cat(paste0("  \n",metadat$usage,"  \n  \n"))
  }
  
  
  ## sanity check: if the wrong raster is specified in the config file, levels will not match codes
  ##               and all values with be NA
  if(all(is.na(dat$value))){
    stop(sprintf('all samples for "%s" are NA, perhaps the wrong raster file was specified?', variable.name))
  }
  
  # convert counts into proportions
  x <- sweepProportions(dat)
  
  # tidy legend by removing "near-zero" proportions
  idx <- which(apply(x, 2, function(i) any(i > 0.001)))
  
  # now remove the extra classes if we had to drop a class after determining proportions to be too small
  # this ensures that the correct color is used for each class
  bad.vars.flag <- (!lbls %in% colnames(x[, -idx]))
  lvls <- lvls[bad.vars.flag]
  lbls <- lbls[bad.vars.flag]
  
  # remove classes with near-zero proportions
  # result is a table
  x <- x[, idx, drop=FALSE]
  
  # convert table -> data.frame, factor levels are lost
  # implicitly converted to long format
  x.long <-as.data.frame.table(x, stringsAsFactors = FALSE)
  
  # re-add factor levels for MUSYM and raster labels
  x.long$.id <- factor(x.long$.id, levels = levels(dat$.id))
  x.long$value <- factor(x.long$value, levels = lbls)
  
  # re-label long-format for plotting
  names(x.long)[2] <- "label"
  names(x.long)[3] <- "value"
  
  
  # create a signature of the most frequent classes that sum to 75% or
  x.sig <- apply(x, 1, classSignature)
  x.sig <- as.data.frame(x.sig)
  names(x.sig) <- 'mapunit composition "signature" (most frequent classes that sum to 75% or more)'
  
  # get a signature for each polygon
  spatial.summary <- ddply(dat, c( '.id', 'pID'), .fun=sweepProportions, drop.unused.levels=FALSE, single.id=TRUE)
  
  ## most likely class
  most.likely.class.idx <- 1
  
  if(!is.null(ncol(spatial.summary[,-c(1,2)]))) # prevent problems when one class is observed in samples (MU has low variance w.r.t raster)
    most.likely.class.idx <- apply(spatial.summary[, -c(1:2)], 1, which.max)
  
  spatial.summary[[paste0('ml_', variable.name)]] <- levels(dat$value)[most.likely.class.idx]
  
  ## implemented via aqp::shannonEntropy()
  # shannon entropy, log base 2 (bits) by polygon
  # shannon entropy is zero when mapunit is "pure"
  if(!is.null(ncol(spatial.summary[, -c(1,2,length(names(spatial.summary)))]))) #handle same problem as above;
    spatial.summary[[paste0('shannon_h_', variable.name)]] <- apply(spatial.summary[, -c(1,2,length(names(spatial.summary)))], 1, aqp::shannonEntropy, b=2)
  else
    spatial.summary[[paste0('shannon_h_', variable.name)]] <- rep(0, length(spatial.summary[, -c(1,2,length(names(spatial.summary)))])) 
  
  
  # setup plot styling
  colors <-  metadat$colors[metadat$levels %in% lvls]
  tps <- list(superpose.polygon=list(col=colors, lwd=2, lend=2))
  trellis.par.set(tps)
  
  # setup legend configuration
  sK.levels <- levels(x.long$label)
  if(length(sK.levels) < 3) {
    sK.columns <- length(sK.levels)
  } else {
    sK.columns <- 3 # hard-coded for now, TODO: dynamically set for space-saving and readability (#66)
  }
  
  # compose legend
  sK <- simpleKey(space='top', columns=sK.columns, text=sK.levels, rectangles = TRUE, points=FALSE)
  
  if(length(unique(x.long$.id)) > 1 & do.spatial.summary) {
    # cluster proportions
    # note: daisy will issue warnings when there is only a single class with non-0 proportions
    #       warnings emitted at this point will corrupt MD markup
    x.d <- as.hclust(diana(suppressWarnings(daisy(x))))
    # re-order MU labels levels based on clustering
    x.long$.id <- factor(x.long$.id, levels=unique(x.long$.id)[x.d$order])
    # musym are re-ordered according to clustering
    cat('  \n  \n')
    print(barchart(.id ~ value, groups=x.long$label, data=x.long, horiz=TRUE, stack=TRUE, xlab='Proportion of Samples', scales=list(cex=1.5), key=sK, legend=list(right=list(fun=dendrogramGrob, args=list(x = as.dendrogram(x.d), side="right", size=10)))))
    cat('  \n  \n')
  } else {
    # re-order MUSYM labels according to original ordering, specified in mu.set
    x.long$.id <- factor(x.long$.id, levels=levels(dat$.id))
    
    trellis.par.set(tps)
    cat('  \n  \n')
    print(barchart(.id ~ value, groups=x.long$label, data=x.long, horiz=TRUE, stack=TRUE, xlab='Proportion of Samples', scales=list(cex=1.5), key=sK))
    cat('  \n  \n')
  }  
  print(kable(x, digits = metadat$decimals))
  cat('  \n  \n')
  if(do.spatial.summary) {
    print(kable(x.sig))
    cat('  \n  \n')
    mu <- merge(mu, spatial.summary, by='pID', all.x=TRUE)
  }
  return(TRUE)
}


classSignature <- function(i) {
  # order the proportions of each row
  o <- order(i, decreasing = TRUE)
  
  # determine a cut point for cumulative proportion >= threshold value
  thresh.n <- which(cumsum(i[o]) >= 0.75)[1]
  
  # sanity check: if all classes are 0 then results are NA and we stop now
  if(is.na(thresh.n))
    return("NA")
  
  # if there is only a single class that dominates, then offset index as we subtract 1 next
  if(thresh.n == 1)
    thresh.n <- 2
  
  # get the top classes
  top.classes <- i[o][1:(thresh.n-1)]
  
  # format for adding to a table
  paste(names(top.classes), collapse = '/')
}





# TODO: this could be useful in soilReports? not really sharpshootR worthy since it has nothing to do with soil... might be best just left here
# abstracted this for use in the default symbology for "undefined" categoricals, made a call for the old use of defining mapunit colors for legends
makeNiceColors <- function(n) {
  # 7 or fewer classes, use high-constrast colors
  if(n <= 7) {
    cols <- brewer.pal(9, 'Set1') 
    # remove light colors
    cols <- cols[c(1:5,7,9)]
  } else {
    # otherwise, use 12 paired colors
    cols <- brewer.pal(12, 'Paired')
  }
  return(cols[1:n])
}

abbreviateNames <- function(spdf) {
  sapply(names(spdf)[-1], function(i) {
    # keep only alpha and underscore characters in field names
    i <- gsub('[^[:alpha:]_]', '', i)
    # abbreviate after filtering other bad chars
    abbr <- abbreviate(i, minlength = 10)
    return(abbr)
  })
}

# return DF with proportions outside range for each polygon (by pID)
flagPolygons <- function(i) {
  
  # convert to values -> quantiles
  e.i <- ecdf(i$value)
  q.i <- e.i(i$value)
  # locate those samples outside of our 5th-95th range
  out.idx <- which(q.i < 0.05 | q.i > 0.95)
  
  ## TODO: may need to protect against no matching rows?
  tab <- sort(prop.table(table(i$pID[out.idx])), decreasing = TRUE)
  df <- data.frame(pID=names(tab), prop.outside.range=round(as.vector(tab), 2))
  
  # keep only those with > 15% of samples outside of range
  #df <- df[which(df$prop.outside.range > p.crit), ]  
  
  #all proportions outside now reported in QC shapefile; no need to have a threshold
  return(df)
}





# masking function applied to a "wide" data.frame of sampled raster data
# function is applied column-wise
# note: using \leq and \geq for cases with very narrow distributions
mask.fun <- function(i) {
  res <- i >= quantile(i, prob=0.05, na.rm=TRUE) & i <= quantile(i, prob=0.95, na.rm=TRUE)
  return(res)
}





# set multi-row figure based on number of groups and fixed number of columns
dynamicPar <- function(n, max.cols=3) {
  # simplest case, fewer than max number of allowed columns
  if(n <= max.cols) {
    n.rows <- 1
    n.cols <- n
  } else {
    
    # simplest case, a square
    if(n %% max.cols == 0) {
      n.rows <- n / max.cols
      n.cols <- max.cols
    } else {
      # ragged
      n.rows <- round(n / max.cols) + 1
      n.cols <- max.cols
    }
  }
  
  par(mar=c(0,0,0,0), mfrow=c(n.rows, n.cols))
  # invisibly return geometry
  invisible(c(n.rows, n.cols))
}

# stat summary function
f.summary <- function(i, p) {
  
  # remove NA
  v <- na.omit(i$value)
  
  # compute quantiles
  q <- quantile(v, probs=p)
  res <- data.frame(t(q))
  
  ## TODO: implement better MADM processing and explanation  
  if(nrow(res) > 0) {
    #     # MADM: MAD / median
    #     # take the natural log of absolute values of MADM
    #     res$log_abs_madm <- log(abs(mad(v) / median(v)))
    #     # 0's become -Inf: convert to 0
    #     res$log_abs_madm[which(is.infinite(res$log_abs_madm))] <- 0
    
    # assign reasonable names (quantiles)
    names(res) <- c(paste0('Q', p * 100))
    
    return(res)
  }
  else
    return(NULL)
}


#####
## Functions for manipulating categorical variable set
#TODO: these are connotative but somewhat confusingly named... refactor eventually. all basicalyl internal stuff so not a huge issue.
# Functions for use in dealing with arbitrary categoricals, categorical symbology and toggling of sections when new categoricals are added
variableNameFromPattern <-  function (pattern) {
  unique(d.cat$variable)[grep(pattern, unique(d.cat$variable), ignore.case = TRUE)]
}

variableNameToPattern <- function(name) {
  patterns = names(categorical.defs)
  for(p in patterns)
    if(grepl(p, name, ignore.case = TRUE)) return(p)
  return(NULL)
}

categoricalVariableHasDefinition <- function(variable.name) {
  if(sum(names(categorical.defs) %in% variable.name) > 0) return(TRUE)
  return(FALSE)
}

subsetByName <- function(name) {
  return(subset(d.cat, subset=(variable == name)))
}

subsetByPattern <- function(pattern) {
  subsetByName(getCategoricalVariableNameFromPattern(pattern))
}

# i: data.frame with '.id' and 'value' columns
# drop.unused.levels: this affects all unused levels
# single.id: FALSE when summarizing all MUSYM, TRUE when specific to single MUSYM
sweepProportions <- function(i, drop.unused.levels=FALSE, single.id=FALSE) {
  # must drop missing .id factor levels when used with a single .id e.g. for spatial summaries
  if(single.id)
    i$.id <- factor(i$.id)
  
  # tabulate and convert to proportions, retain all levels of ID
  foo <- xtabs(~ .id + value, data=i, drop.unused.levels=drop.unused.levels)
  res <- sweep(foo, MARGIN = 1, STATS = rowSums(foo), FUN = '/')
  
  # 2017-12-11: 0-samples result in NA, convert those back to 0
  if(any(is.na(res)))
    res[is.na(res)] <- 0
  
  return(res)
}

