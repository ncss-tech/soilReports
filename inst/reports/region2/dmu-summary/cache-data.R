library(aqp)
library(soilDB)

## setup:
# * load legend by area symbol
# * load related MU (approved / provisional only)
# * load related DMU (rep DMU only)
# * load related component pedons
# * load related site observation

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

## get component text notes
cotx <- get_cotext_from_NASIS_db(fixLineEndings = TRUE) 

# keep just those with hz data
idx <- cotx$coiid %in% site(co)$coiid
cotx <- cotx[idx, ]



## TODO: see Andrew Conlin's latest QA stuff
## component geomorph
geom <- get_component_cogeomorph_data_from_NASIS_db()


## component parent material
pm <- get_component_copm_data_from_NASIS_db()


## comonth

# load comonth
cm <- get_comonth_from_NASIS_db(fill = TRUE)
cm.names <- names(cm)

# combine DMU/component names
cm <- merge(site(co), cm, by='coiid', all.x = TRUE, sort = FALSE)

# subset to required columns
cm <- cm[, c('.label', 'comppct_r', cm.names)]

# TODO: re-level component names based on mean comppct

## save
save(co, cm, p, cp, osds, cotx, geom, pm, file = 'data.rda')


