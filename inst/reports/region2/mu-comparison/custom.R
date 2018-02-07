# Mapunit summary utility functions

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


# remove NA from $value
# compute density for $value, using 1.5x "default" bandwidth
# re-scale to {0,1}
# return x,y values
scaled.density <- function(d, constantScaling=TRUE) {
  res <- stats::density(na.omit(d$value), kernel='gaussian', adjust=1.5)
  if(constantScaling)
    res$y <- scales::rescale(res$y)
    
  return(data.frame(x=res$x, y=res$y))
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


# http://stackoverflow.com/questions/16225530/contours-of-percentiles-on-level-plot
kdeContours <- function(i, prob, cols, m, ...) {
  
  if(nrow(i) < 2) {
    return(NULL)
  }
  
  this.id <- unique(i$.id)
  this.col <- cols[match(this.id, m)]
  dens <- kde2d(i$x, i$y, n=200); ## estimate the z counts
  
  dx <- diff(dens$x[1:2])
  dy <- diff(dens$y[1:2])
  sz <- sort(dens$z)
  c1 <- cumsum(sz) * dx * dy
  levels <- sapply(prob, function(x) {
    approx(c1, sz, xout = 1 - x)$y
  })
  
  # add contours if possibly
  if(!is.na(levels))
    contour(dens, levels=levels, drawlabels=FALSE, add=TRUE, col=this.col, ...)
  
  # # add bivariate medians
  # points(median(i$x), median(i$y), pch=3, lwd=2, col=this.col)
}


# masking function applied to a "wide" data.frame of sampled raster data
# function is applied column-wise
# note: using \leq and \geq for cases with very narrow distributions
mask.fun <- function(i) {
  res <- i >= quantile(i, prob=0.05, na.rm=TRUE) & i <= quantile(i, prob=0.95, na.rm=TRUE)
  return(res)
}


# cut down to reasonable size: using cLHS
f.subset <- function(i, n, non.id.vars) {
  # if there are more than n records, then sub-sample
  if(nrow(i) > n) {
    # columns with IDs have been pre-filtered
    idx <- clhs(i[, non.id.vars], size=n, progress=FALSE, simple=TRUE, iter=1000)
    i.sub <- i[idx, ]
  }
  #	otherwise use what we have
  else
    i.sub <- i
  
  return(i.sub)
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

# custom stats for box-whisker plot: 5th-25th-50th-75th-95th percentiles
# NOTE: we are re-purposing the coef argument!
# x: vector of values to summarize
# coef: Moran's I associated with the current raster
custom.bwplot <- function(x, coef=NA, do.out=FALSE) {
  # custom quantiles for bwplot
  stats <- quantile(x, p=c(0.05, 0.25, 0.5, 0.75, 0.95), na.rm = TRUE)
  # number of samples
  n <- length(na.omit(x))
  
  # compute effective sample size
  rho <- coef
  n_eff <- ESS_by_Moran_I(n, rho)
  
  # confidence "notch" is based on ESS
  iqr <- stats[4] - stats[2]
  conf <- stats[3] + c(-1.58, 1.58) * iqr/sqrt(n_eff)
  
  out.low <- x[which(x < stats[1])]
  out.high <- x[which(x > stats[5])]
  
  return(list(stats=stats, n=n, conf=conf, out=c(out.low, out.high)))
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

