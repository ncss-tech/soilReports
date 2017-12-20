###TODO: EXTRACT DESCRIPTION FROM XML METADATA OF RASTER?

categorical.defs[['curvature']] <- list(header="Slope Shape (Curvature) Summary",
                                        # set names: from Field Guide for description of soils
                                        ## source data: opposite convention
                                        # 1's place: profile curvature
                                        # 10's place: plan curvature
                                        #
                                        ## adapted from above
                                        ## data are reported down/across slope
                                        # L/L | L/V | L/C         22 | 32 | 12  
                                        # V/L | V/V | V/C   ----> 23 | 33 | 13
                                        # C/L | C/V | C/C         21 | 31 | 11
                                        #
                                        # order according to approximate "shedding" -> "accumulating" gradient:
                                        # 'V/V', 'L/V', 'V/L', 'C/V', 'LL', 'C/L', 'V/C', 'L/C', 'C/C'
                                        description="Curvature classes were generated using a 5x5 moving window and a regional 30m or 10m integer DEM. The precision may be limited, so use with caution. See instructions for using your own (higher resolution) curvature classification raster. The conventions used here are \"C\" = concave, \"L\" = linear, and \"V\" = convex; \"down slope\" / \"across slope\". Window size has a significant impact on reported curvature classes; larger windows = more generalization. Curvature class and colors are aligned with an idealized *shedding* &rarr; *accumulating* hydrologic gradient.",
                                        usage="Use the graphical summary to identify patterns, then consult the tabular representation for specifics.\n* ",
                                        decimals=2,
                                        levels = c(33, 32, 23, 31, 22, 21, 13, 12, 11), 
                                        labels = c('VV', 'LV', 'VL', 'CV', 'LL', 'CL', 'VC', 'LC', 'CC'),
                                        colors=brewer.pal(9, 'Spectral'),
                                        keep.all.classes=TRUE)

categorical.defs[['geomorphon']] <- list(header="Geomorphon Landform Classification",
                                         description="Proportion of samples within each map unit that correspond to 1 of 10 possible landform positions, as generated via [geomorphon](https://grass.osgeo.org/grass70/manuals/addons/r.geomorphon.html) algorithm. Landform classification by [this method](http://dx.doi.org/10.1016/j.geomorph.2012.11.005) is scale-invariant and is therefore not affected by computational window size selection. Landform class labels and colors are aligned with an idealized *shedding* &rarr; *accumulating* hydrologic gradient. \"Flat\" is based on a 3% slope threshold.Map units are organized (in the figure) according to the similarity, computed from proportions of each landform position. The [dendrogram](http://ncss-tech.github.io/stats_for_soil_survey/chapter_5.html) on the right side of the figure describes relative similarity. \"Lower branch height\" (e.g. closer to the right-hand side of the figure) denotes more similar landform positions.",
                                         usage="Use the graphical summary to identify patterns, then consult the tabular representation for specifics.",
                                         decimals=2,
                                         levels=1:10, 
                                         labels = c('flat', 'summit', 'ridge', 'shoulder', 'spur', 'slope', 'hollow', 'footslope', 'valley', 'depression'),
                                         colors=c('grey', brewer.pal(9, 'Spectral')),
                                         keep.all.classes=TRUE)

