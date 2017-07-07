## quick script for "caching" component-level data before making edits in nasis

componentz <- get_component_data_from_NASIS_db()
save(file="nasis_components_20170321.Rda",componentz)

#show only 607x's
componentz[grepl("607.",componentz$dmudesc),]

# plant list test

plantz <- get_component_esd_data_from_NASIS_db()
merge(componentz,plantz,by=intersect(componentz$coiid, plantz$coiid))


length(which(componentz$coiid %in% intersect(componentz$coiid, plantz$coiid)))
length(which(plantz$coiid %in% intersect(componentz$coiid, plantz$coiid)))

df <- merge(componentz,plantz,by="coiid")

df[grepl("607(1|4|5|6)",df$dmudesc),]

sierra <- fetchKSSL(series="Sierra")
sierra
groupedProfilePlot(sierra,name="hzn_desgn",groups = "mlra",color="clay")
