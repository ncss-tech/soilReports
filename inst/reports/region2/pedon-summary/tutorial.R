#load required packages
library(aqp)
library(soilDB)
library(sharpshootR)
library(igraph)
library(ape)
library(latticeExtra)
library(plyr)
library(lattice)
library(cluster)
library(MASS)

library(knitr)
library(reshape2)
library(xtable)
library(Hmisc)
library(gridExtra)
library(rgdal)
library(raster)



## load configuration
source('config.R')

## get the current component to analyze
#load('this.component.Rda')
comp <- 'bellecanyon'
taxon <- '.'

# save as global options
options(p.low.rv.high=p.low.rv.high, q.type=q.type, ml.profile.smoothing=ml.profile.smoothing)

# map unit data and rasters are all in the same coordinate system
# however, the representation isn't exactly the same
# copy one from the other
#proj4string(mu) <- CRS('')
#proj4string(mu) <- projection(r[['gis_elev']])

## load all pedons from the selected set, do not apply horizonation check / removal
f <- fetchNASIS(rmHzErrors=FALSE, nullFragsAreZero=TRUE)
# f2 <- as(f,"SpatialPointsDataFrame")
# f2 <- spTransform(f2,CRS(proj4string(mu)))
# f2$MUSYM <- over(f2,mu)$MUSYM
# f$MUSYM <- f2$MUSYM


#data transforms and extractions
good.idx <- which(!is.na(f$x_std))  # may be too restrictive, assumes std lat long are populated in NASIS
f <- f[good.idx, ]            # keep only pedons with non-NA std coordinates 

# init coordinates
coordinates(f) <- ~ x_std + y_std
proj4string(f) <- '+proj=longlat +datum=NAD83'

# transform from GCS to CRS of map unit linework
f@sp <- spTransform(f@sp, CRS(proj4string(mu)))

## overlay with map unit polys, and clean-up
f$musym <- as.character(over(f@sp, mu)$MUSYM)
# if missing a map unit smbol, generate a fake place-holder
f$musym[which(is.na(f$musym))] <- 'NOSYM'
## generate index to subset using pedon IDs listed in report-rules.R

#export coordinates and overlap to shapefile
#writeOGR(as((f), "SpatialPointsDataFrame"), getwd(), "serp", "ESRI Shapefile")


if(subset.rule == 'pedon.id.list')
  subset.idx <- which(f$pedon_id %in% pedon.id.list[[comp]]$f)

## generate index to subset using regular expression
if(subset.rule == 'pattern')
  subset.idx <- grep(pattern=comp, f$taxonname, ignore.case=TRUE)

if(subset.rule == 'musymtaxon') 
  subset.idx <- (grepl(pattern=comp, f$taxonname, ignore.case=TRUE)  & grepl(pattern=mu.sym, f$musym, ignore.case=TRUE) & grepl(pattern=taxon, f$taxonkind, ignore.case=TRUE))

if(subset.rule == 'musym')
  subset.idx <- grep(pattern=mu.sym, f$musym, ignore.case=TRUE)

# perform subset
f <- f[subset.idx, ]






# visual check
par(mar=c(0,0,3,3))
#new.order <- order(f$taxsubgrp)
new.order <- order(profileApply(f, estimateSoilDepth, p = 'Cr|R|Cd'))
#new.order <- order(profileApply(f, max, v='clay'))
#plot color
plot(f, name='hzname', label= 'pedon_id', id.style='side', cex.depth.axis=1.25, cex.names=0.7, plot.order=new.order, max.depth=150)
abline(h=c(50, 100, 150), lty=2, col='grey')
#plot clay
plot(f, name='hzname', label='pedon_id', id.style='side', color='clay', cex.depth.axis=1.25, cex.names=0.7, plot.order=new.order, max.depth=200)
#plot frags
plot(f, name='hzname', label='taxsubgrp', id.style='side', color='total_frags_pct', cex.depth.axis=1.25, cex.names=0.7, plot.order=new.order, max.depth=150)
#plot pH
plot(f, name='hzname', label='pedon_id', id.style='side', color='phfield', cex.depth.axis=1.25, cex.names=0.7, plot.order=new.order, max.depth=150)

