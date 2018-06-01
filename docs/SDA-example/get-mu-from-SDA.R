library(soilDB)
library(rgeos)
library(sp)
library(rgdal)


# get polygons associated with map units that contain "amador" as a major component
q <- "select G.MupolygonWktWgs84 as geom, mapunit.mukey, muname
FROM mapunit
CROSS APPLY SDA_Get_MupolygonWktWgs84_from_Mukey(mapunit.mukey) as G
WHERE mukey IN (SELECT DISTINCT mukey FROM component WHERE compname like 'amador%' AND majcompflag = 'Yes')"

# get polygons associated with specific mukey
q <- "select G.MupolygonWktWgs84 as geom, mapunit.mukey, muname
FROM mapunit
CROSS APPLY SDA_Get_MupolygonWktWgs84_from_Mukey(mapunit.mukey) as G
WHERE mukey IN ('458818', '461942', '462112', '463133')"


# result is a data.frame, "MupolygonWktWgs84" contains WKT representation of geometry
res <- SDA_query(q)

# convert to SpatialPolygonsDataFrame
s <- processSDA_WKT(res)

# transform to projected CRS
s <- spTransform(s, CRS('+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +towgs84=0,0,0,-0,-0,-0,0 +units=m +no_defs'))

# save in current folder as SHP
writeOGR(s, dsn='.', layer='redding', driver='ESRI Shapefile')
