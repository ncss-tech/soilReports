
# save a local copy of a report's configuration file
reportInit <- function(reportName, outputDir=NULL, overwrite=FALSE) {
  
  # output is saved in working dir when not specified
  if(missing(outputDir)) {
    outputDir <- getwd()
  } else {
    # check for existing data
    if(overwrite != TRUE & dir.exists(outputDir))
      stop(paste0('there is already a folder named `', outputDir, '` in the current working directory'), call. = FALSE)
    
    # create the specified output directory
    dir.create(outputDir, recursive = TRUE, )
  }
  
  # get base directory where reports are stored within package
  base.dir <- system.file(paste0('reports/', reportName), package='soilReports')
  
  # all reports use the same setup file
  config.file <- paste0(base.dir, '/', 'config.R')
  report.file <- paste0(base.dir, '/', 'report.Rmd')
  notes.file <- paste0(base.dir, '/', 'NOTES.md')
  
  # attempt to copy config file to the working dir
  config.new.path <- paste0(outputDir, '/', 'config.R')
  report.new.path <- paste0(outputDir, '/', 'report.Rmd')
  #notes.new.path <- paste0(outputDir, '/', 'NOTES.md')
  
  if(file.exists(config.new.path) | file.exists(report.new.path) | file.exists(config.new.path)) {
    stop('existing files present in working directory', call. = FALSE)
  } else {
    file.copy(from=config.file, to=outputDir, overwrite = FALSE)
    file.copy(from=report.file, to=outputDir, overwrite = FALSE)
    #file.copy(from=notes.file, to=outputDir, overwrite = TRUE)
    message(paste0('default `config.R` , `report.Rmd`, and `NOTES.md` copied to ', outputDir))
  }
  
  # source custom.R if it exists
  custom.file <- paste0(base.dir, '/', 'custom.R')

  if(file.exists(custom.file)) {
    source(custom.file)
  }
}