#display horizon occurrences
sort(table(f$hzname), decreasing=TRUE)

#transitions from one horizon to another
tp <- hzTransitionProbabilities(f, 'hzname')
par(mar=c(1,1,1,1))
plotSoilRelationGraph(tp, graph.mode = 'directed', edge.arrow.size=0.5, edge.scaling.factor=2, vertex.label.cex=0.75, vertex.label.family='sans')

# compute horizon mid-points
f$mid <- with(horizons(f), (hzdept + hzdepb) / 2)

# sort horizon designation by group-wise median values
hz.designation.by.median.depths <- names(sort(tapply(f$mid, f$hzname, median)))

# plot the distribution of horizon mid-points by designation
bwplot(mid ~ factor(hzname, levels=hz.designation.by.median.depths), 
       data=horizons(f), 
       ylim=c(155, -5), ylab='Horizon Mid-Point Depth (cm)', 
       scales=list(y=list(tick.number=10)), 
       panel=function(...) {
         panel.abline(h=seq(0, 140, by=10), v=1:length(hz.designation.by.median.depths), col=grey(0.8), lty=3)
         panel.bwplot(...)
       })

# box and wisker plot by clay content
bwplot(clay ~ factor(hzname, levels=hz.designation.by.median.depths), 
       data=horizons(f), 
       ylab='Clay Content (%)', 
       scales=list(y=list(tick.number=10)), 
       panel=function(...) {
         panel.abline(h=seq(0, 100, by=5), v=1:length(hz.designation.by.median.depths), col=grey(0.8), lty=3)
         panel.bwplot(...)
       })

# box and wisker plot by total rock fragment volume
bwplot(total_frags_pct ~ factor(hzname, levels=hz.designation.by.median.depths), 
       data=horizons(f), 
       ylab='Total Rock Fragment Volume (%)', 
       scales=list(y=list(tick.number=10)), 
       panel=function(...) {
         panel.abline(h=seq(0, 100, by=10), v=1:length(hz.designation.by.median.depths), col=grey(0.8), lty=3)
         panel.bwplot(...)
       })


##### generalized horizon labels #####
# save our GHL
n=c('O','A','Bw','C')

# REGEX rules
p=c('O','A','Bw','C')

# cross-tabulate original horizon designations and GHL
f$genhz <- generalize.hz(f$hzname, n, p)
tab <- table(f$genhz, f$hzname)
addmargins(tab)

#network graph of GHL assignments
# convert contingency table -> adj. matrix
m <- genhzTableToAdjMat(tab)
# plot using a function from the sharpshootR package
par(mar=c(1,1,1,1))
plotSoilRelationGraph(m, graph.mode = 'directed', edge.arrow.size=0.5)


##### evaluate GHL labels #####
# make a palette of colors, last color is for not-used class
cols <- c(grey(0.33), 'orange', 'orangered', 'chocolate', 'green', 'blue', 'yellow')
# assign a color to each generalized horizon label
hz.names <- levels(f$genhz)
f$genhz.soil_color <- cols[match(f$genhz, hz.names)]
# plot generalized horizons via color and add a legend
par(mar=c(4,0,0,0))
plot(f, name='hzname', label='pedon_id', id.style='side',  cex.names=0.6, plot.order=new.order, axis.line.offset=-4, color='genhz.soil_color')
legend('bottomleft', legend=hz.names, pt.bg=c(cols), pch=22, bty='n', cex=1)


#horizon thicknesses
thick <- c(f$hzname, f$hzdept, f$hzdepb)
melt(thick)

