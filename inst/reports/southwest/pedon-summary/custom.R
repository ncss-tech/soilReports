##
## Purpose: these are custom functions and plotting styles used within the DMU reports
##

##
## many different summaries have low-rv-high percentiles hard-coded
##

options(stringsAsFactors=FALSE)
options(width=140)

##
## plotting styles:
##
tps.standard <- list(
  plot.symbol = list(col = 1, cex = 1, pch = 1),
  plot.line = list(col = 1, lwd = 2, alpha = 0.75),
  strip.background = list(col = grey(c(0.85, 0.75))),
  layout.heights = list(strip = 1.5),
  box.umbrella = list(col = 1, lty = 1),
  box.rectangle = list(col = 1),
  box.dot = list(col = 1, cex = 0.5)
)

##
## functions 
##

# return a table of proportions, including missing data, along with sample size as data.frame
# 'x' must be a factor with levels set in logical order
categorical.prop.table <- function(x, digits=2) {
  # table of proportions, including missing data, with rounding
  x.table <- round(prop.table(table(x, useNA='always')), digits)
  # convert to data.frame for pretty-printing
  x.table.df <- data.frame(t(as.numeric(x.table)), stringsAsFactors=FALSE)
  # transfer names
  names(x.table.df) <- names(x.table)
  # fix NA heading, always the last item
  names(x.table.df)[ncol(x.table.df)] <- 'No.Data'
  # add number of pedons
  x.table.df$N.pedons <- length(x)
  # done
  return(x.table.df)
}


## TODO: finish this function
# generate dendrogram or Sammon mapping plot and color by musym
dend.by.musym <- function(f.i, v=c('clay','total_frags_pct')) {

  # lower depth for comparison
  max.depth.dissimilarity <- max(f.i, 'clay')
  if(is.na(max.depth.dissimilarity))
    max.depth.dissimilarity <- 200

  # if we have more than 3 profiles, eval dissimilarity
  if(length(f.i) > 3) {
    ## evaluate this: would make more sense to include site-level data too
    # generate between-profile dissimilarity for plot-order
    # note that this breaks when we include profiles without any data
    # generate an index to non-R|Cr|Cd horizons
    filter.idx <- grep('R|Cr|Cd', f.i$genhz, invert=TRUE)
    d <- profile_compare(f.i, vars=v, max_d=max.depth.dissimilarity, k=0, filter=filter.idx, rescale.result=TRUE)
    
    # reduce to 2D: fudge 0-distances by adding a little bit
    s <- isoMDS(d+0.001)
    # generate plotting order as Euclidean distance to origin
    d.order <- order(sqrt(rowSums(sweep(s$points, MARGIN=2, STATS=c(0, 0), FUN='-')^2)))
  }
  
}

## TODO: which quantile "type" is most appropriate?
##    see: http://stackoverflow.com/questions/95007/explain-the-quantile-function-in-r
##    test with: x <- sample(1:100, size=20, replace=TRUE) ; round(t(sapply(1:9, function( i ) quantile(x, type=i))), 2)
##    type = 1: standard interpretation, no interpolation
##    type = 7: (default)
## TODO: this cannot be applied to circular data!
##  data and return as L-RV-H
l.rv.h.summary <- function(i, p=getOption('p.low.rv.high'), qt=getOption('q.type'), sep='-') {
	q <- round(quantile(i, probs=p, na.rm=TRUE, type=qt))
	paste(q, collapse='-')
}

