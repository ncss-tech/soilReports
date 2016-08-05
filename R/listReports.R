
# extract the version number from a single report
.getReportMetaData <- function(x) {
  # scan through .Rmd file
  f <- readLines(x)
  
  # locate the version string
  idx <- grep('.report.version <- ', f)
  v <- as.character(eval(parse(text=f[idx])))
  if(length(v) < 1)
    v <- NA
  
  # locate the description string
  idx <- grep('.report.description <- ', f)
  d <- as.character(eval(parse(text=f[idx])))
  if(length(d) < 1)
    d <- NA
  
  # combine and return
  res <- data.frame(version=v, description=d, stringsAsFactors = FALSE)
  return(res)
}

# list available reports
listReports <- function() {
  
  # get base directory where reports are stored within package
  base.dir <- system.file('reports/', package='soilReports')
  
  # all reports have the same name 
  rmd.files <- list.files(base.dir, recursive = TRUE, pattern='report.Rmd')
  
  # strip filenames, reports are invoked via directory paths
  report.set <- gsub('report.Rmd', '', rmd.files)
  
  # strip trailing '/' simpler to describe reports via directory
  report.set <- gsub('\\/$', '', report.set)
  
  # get report metadata
  full.paths <- paste0(base.dir, '/', rmd.files)
  report.metadata <- lapply(full.paths, .getReportMetaData)
  report.metadata <- do.call('rbind', report.metadata)
  
  # combine and return
  res <- data.frame(name=report.set, report.metadata, stringsAsFactors = FALSE)
  
  return(res)
}

