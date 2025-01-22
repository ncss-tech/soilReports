library(aqp)
library(soilDB)

# make spatial layers from points

# get some pedon data
data("gopheridge")
f <- aqp::union(list(gopheridge))
hzidname(f) <- "phiid"
compname <- 'Gopheridge'

# f <- fetchNASIS() # fetchKSSL, fetchRACA whatever

# make it spatial
f <- f[which(!is.na(f$longstddecimaldegrees)),]
coordinates(f) <- ~ longstddecimaldegrees + latstddecimaldegrees
proj4string(f) <- "+proj=longlat +datum=WGS84"

# get SSURGO mapunit info at each point via SDA
# slow
# sda.intersect <- soilDB::SDA_query_features(as(f, 'SpatialPointsDataFrame'), 'peiid')

sda.info <- fetchSDA(WHERE=sprintf("compname = %s", compname), duplicates = TRUE)
mu.inf <- get_mapunit_from_SDA(WHERE=paste0("mukey IN ",format_SQL_in_statement(sda.info$mukey)))
site(sda.info) <- merge(site(sda.info), 
                        mu.inf, all.x=T,
                        by="mukey", sort=FALSE)
s <- fetchSDA_spatial(unique(sda.info$mukey), chunk.size = 5)

s2 <- sp::spTransform(s, sp::CRS(proj4string(f)))
slot(s2,'data') <- merge(slot(s2,'data'), site(sda.info), all.x=T, sort=FALSE)
plot(s2)
rgdal::writeOGR(s2, ".", layer = sprintf("%s_spatial",compname), 
                overwrite=TRUE, driver="ESRI Shapefile")
f$musym <- sp::over(as(f,'SpatialPointsDataFrame'), s2)

s3 <- s2[which(s2$comppct_r > 65),]
plot(s3)
s3$nationalmusym
