###TODO: EXTRACT DESCRIPTION FROM XML METADATA OF RASTER?

categorical.defs[['SMR']] <- list(header="Newhall SMR",

                                        description="Soil moisture regime as predicted by Newhall Simulation Model and PRISM data, assuming 200mm AWC.",
                                        usage="Use the graphical summary to identify patterns, then consult the tabular representation for specifics.\n",
                                        decimals=2,
                                        levels = 1:6, 
                                        labels = c('Aridic', 'Xeric', 'Ustic', 'Udic', 'Perudic', 'Underfined'),
                                        colors=c(brewer.pal(5, 'Spectral'), 'grey'),
                                        keep.all.classes=TRUE)

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

categorical.defs[['nass']] <- list(header="NASS Cropland Data Layer (2017)",
                                   description="These values are from the [2017 CDL](https://www.nass.usda.gov/Research_and_Science/Cropland/Release/index.php) (30m) database.",
                                   usage="Use the graphical summary to identify patterns, then consult the tabular representation for specifics.",
                                   decimals=2,
                                   levels = c(0L, 1L, 2L, 3L, 4L, 5L, 6L, 10L, 11L, 12L, 13L, 14L, 21L, 22L, 
                                              23L, 24L, 25L, 26L, 27L, 28L, 29L, 30L, 31L, 32L, 33L, 34L, 35L, 
                                              36L, 37L, 38L, 39L, 41L, 42L, 43L, 44L, 45L, 46L, 47L, 48L, 49L, 
                                              50L, 51L, 52L, 53L, 54L, 55L, 56L, 57L, 58L, 59L, 60L, 61L, 63L, 
                                              64L, 65L, 66L, 67L, 68L, 69L, 70L, 71L, 72L, 74L, 75L, 76L, 77L, 
                                              81L, 82L, 83L, 87L, 88L, 92L, 111L, 112L, 121L, 122L, 123L, 124L, 
                                              131L, 141L, 142L, 143L, 152L, 176L, 190L, 195L, 204L, 205L, 206L, 
                                              207L, 208L, 209L, 210L, 211L, 212L, 213L, 214L, 216L, 217L, 218L, 
                                              219L, 220L, 221L, 222L, 223L, 224L, 225L, 226L, 227L, 229L, 230L, 
                                              231L, 232L, 233L, 234L, 235L, 236L, 237L, 238L, 239L, 240L, 241L, 
                                              242L, 243L, 244L, 245L, 246L, 247L, 248L, 249L, 250L, 254L), 
                                   labels = c("Background", "Corn", "Cotton", "Rice", "Sorghum", "Soybeans", 
                                              "Sunflower", "Peanuts", "Tobacco", "Sweet Corn", "Pop or Orn Corn", 
                                              "Mint", "Barley", "Durum Wheat", "Spring Wheat", "Winter Wheat", 
                                              "Other Small Grains", "Dbl Crop WinWht/Soybeans", "Rye", "Oats", 
                                              "Millet", "Speltz", "Canola", "Flaxseed", "Safflower", "Rape Seed", 
                                              "Mustard", "Alfalfa", "Other Hay/Non Alfalfa", "Camelina", "Buckwheat", 
                                              "Sugarbeets", "Dry Beans", "Potatoes", "Other Crops", "Sugarcane", 
                                              "Sweet Potatoes", "Misc Vegs & Fruits", "Watermelons", "Onions", 
                                              "Cucumbers", "Chick Peas", "Lentils", "Peas", "Tomatoes", "Caneberries", 
                                              "Hops", "Herbs", "Clover/Wildflowers", "Sod/Grass Seed", "Switchgrass", 
                                              "Fallow/Idle Cropland", "Forest", "Shrubland-64", "Barren-65", 
                                              "Cherries", "Peaches", "Apples", "Grapes", "Christmas Trees", 
                                              "Other Tree Crops", "Citrus", "Pecans", "Almonds", "Walnuts", 
                                              "Pears", "Clouds/No Data", "Developed", "Water", "Wetlands", 
                                              "Nonag/Undefined", "Aquaculture", "Open Water", "Perennial Ice/Snow", 
                                              "Developed/Open Space", "Developed/Low Intensity", "Developed/Med Intensity", 
                                              "Developed/High Intensity", "Barren-131", "Deciduous Forest", 
                                              "Evergreen Forest", "Mixed Forest", "Shrubland-152", "Grass/Pasture", 
                                              "Woody Wetlands", "Herbaceous Wetlands", "Pistachios", "Triticale", 
                                              "Carrots", "Asparagus", "Garlic", "Cantaloupes", "Prunes", "Olives", 
                                              "Oranges", "Honeydew Melons", "Broccoli", "Peppers", "Pomegranates", 
                                              "Nectarines", "Greens", "Plums", "Strawberries", "Squash", "Apricots", 
                                              "Vetch", "Dbl Crop WinWht/Corn", "Dbl Crop Oats/Corn", "Lettuce", 
                                              "Pumpkins", "Dbl Crop Lettuce/Durum Wht", "Dbl Crop Lettuce/Cantaloupe", 
                                              "Dbl Crop Lettuce/Cotton", "Dbl Crop Lettuce/Barley", "Dbl Crop Durum Wht/Sorghum", 
                                              "Dbl Crop Barley/Sorghum", "Dbl Crop WinWht/Sorghum", "Dbl Crop Barley/Corn", 
                                              "Dbl Crop WinWht/Cotton", "Dbl Crop Soybeans/Cotton", "Dbl Crop Soybeans/Oats", 
                                              "Dbl Crop Corn/Soybeans", "Blueberries", "Cabbage", "Cauliflower", 
                                              "Celery", "Radishes", "Turnips", "Eggplants", "Gourds", "Cranberries", 
                                              "Dbl Crop Barley/Soybeans"),
                                   colors = c("#000000", "#FFD300", "#FF2626", "#00A8E5", "#FF9E0C", "#267000", 
                                              "#FFFF00", "#70A500", "#00AF4C", "#DDA50C", "#DDA50C", "#7FD3FF", 
                                              "#E2007C", "#896354", "#D8B56B", "#A57000", "#D69EBC", "#707000", 
                                              "#AD007C", "#A05989", "#700049", "#D69EBC", "#D1FF00", "#7F99FF", 
                                              "#D6D600", "#D1FF00", "#00AF4C", "#FFA5E2", "#A5F28C", "#00AF4C", 
                                              "#D69EBC", "#A800E5", "#A50000", "#702600", "#00AF4C", "#B27FFF", 
                                              "#702600", "#FF6666", "#FF6666", "#FFCC66", "#FF6666", "#00AF4C", 
                                              "#00DDAF", "#54FF00", "#F2A377", "#FF6666", "#00AF4C", "#7FD3FF", 
                                              "#E8BFFF", "#AFFFDD", "#00AF4C", "#BFBF77", "#93CC93", "#C6D69E", 
                                              "#CCBFA3", "#FF00FF", "#FF8EAA", "#BA004F", "#704489", "#007777", 
                                              "#B29B70", "#FFFF7F", "#B5705B", "#00A582", "#EAD6AF", "#B29B70", 
                                              "#F2F2F2", "#9B9B9B", "#4C70A3", "#7FB2B2", "#E8FFBF", "#00FFFF", 
                                              "#4C70A3", "#D3E2F9", "#9B9B9B", "#9B9B9B", "#9B9B9B", "#9B9B9B", 
                                              "#CCBFA3", "#93CC93", "#93CC93", "#93CC93", "#C6D69E", "#E8FFBF", 
                                              "#7FB2B2", "#7FB2B2", "#00FF8C", "#D69EBC", "#FF6666", "#FF6666", 
                                              "#FF6666", "#FF6666", "#FF8EAA", "#334933", "#E57026", "#FF6666", 
                                              "#FF6666", "#FF6666", "#B29B70", "#FF8EAA", "#FF6666", "#FF8EAA", 
                                              "#FF6666", "#FF6666", "#FF8EAA", "#00AF4C", "#FFD300", "#FFD300", 
                                              "#FF6666", "#FF6666", "#896354", "#FF6666", "#FF2626", "#E2007C", 
                                              "#FF9E0C", "#FF9E0C", "#A57000", "#FFD300", "#A57000", "#267000", 
                                              "#267000", "#FFD300", "#000099", "#FF6666", "#FF6666", "#FF6666", 
                                              "#FF6666", "#FF6666", "#FF6666", "#FF6666", "#FF6666", "#267000")
                                   )

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
