# load required packages
library(rgdal, quietly=TRUE)
library(raster, quietly=TRUE)
library(plyr, quietly=TRUE)
library(reshape2, quietly=TRUE)
library(sharpshootR, quietly=TRUE)
library(latticeExtra, quietly=TRUE)
library(cluster, quietly=TRUE)
library(MASS, quietly=TRUE)
library(clhs, quietly=TRUE)

## load local configuration
source('config.R')

# load map unit polygons from OGR data source
mu <- try(readOGR(dsn=mu.dsn, layer=mu.layer, stringsAsFactors = FALSE))
if(class(mu) == 'try-error')
  stop(paste0('Cannot find map unit polygon file/feature: "', mu.dsn, ' / ', mu.layer, '"'), call. = FALSE)

# if no filter, then keep all map units
if(exists('mu.set')) {
  # filter
  mu <- mu[which(mu[[mu.col]] %in% mu.set), ]
} else {
  mu.set <- unique(mu[[mu.col]])
}

# basic colors
cols <- brewer.pal(9, 'Set1')

# add a unique polygon ID
mu$pID <- seq(from=1, to=length(mu))

# load pointers to raster data
raster.list <- lapply(raster.list, function(i) {
  i <- try(raster(i))
  if(class(i) == 'try-error')
    stop(paste0('Cannot find raster file: ', i), call. = FALSE)
  else
    return(i)
})

# iterate over rasters and read into memory if possible
nm <- names(raster.list)
for(i in 1:length(nm)) {
  
  # attempt reading into memory, starting with smallest rasters first
  r <- try(readAll(raster.list[[i]]), silent = TRUE)
  # if successful, move into list
  if(class(r) == 'RasterLayer' )
    raster.list[[i]] <- r
}

# iterate over map units and sample
l.mu <- list() # samples
l.unsampled <- list() # un-sampled polygon IDs
a.mu <- list() # area stats
for(mu.i in mu.set) {
  # debugging:
  print(mu.i)
  
  # get current polygons
  mu.i.sp <- mu[which(mu[[mu.col]] == mu.i), ]
  
  # sample each polygon at a constant density, 1 point per acre
  s <- constantDensitySampling(mu.i.sp, n.pts.per.ac=pts.per.acre, min.samples=1, polygon.id='pID', iterations=20)
  
  # keep track of un-sampled polygons
  l.unsampled[[mu.i]] <- setdiff(mu.i.sp$pID, unique(s$pID))
  
  # make a unique sample ID, need this for conversion: long -> wide
  s$sid <- 1:nrow(s)
  
  # iterate over raster data
  l <- list()
  for(i in seq_along(raster.list)) {
    i.name <- names(raster.list)[i]
    l[[i.name]] <- data.frame(value=extract(raster.list[[i]], s), pID=s$pID, sid=s$sid)
  }
  
  # convert to DF and fix default naming of raster column
  d <- ldply(l)
  names(d)[1] <- 'variable'
  
  # extract polygon areas as acres
  a <- sapply(slot(mu.i.sp, 'polygons'), slot, 'area') * 2.47e-4
  
  # compute additional summaries
  .quantiles <- quantile(a, probs=c(0, 0.05, 0.25, 0.5, 0.75, 0.95, 1))
  .total.area <- sum(a)
  .samples <- nrow(s)
  .mean.sample.density <- round(.samples / .total.area, 2)
  .polygons <- length(a)
  .unsampled.polygons <- length(l.unsampled[[mu.i]])
  
  # compile into single row
  a.stats <- c(round(c(.quantiles, .total.area, .samples, .polygons, .unsampled.polygons)), .mean.sample.density)
  
  # fix name
  names(a.stats) <- c('Min', 'Q5', 'Q25', 'Median', 'Q75', 'Q95', 'Max', 'Total Area', 'Samples', 'Polygons', 'Polygons Not Sampled', 'Mean Sample Dens.')
  
  # save and continue
  a.mu[[mu.i]] <- a.stats
  l.mu[[mu.i]] <- d
}

# assemble into DF
d.mu <- ldply(l.mu)
unsampled.idx <- unlist(l.unsampled)
mu.area <- ldply(a.mu)


# save samples and set of (possibly filtered) map unit labels
save(d.mu, unsampled.idx, mu.area, mu.set, file='cached-samples.Rda')


