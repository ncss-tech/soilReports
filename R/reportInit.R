
# save a local copy of a report's configuration file
reportInit <- function(reportName, outputDir=NULL, overwrite=FALSE, updateReport=FALSE) {
  # output is saved in working dir when not specified
  
  # get base directory where reports are stored within package
  base.dir <- system.file(paste0('reports/', reportName), package='soilReports')
  print(base.dir)
  # all reports must have setup.R file
  setup.file <- paste0(base.dir, '/', 'setup.R')
  
  # source file into temp environment
  env <- new.env()
  sys.source(setup.file, envir = env)
  
  if(!updateReport) {
    if(missing(outputDir)) {
      outputDir <- getwd()
    } else {
      # check for existing data
      if(overwrite != TRUE & dir.exists(outputDir)) 
        stop(paste0('there is already a folder named `', outputDir, '` in the current working directory'), call. = FALSE)
      # create the specified output directory
      dir.create(outputDir, recursive = TRUE)
    }
    
    if(exists('.paths.to.copy', envir = env)) { #copy everything if not in "update" mode
      pa <- get('.paths.to.copy', envir = env)
      lapply(pa, FUN=copyPath, base.dir, outputDir)
    } else stop("Failed to instantiate report -- no paths to copy specified in setup.R!")
  } else {
    #TODO: could try and infer which files are "config" and ignore those, requiring only the .paths.to.copy variable
    #      but for now, just require reports to specify what gets updated when updateReport is called
    if(exists('.update.paths.to.copy', envir = env)) {
      pa <- get('.update.paths.to.copy', envir = env)
      lapply(pa, FUN=copyPath, base.dir, outputDir, overwrite=T)
      #TODO: should there be a check that required components are present? check against ".paths.to.copy"? only look for R/Rmds?
    } else stop("Failed to update report -- no update paths to copy specified in setup.R!")
  }
  
  # Add HTML comment containing report name, version and instance creation date/time above YAML header at top of report.Rmd
  if(exists('.report.name', envir=env) & exists('.report.version', envir=env) & exists('.report.description', envir=env)) {
    headtxt <- paste0("<!-- ", get('.report.name', env), " (v", get('.report.version', env), ") -- instance created ",Sys.time(), "-->  \n")
    report.file <- paste0(outputDir,'/report.Rmd')
    appendToTopOfFile(report.file, headtxt)
    
    if(exists('.has.shiny.interface')) { #put note at top of shiny file if one is defined.
      shiny.file <- paste0(outputDir,'/shiny.Rmd')
      appendToTopOfFile(shiny.file, headtxt)
    }
  }
}

appendToTopOfFile <- function(filepath, what) {
  if(file.exists(filepath)) {
    fcon <- file(filepath, 'r+') 
    linez <- c(what,readLines(fcon))
    writeLines(linez, con = fcon) 
    close(fcon)
    return(TRUE)
  } else return(FALSE)
}

copyPath <- function(fname, srcDir, outputDir, overwrite = F) {
  src <- paste0(srcDir, '/', fname)
  dst <- paste0(outputDir, '/', fname)
  if(!dir.exists(src)) { #files will return false 
    if(file.exists(src)) {#but need to make sure it actually is a file
      #OK we have a path to a file
      if(overwrite | !file.exists(dst)) #but need to make sure that we can overwrite... or that it is not already extant
         file.copy(from=src, to=outputDir, overwrite = overwrite)
    } else {
      #we have a path to a directory
      if(!dir.exists(dst)) {
        #create directory structure recursively
        dir.create(dst, recursive = T)
      }
      if(dir.exists(outputDir)) {
        #copy files recursively
        file.copy(src, outputDir, recursive = T, overwrite = overwrite)
      }
    }
  }
}

reportUpdate <- function(reportName, outputDir=NULL) {
  #Uses report init, only with overwrite and updateReport default value override
  reportInit(reportName, outputDir, overwrite = T, updateReport = T)
}

# renaming reportInit(), more intuitive
copyReport <- function(reportName, outputDir=NULL, overwrite=FALSE) {
  reportInit(reportName, outputDir, overwrite)
}