categorical.defs[['nlcd']] <- list(header="National Land Cover Dataset (NLCD)",
                                   description="These values are from the [2011 NLCD](https://www.mrlc.gov/nlcd2011.php) (30m) database.",
                                   usage="Use the graphical summary to identify patterns, then consult the tabular representation for specifics.",
                                   decimals=2,
                                   levels = c(0L, 11L, 12L, 21L, 22L, 23L, 24L, 31L, 41L, 42L, 43L, 51L, 52L, 71L, 72L, 73L, 74L, 81L, 82L, 90L, 95L), 
                                   labels = c("nodata", "Open Water", "Perennial Ice/Snow", "Developed, Open Space", 
                                              "Developed, Low Intensity", "Developed, Medium Intensity", "Developed, High Intensity", 
                                              "Barren Land (Rock/Sand/Clay)", "Deciduous Forest", "Evergreen Forest", 
                                              "Mixed Forest", "Dwarf Scrub", "Shrub/Scrub", "Grassland/Herbaceous", 
                                              "Sedge/Herbaceous", "Lichens", "Moss", "Pasture/Hay", "Cultivated Crops", 
                                              "Woody Wetlands", "Emergent Herbaceous Wetlands"),
                                   colors = c("#000000",  "#476BA0", "#D1DDF9", "#DDC9C9", "#D89382", "#ED0000", "#AA0000", 
                                              "#B2ADA3", "#68AA63", "#1C6330", "#B5C98E", "#A58C30", "#CCBA7C", 
                                              "#E2E2C1", "#C9C977", "#99C147", "#77AD93", "#DBD83D", "#AA7028", 
                                              "#BAD8EA", "#70A3BA"))

categorical.defs[['mesic thermic']] <- list(header="Soil Temperature Regime Uncertainty (Mesic/Thermic)",
                                   description="Areas with an uncertain soil temperature regime occur where the confidence interval for modeled mean annual soil temperature overlaps mesic/thermic break of 15&deg; C.",
                                   usage="Use this layer to identify the map units occuring where soil temperature regime cannot be definitively assigned.",
                                   decimals=2,
                                   levels = c(1,0), 
                                   labels = c("uncertain","certain"),
                                   colors = brewer.pal(3, 'Spectral')[1:2])

categorical.defs[['R105']] <- list(header="R105/106-ness Index",
                                            description="This layer aggregates slope, curvature and aspect data to determine how many of the required abiotic factor criteria are met for the fire-dominated chaparral ecological sites (18XIR105 and 18XIR106). These two ecological sites differ in climatic characteristics (R105 is mesic to borderline thermic) but both require slopes >30%, convex curvature and south-facing aspect.",
                                            usage="The numeric values in class names correspond to the number of abiotic factor criteria met (out of a total of 3). At least two of the criteria need to be met in order to support the R105/106 ecosite assignment, which is also based on the soil properties (typically shallower, fraggy/rocky or both) and existing vegetation (chaparral).  The proportions in the bar chart show the relative abundance of samples meeting that number of criteria (ranging from 0 to all 3) for each mapunit. ",
                                            decimals=2,
                                            levels = c(0,1,2,3), 
                                            labels = c("0","1","2","3"),
                                            colors = brewer.pal(4, 'Spectral'))

### TEMPLATE
# categorical.defs[['%%%PATTERN%%%']] <- list(header="%%%HEADER%%%",
#                                    description="%%%DESCRIPTION%%%",  
#                                    usage="%%%USAGE%%%",
#                                    levels = %%%LEVELS%%%, 
#                                    labels = %%%LABELS%%%,
#                                    colors = %%%COLORS%%%,
#                                    decimals = %%%DECIMALS%%%)
## replace %%%PATTERN%%% with a regular expression that uniquely matches the categorical raster dataset name from the config file
## replace %%%HEADER%%% with the text to be used as header for plot and table in this dataset. will be a 3rd level header (preceded by ###) in markdown
## replace %%%DESCRIPTION%%% with a text description of the dataset, method used to obtain, label meanings, assumptions, supplemental info/links etc.
## replace %%%USAGE%%% brief text description of how to interpret/compare the output
## replace %%%DECIMALS%%% with the number of decimals you would like to truncate table proportions to (default = 2)

##The following three definitions are specified as vectors and are intended to be 1:1 with one another or length 1
## replace %%%LEVELS%%% numeric vector corresponding to the unique values from raster (e.g. from unique(dat$values))
## replace %%%LABELS%%% character vector describing the numeric value. order matches the numeric values of LEVELS.
## replace %%%COLORS%%% character vector hexadecimal or other suitable color specification (e.g. integers, color.brewer()), same order as above

### OPTIONAL
## NOTE: to add an optional element be sure to add a comma to the categorical metadata definition list
###
## keep.all.classes=TRUE 
##
#### keep.all.classes will prevent the removal of un-used classes from the legend and tabular output