# slice profile collection from 0-150 cm
s <- slice(f, 0:150 ~ genhz)
# convert horizon name back to factor, using original levels
s$genhz <- factor(s$genhz, levels = hz.names)
# plot depth-ranges of generalized horizon slices
bwplot(hzdept ~ genhz, data=horizons(s), 
       ylim=c(155, -5), ylab='Generalized Horizon Depth (cm)', 
       scales=list(y=list(tick.number=10)), asp=1, 
       panel=function(...) {
         panel.abline(h=seq(0, 140, by=10), v=1:length(hz.names),col=grey(0.8), lty=3)
         panel.bwplot(...)
       }
)


##### multivariate analysis of soil properties #####
# store the column names of our variables of interest
vars <- c('clay', 'mid', 'total_frags_pct')
# result is a list of several items
hz.eval <- evalGenHZ(f, 'genhz', vars)
# extract MDS coords
f$mds.1 <- hz.eval$horizons$mds.1
f$mds.2 <- hz.eval$horizons$mds.2
# extract silhouette widths and neighbor
f$sil.width <- hz.eval$horizons$sil.width
f$neighbor <- hz.eval$horizons$neighbor

# convert pedons to a data.frame
pedons.df <- as(f, 'data.frame')
# plot generalized horizon labels at MDS coordinates
mdsplot <- xyplot(mds.2 ~ mds.1, groups=genhz, data=pedons.df, 
                  xlab='', ylab='', aspect=1,
                  scales=list(draw=FALSE), 
                  auto.key=list(columns=length(levels(pedons.df$genhz))), 
                  par.settings=list(
                    superpose.symbol=list(pch=16, cex=3, alpha=0.5)
                  )
)

# annotate with original hzname and pedon ID
mdsplot +
  layer(panel.abline(h=0, v=0, col='grey', lty=3)) + 
  layer(panel.text(pedons.df$mds.1, pedons.df$mds.2, pedons.df$hzname, cex=0.85, font=2, pos=3)) +
  layer(panel.text(pedons.df$mds.1, pedons.df$mds.2, pedons.df$pedon_id, cex=0.55, font=1, pos=1))

# plot silhouette width metric, 1=good partitioning
par(mar=c(0,0,3,0))
plot(f, name='hzname', label='pedon_id', cex.names=0.75, axis.line.offset=-4, color='sil.width')

# index those horizons with silhouette widths less than 0
check.idx <- which(pedons.df$sil.width < 0)
# sort this index based on min sil.width
check.idx.sorted <- check.idx[order(pedons.df$sil.width[check.idx])]
# list those pedons/horizons that may need some further investigation
pedons.df[check.idx.sorted, c('peiid', 'pedon_id', 'hzname', 'genhz', 'neighbor', 'sil.width', vars)]

#evaluate horizon statistics--mean(std dev)
hz.eval$stats

# add a column containing a color (red) that flags horizons with silhouette width less than 0
f$sil.flag <- ifelse(f$sil.width < 0, 'red', 'white')
par(mar=c(0,0,3,0))
plot(f, name='hzname', label='pedon_id', cex.names=0.75, axis.line.offset=-4, color='sil.flag')


##### save GHL to NASIS #####
# clear-out any existing files
rules.file <- 'C:/data/horizon_agg.txt'
write.table(data.frame(), file=rules.file, row.names=FALSE, quote=FALSE, na='', col.names=FALSE, sep='|')
# extract horizon data
h <- horizons(f)
# strip-out 'not-used' genhz labels and retain horizon ID and genhz assignment
h <- h[which(h$genhz != 'not-used'), c('phiid', 'genhz')]
# append to NASIS import file
write.table(h, file=rules.file, row.names=FALSE, quote=FALSE, na='', col.names=FALSE, sep='|', append=TRUE)


### save list of pedons in csv file
# either by pedon_id or by peiid
write(paste(site(f)$pedon_id, collapse=", "),file="bellecanyon")
#order(site(f)$pedon_id)

### calculate horizon thicknesses for each horizon
#c(f$hzname,f$genhz,f$hzdept,f$hzdepb)
thick <- data.frame(hzname=f$hzname, genhz=f$genhz, top=f$hzdept, bottom=f$hzdepb)
thick <- transform(thick, thickness=(bottom-top))
write.csv(thick, file = "bellecanyon_thick.csv")