## TODO: which quantile "type" is most appropriate?
##    see: http://stackoverflow.com/questions/95007/explain-the-quantile-function-in-r
##    test with: x <- sample(1:100, size=20, replace=TRUE) ; round(t(sapply(1:9, function( i ) quantile(x, type=i))), 2)
##    type = 1: standard interpretation, no interpolation
##    type = 7: (default)
#  data by generalized horizon
# note: conditional evaluation of rounding: phfield rounded to 1 dec. place, 
# all others to 0 dec. places
conditional.l.rv.h.summary <- function(x, p=getOption('p.low.rv.high'), qt=getOption('q.type')) {
	precision.table <- c(1, 2)
	precision.vars <- c('phfield', 'albedo')
	variable <- unique(x$variable)
	v <- na.omit(x$value) # extract column, from long-formatted input data
	n <- length(v) # get length of actual data
	ci <- quantile(v, na.rm=TRUE, probs=p, type=qt)
  mn <- min(v, na.rm=TRUE)
	mx <- max(v, na.rm=TRUE)
  low <- ci[1] # low
	rv <- ci[2] #  median
	high <- ci[3] # high
	precision <- if(variable %in% precision.vars) precision.table[match(variable, precision.vars)] else 0
	s <- round(c(mn, low, rv, high, mx), precision)
	# combine essentials into DF
  d <- data.frame(n=n, min=mn, max=mx, low=low, rv=rv, high=high, stringsAsFactors=FALSE) 
	# add 'range' column for pretty-printing
	d$range <- with(d, paste0('<div style="width=100%;"><span style="font-size:70%; width:10%; padding:2px">' , s[1], '</span>','<span style="font-size:90%; width:15%; padding:2px">' , s[2], '</span>', '<span style="font-size:100%; width:25%; padding:2px">', s[3], '</span><span style="font-size:90%; width:15%; padding:2px">', s[4], '</span><span style="font-size:70%; width:10%; padding:2px">', s[5], '</span>')) 
  # add the number of data points
  d$range <- paste0(d$range, '<br><span style="width: 25%;">(', n, ')</span><div>')
  
  # remove NA, Inf, and -Inf
  d$range <- gsub(pattern='NA', replacement='*', x=d$range, fixed=TRUE)
	d$range <- gsub(pattern='-Inf', replacement='*', x=d$range, fixed=TRUE)
	d$range <- gsub(pattern='Inf', replacement='*', x=d$range, fixed=TRUE)
	return(d)
}

## TODO integrate into single summary -> L-RV-H function
diagnostic.hz.summary <- function(x, p, qt=7) {
	# get number of records involved
	n <- nrow(x)
	
	# get low,RV,high values for diagnostic hz boundaries
	f.top <- quantile(x$featdept, probs=p, na.rm=TRUE, type=qt)
	f.bottom <- quantile(x$featdepb, probs=p, na.rm=TRUE, type=qt)
	f.thick <- quantile(x$featdepb - x$featdept, probs=p, na.rm=TRUE, type=qt)
  
	# convert into low-RV-high notation
	r.top <- paste(round(f.top), collapse='-')
	r.bottom <- paste(round(f.bottom), collapse='-')
	r.thick <- paste(round(f.thick), collapse='-')
	
	# combine into DF and return
	d <- data.frame(n=n, top=r.top, bottom=r.bottom, thick=r.thick, stringsAsFactors=FALSE)
	return(d)
}


