library(aqp)
library(soilDB)

## setup:
# load CA792 legend into SS
# load all child tables: MU -> DMU -> component pedon -> site obs / site

source('custom.R')

## get component data, only those with horizon data

# from the selected set
co <- fetchNASIS(from = 'components', rmHzErrors = FALSE)

# init convenience labels
# add newline + localphase if present
site(co)$.label <- ifelse(
  is.na(co$localphase), 
  sprintf("%s (%s%%)", co$compname, co$comppct_r),
  sprintf("%s (%s%%)\n%s", co$compname, co$comppct_r, co$localphase)
)


## MU / correlation table
mu <- get_component_correlation_data_from_NASIS_db(dropAdditional = TRUE, dropNotRepresentative = TRUE)

# splice in relevant details
site(co) <- mu[, c('dmuiid', 'musym', 'muiid', 'lmapunitiid', 'muname', 'mukind', 'mustatus')]


## get pedon data and component pedon linkages

# from selected set
p <- fetchNASIS(from = 'pedons', rmHzErrors = FALSE)


## TODO: QC messages?


# this cannot be safely joined to site(p): some pedons linked to multiple components
cp <- get_copedon_from_NASIS_db()


## get OSDs, if available
osds <- fetchOSD(unique(co$compname), extended = TRUE)

# make an empty OSD placeholder
osd.filler <- emtpySPC(osds$SPC[1, ], top = 0, bottom = max(co))


## get component text notes
cotx <- get_cotext_from_NASIS_db(fixLineEndings = TRUE) 

# keep just those with hz data
idx <- cotx$coiid %in% site(co)$coiid
cotx <- cotx[idx, ]

# split out relevant pieces
rep.pedon.txt <- cotx[cotx$textcat == 'rep pedon', ]$textentry


## TODO: see Andrew Conlin's latest QA stuff
## component geomorph
geom <- get_component_cogeomorph_data_from_NASIS_db()


## component parent material
pm <- get_component_copm_data_from_NASIS_db()


## save
save(co, p, cp, osds, osd.filler, cotx, geom, pm, file = 'data.rda')


