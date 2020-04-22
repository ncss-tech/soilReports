#load packages
library(shiny)
library(DT)
library(ggplot2)
library(sharpshootR)
library(stringi)
library(sp)
library(raster)
library(rgeos)
library(httr)
library(RgoogleMaps)
library(leaflet)
library(leaflet.extras)
library(jpeg)
library(mapview)
library(leafsync)
library(leafem)
library(curl)
library(elevatr)
library(cluster)
library(rgdal)
library(plotKML)

# set local system path for output csv file
path <- 'C:\\PLSS_test\\'

# defaults for startup
input <- list()
input$m <- "MT20"
# input$s <- "07"
# input$t <- "14N"
# input$r <- "11W"

#TODO: other settings??



