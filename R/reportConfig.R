
# save a local copy of a report's configuration file
reportConfig <- function(reportName) {
  
  # get base directory where reports are stored within package
  base.dir <- system.file(paste0('reports/', reportName), package='soilReports')
  
  # all reports use the same setup file
  config.file <- paste0(base.dir, '/', 'config.R')
  
  # attempt to copy config file to the working dir
  new.path <- paste0(getwd(), '/', 'config.R')
  if(file.exists(new.path)) {
    stop('`config.R` present in working directory', call. = FALSE)
  } else {
    file.copy(from=config.file, to=getwd(), overwrite = FALSE)
    message('default `config.R` copied to working directory')
  }
    
}