# from ?toupper
capwords <- function(s, strict = FALSE) {
	cap <- function(s) paste(toupper(substring(s,1,1)),
{s <- substring(s,2); if(strict) tolower(s) else s},
													 sep = "", collapse = " " )
	sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

## custom bwplot function: note that we are altering the interpretation of a bwplot!
## "outliers" removed
custom.bwplot <- function(x, coef=1.5, do.out=FALSE) {
	stats <- quantile(x, p=c(0.05, 0.25, 0.5, 0.75, 0.95), na.rm=TRUE)
	n <- length(na.omit(x))
	# out.low <- x[which(x < stats[1])]
	# out.high <- x[which(x > stats[5])]
	return(list(stats=stats, n=n, conf=NA, out=c(NA, NA)))
}


## summarise surface frags
## TODO: low-rv-high values are hard-coded!
summarise.pedon.surface.frags <-  function(d) {
	
	# compute low-rv-high values... result is L-RV-H
  vars <- c('surface_gravel', 'surface_cobbles', 'surface_stones', 'surface_boulders', 'surface_channers', 'surface_flagstones', 'surface_paragravel', 'surface_paracobbles')

	d.summary <- colwise(l.rv.h.summary)(d[, vars])
	# done
	return(d.summary)
}


## summarise GIS data embedded in our SPC (d) as site-level data
## TODO: low-rv-high values are hard-coded!
## TODO: proper summary of aspect data
summarise.pedon.gis.data <- function(d) {
	
  # keep only those variables with gis_* prefix, 'slope_field'
  nm <- names(d)
  nm.idx <- grep('gis_', nm, ignore.case=TRUE)
  v <- c('slope_field', nm[nm.idx])
  # note: drop=FALSE will not convert to vector when gis_ vars are missing
  d <- d[, v, drop=FALSE]
	
  # TODO: this is a hack remove gis_aspect and gis_geomorphons if present
  d$gis_aspect <- NULL
  d$gis_geomorphons <- NULL
  
	# compute low-rv-high values, by column
  # result is L-RV-H
	d.summary <- colwise(l.rv.h.summary)(d)
	
	# done
	return(d.summary)
}


##  texture class
summarize.texture.class <- function(i) {
	tt <- sort(round(prop.table(table(i$texture)), 2), decreasing=TRUE)
	tt.formatted <- paste(paste(toupper(names(tt)), ' (', tt, ')', sep=''), collapse=', ' )
	
	# return blank when there are no values
	if(length(tt) == 0)
		return('')
	
	return(tt.formatted)
}


# f.i: subset of the SPC containing only pedons to aggregate
# comp: the name of the current component
summarize.component <- function(f.i) {

  ## TODO: this is wasteful, as we only need 'upedonid' from @site
	# extract horizon+site as data.frame
	h.i <- as(f.i, 'data.frame')
	
	# add a new column: horizon thickness
	h.i$thick <- with(h.i, hzdepb - hzdept) 
	
	# convert dry Munsell Hue into Albedo
	# Soil Sci. Soc. Am. J. 64:1027-1034 (2000)
	h.i$albedo <- (0.069 * h.i$d_value) - 0.114
	
	# extract site data
	site.i <- site(f.i)
	
	## pedon GIS summaries
	pedon.gis.table <- summarise.pedon.gis.data(site.i)
	
	## surface fragment summary
	pedon.surface.frags.table <- summarise.pedon.surface.frags(site.i)
	
  ## check for missing genhz labels by pedon
	missing.all.genhz.IDs <- ddply(h.i, 'upedonid', function(i) all(is.na(i$genhz)))
	missing.some.genhz.IDs <- ddply(h.i, 'upedonid', function(i) any(is.na(i$genhz)))
  missing.genhz.IDs <- join(missing.all.genhz.IDs, missing.some.genhz.IDs, by='upedonid')
  names(missing.genhz.IDs) <- c('upedonid', 'missing.all', 'missing.some')
  # determine type of missing data
	missing.genhz.IDs$missing.genhz <- apply(missing.genhz.IDs[, -1], 1, function(i) {
    if(any(i) & ! all(i))
      return('<span style="color:orange; font-weight:bold;">some</span>')
    if(all(i)) 
      return('<span style="color:red; font-weight:bold;">all</span>')
    else
      return('<span style="color:green;">none</span>')
    })
  
  
	## check generalized hz classification
	gen.hz.classification.table <- table(h.i$genhz, h.i$hzname)
  	
	# variables to summarize
	vars <- c('claytotest', 'sandtotest', 'phfield', 'gravel', 'paragravel', 'cobbles', 'paracobbles', 'stones', 'channers', 'flagstones', 'total_frags_pct_nopf', 'albedo')
  # better names, used in final tables / figures
	var.names <- c('HZ', 'claytotest', 'sandtotest', 'pH', 'GR', 'PGR', 'CB', 'PCB', 'ST', 'CN', 'FL', 'Total RF', 'Albedo')
  
  
	# wide -> long, inclide musym for plotting
	h.i.long <- melt(h.i, id.vars=c('genhz', 'musym'), measure.vars=vars)
  
  # drop values not associated with a generalized horizon label
  h.i.long <- subset(h.i.long, subset=!is.na(genhz))
	
	# summary by variable / generalized hz label
	s.i <- ddply(h.i.long, c('variable', 'genhz'), .fun=conditional.l.rv.h.summary, p=getOption('p.low.rv.high'), qt=getOption('q.type'))
	
	if (nrow(s.i) > 0) {
  	## tables
  	# long -> wide
  	prop.by.genhz.table <- dcast(s.i, genhz ~ variable, value.var='range')
  	names(prop.by.genhz.table) <- var.names
  	
  	# texture class tables
  	texture.table <- ddply(h.i, c('genhz'), summarize.texture.class)
    names(texture.table) <- c('Generalized HZ', 'Texture Classes')
  	
  	# diagnostic hz tables
  	diag.hz.table <- ddply(diagnostic_hz(f.i), c('featkind'), .fun=diagnostic.hz.summary, p=getOption('p.low.rv.high'), qt=getOption('q.type'))
  	names(diag.hz.table) <- c('kind', 'N', 'top', 'bottom', 'thick')
	} else {
	  prop.by.genhz.table <- NULL
	  texture.table <- NULL
	  diag.hz.table <- NULL
	  f.i$genhz <- "<not-used>"
	}
	
	## ML-horizonation
	# aggregate
	gen.hz.aggregate <- slab(f.i, ~ genhz, cpm=1)
	
	# extract original horizon designations and order
	original.levels <- attr(gen.hz.aggregate, 'original.levels')
  
	# melt into long format, accomodating illegal column names (e.g. 2Bt)
	gen.hz.aggregate.long <- melt(gen.hz.aggregate, id.vars='top', measure.vars=make.names(original.levels))
	
	# replace corrupted horizon designations with original values
	gen.hz.aggregate.long$variable <- factor(gen.hz.aggregate.long$variable, levels=levels(gen.hz.aggregate.long$variable), labels=original.levels)
	
	# replace very small probabilities with NA
	gen.hz.aggregate.long$value[gen.hz.aggregate.long$value < 0.001] <- NA
  
  # remove NA probabilities
	gen.hz.aggregate.long <- na.omit(gen.hz.aggregate.long)
  
  
	## EXPERIMENTAL: smooth horizon probability depth functions for simpler interpretation
	## a smoothing parameter of 0.65 seens to be a good compromise
  ## this can create over-shoots
	## ideally we would use a PO-model for this
  ## note: smoothing is only possible >= 4 unique values, in this case no smoothing is applied
	gen.hz.aggregate.long <- ddply(gen.hz.aggregate.long, 'variable', function(i) {
    if(length(unique(i$value)) >= 4)
		  s <- smooth.spline(i$value, spar=getOption('ml.profile.smoothing'), keep.data=FALSE)$y
    else
      s <- i$value
    # combine into a data.frame
    d <- data.frame(top=i$top, value=s)
		return(d)
		} )
	
	
	# generate ML hz table
	gen.hz.ml <- get.ml.hz(gen.hz.aggregate)
  
  # combine all genhz levels with those in the ML hz table
  gzml <- data.frame(hz=factor(original.levels, levels=original.levels))	
  gzml <- join(gzml, gen.hz.ml, by='hz')
  
  # paste together columns, into the format: genhz top-bottom [pseudo.brier]
  labels.for.plot <- with(gzml, paste0(hz, ' ', top, '-', bottom, ' [', round(pseudo.brier, 3), ']'))
	labels.for.plot <- gsub(pattern='NA', replacement='*', labels.for.plot)
  
  # reset factor labels, using data from the ML hz table
  gen.hz.aggregate.long$variable <- factor(gen.hz.aggregate.long$variable, levels=original.levels, labels=labels.for.plot)
  
  # get a reasonable lower depth for the plot
  y.max <- pmax(155, max(f.i, 'clay'))
  
	# plot genhz probabilities vs. depth
	gen.hz.aggregate.plot <- xyplot(top ~ value, groups=variable, data=gen.hz.aggregate.long, type=c('l'), ylim=c(y.max, -5), xlim=c(-0.1, 1.1), auto.key=list(cex=1, space='right', columns=1, padding.text=3, points=FALSE, lines=TRUE), ylab='Depth (cm)', xlab='Horizon Probability', scales=list(alternating=3, y=list(tick.number=15)), panel=function(...) {
		panel.abline(v=seq(0, 1, by=0.1), h=seq(0, 150, by=10), col=gray(0.75), lty=3)
		panel.xyplot(...)
		})
	
  
  ## properties by musym / genhz
  # throw-out non-soil horizons
  h.i.long.sub <- h.i.long[grep('R|Cr|Cd', h.i.long$genhz, ignore.case=TRUE, invert=TRUE), ]
  
  # bwplot
  if (nrow(h.i.long.sub) > 0) {
    prop.by.musym.and.genhz <- bwplot(
      musym ~ value | variable + genhz,
      data = h.i.long.sub,
      as.table = TRUE,
      xlab = '',
      scales = list(x = list(relation = 'free')),
      drop.unused.levels = TRUE,
      par.settings = tps.standard,
      stats = custom.bwplot,
      par.strip.text = list(cex = 0.75),
      panel = function(...) {
        panel.grid(-1, -1)
        panel.bwplot(...)
      }
    )
    
    # convert second paneling dimension to outer strips
    prop.by.musym.and.genhz <- useOuterStrips(prop.by.musym.and.genhz)
  } else {
    prop.by.musym.and.genhz <- bwplot(musym ~ value,
                                      data = h.i.long.sub)
  }
  
	# pack into list and return
	return(list(n=length(f.i), pg=pedon.gis.table, mgz=missing.genhz.IDs, ct=gen.hz.classification.table, rt=prop.by.genhz.table, dt=diag.hz.table, tt=texture.table, ml.hz=gen.hz.ml, ml.hz.plot=gen.hz.aggregate.plot, sf=pedon.surface.frags.table, pmg=prop.by.musym.and.genhz))
}


