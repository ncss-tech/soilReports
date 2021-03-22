
# extract the version number from a single report
.getReportMetaData <- function(x) {
  env <- new.env()
  setup_path <- paste0(dirname(x),"/setup.R")
  
  try(sys.source(setup_path, env), silent = TRUE)
  
  # combine and return
  if (exists('.report.name', env) &
      exists('.report.version', env) &
      exists('.report.description', env)) {
    res <- data.frame(
      name = get('.report.name', env),
      version = get('.report.version', env),
      description = get('.report.description', env),
      stringsAsFactors = FALSE
    )
  } else {
    res <- data.frame(
      name = NA,
      version = NA,
      description = "[Report NOT ready to install]",
      stringsAsFactors = FALSE
      
    )
  }
  return(res)
}

# list available reports
listReports <- function(showFullPaths=FALSE) {
  
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
  #for now remove the name metadata since we derive the report "name" from the report.set / folder name, but in future might use metadata name
  report.metadata <- report.metadata[,-which(names(report.metadata) == 'name')]
  # combine and return
  res <- data.frame(name=report.set, report.metadata, stringsAsFactors = FALSE)
  if(showFullPaths)
    res <- cbind(res, full.paths) #may want to know which version of report you're installing from... e.g. dev or stable??
  return(res)
}

