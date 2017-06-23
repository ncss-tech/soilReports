
# extract the version number from a single report
.getReportMetaData <- function(x) {
  env <- new.env()
  sys.source(x,env)
  # combine and return
  if(exists('.report.name',env) & exists('.report.version',env) & exists('.report.description',env))
  res <- data.frame(name=get('.report.version',env), version=get('.report.version',env), description=get('.report.description',env), stringsAsFactors = FALSE)
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
  res <- data.frame(name=report.set, report.metadata, file.path = full.paths, stringsAsFactors = FALSE)
  
  return(res)
}

