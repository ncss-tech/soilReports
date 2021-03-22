
# save a local copy of a report's configuration file
#' Copy default configuration file and report contents to new directory
#' 
#' `reportInit` allows creation new report instances, or updates, from the soilReports R package. soilReports is a container for reports and convenience functions for soil data summary, comparison, and evaluation reports used mainly by USDA-NRCS staff.
#' 
#' @param reportName Name of report, as found in `listReports.` Format: `directory/reportName`.
#' @param outputDir Directory to create report instance
#' @param overwrite Overwrite existing directories and files? Default FALSE
#' @param updateReport Only update core report files, leaving configuration unchanged? Specific settings are report-dependent and set in the setup.R manifest.
#'
#' @return A time-stamped report instance created in outputDir, and a message summarizing the action(s) completed.
#' @export
#' @aliases copyReport reportUpdate
#'
reportInit <- function(reportName,
                       outputDir = NULL,
                       overwrite = FALSE,
                       updateReport = FALSE) {
    
  # output is saved in working dir when not specified
  
  if(is.null(reportName) | is.na(reportName) | reportName == "")
    stop('argument "reportName" is missing, with no default', call.=FALSE)
  
  # get base directory where reports are stored within package
  base.dir <- system.file(paste0('reports/', reportName), package='soilReports')
  
  # all reports must have setup.R file
  setup.file <- paste0(base.dir, '/setup.R')
  
  # source file into temp environment
  env <- new.env()
  sys.source(setup.file, envir = env)
  
  if(missing(outputDir)) {
    outputDir <- getwd()
  } else {
    # check for existing data
    if(overwrite != TRUE & dir.exists(outputDir)) 
      stop(paste0('there is already a folder named `', outputDir, '` in the current working directory'), call. = FALSE)
    # create the specified output directory, but only in "init" mode
    if(!updateReport)
      dir.create(outputDir, recursive = TRUE)
  }  
  
  if(!updateReport) {
    if(exists('.paths.to.copy', envir = env)) { # copy everything if not in "update" mode
      pa <- get('.paths.to.copy', envir = env)
      lapply(pa, FUN=copyPath, base.dir, outputDir)
    } else stop("Failed to instantiate report -- no paths to copy specified in setup.R!")
  } else {
    if(exists('.update.paths.to.copy', envir = env)) {
      pa <- get('.update.paths.to.copy', envir = env)
      lapply(pa, FUN=copyPath, base.dir, outputDir, overwrite=TRUE)
    } else stop("Failed to update report -- no update paths to copy specified in setup.R!")
  }
  
  # Add HTML comment containing report name, version and instance creation date/time above YAML header at top of report.Rmd
  metadat_vars <- c(".report.name",".report.version",".report.description")
  if(exists('.report.name', envir=env) & 
     exists('.report.version', envir=env) & 
     exists('.report.description', envir=env)) {
    
    rname <- get('.report.name', env)
    rvers <- get('.report.version', env)
    rdesc <- get('.report.description', env)
    
    headtxt <- paste0("<!-- ",  rname," (v", rvers, ") -- instance created ", 
                      Sys.time(), "-->  \n")
    
    report.file <- paste0(outputDir,'/report.Rmd')
    shiny.file <- paste0(outputDir,'/shiny.Rmd')
    
    print(paste0(rname," (v", rvers, ") report instance created in ",
                 outputDir,". [updateReport=", updateReport,"; overwrite=",overwrite,"]"))
    
    defineInCodeChunk(report.file, metadat_vars, c(paste0("\'",rname,"\'"),
                                                  paste0("\'",rvers,"\'"),
                                                  paste0("\'",rdesc,"\'")))
    appendBelowYAML(report.file, headtxt)
    
    if(exists('.has.shiny.interface')) { #put note at top of shiny.Rmd file if one is defined.
      
      defineInCodeChunk(shiny.file, metadat_vars, c(paste0("\'",rname,"\'"),
                                                  paste0("\'",rvers,"\'"),
                                                  paste0("\'",rdesc,"\'")))
      appendBelowYAML(shiny.file, headtxt)
    }
  }
}

reportUpdate <- function(reportName, outputDir=NULL) {
  # Uses report init, only with overwrite and updateReport default value override
  if(dir.exists(outputDir))
    reportInit(reportName, outputDir, overwrite = TRUE, updateReport = TRUE)
  else {
    message(sprintf("%s does not exist -- creating new report instance", reportName))
    reportInit(reportName, outputDir, overwrite = TRUE, updateReport = FALSE)
  }
  
}

copyReport <- function(reportName, outputDir=NULL, overwrite=FALSE) {
  reportInit(reportName, outputDir, overwrite)
}

#' Copy a file from source to output directory
#'
#' @param fname file name
#' @param srcDir source directory
#' @param outputDir output directory
#' @param overwrite overwrite? default: \code{FALSE}
#'
#' @return logical; result of \code{file.copy}
#' @export
#'
copyPath <- function(fname, srcDir, outputDir, overwrite = FALSE) { 
  src <- paste0(srcDir, '/', fname)
  dst <- paste0(outputDir, '/', fname)
  
  #files will return false 
  if(!dir.exists(src)) { 
    #but need to make sure it actually is a file
    if(file.exists(src)) {
      #OK we have a path to a file
      #but need to make sure that we can overwrite... or that it is not already extant
      if(overwrite | !file.exists(dst)) 
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

#' Add lines below the YAML header
#'
#' @param filepath file path
#' @param what character vector ines to add
#'
#' @return logical; \code{TRUE} if successful
#' @export
#'
appendBelowYAML <- function(filepath, what) {
  if(file.exists(filepath)) {
    fcon <- file(filepath, 'r+')
    l <- readLines(fcon)
    yaml_block <- grepl(l,pattern="^---$")
    idx = 1
    if(any(yaml_block)) 
      idx <- max(which(yaml_block))
    l <- c(l[1:idx],what,l[idx+1:length(l)]) #add below YAML but above everything else
    l <- l[!is.na(l)]
    writeLines(l,fcon)
    close(fcon)
    return(TRUE)
  } else return(FALSE)
}

#' Define a parameter in a code chunk
#'
#' @param filepath File to add code chunk to
#' @param param.name Parameter name
#' @param param.value Parameter value
#'
#' @return logical; \code{TRUE} if successful
#' @export
defineInCodeChunk <- function(filepath, param.name, param.value) {
  #NOTE: param values will be directly injected; need to include e.g. escaped quotes for strings
  buf = c("```{r, echo=FALSE, results='hide', warning=FALSE, message=FALSE}")
  for(p in 1:length(param.name)) buf=c(buf, paste0("\t",param.name[p], " <- ",param.value[p]))
  buf = c(buf, "```")
  return(appendBelowYAML(filepath,buf))
}

#' Define a parameter in the YAML header
#'
#' @param filepath File to add code chunk to
#' @param param.name Parameter name
#' @param param.value Parameter value
#'
#' @return logical; \code{TRUE} if successful
#' @export
defineInYAMLHeader <- function(filepath, param.name, param.value) {
  #NOTE: should be able to parse params that are primities correctly; use !r expr to use R expressions wihtin yaml
  if(file.exists(filepath)) {
    buf=c("params:")
    for(p in 1:length(param.name)) buf=c(buf, paste0("\t",param.name[p], ": ",param.value[p]))
    fcon <- file(filepath, 'r+')
    l <- readLines(fcon)
    yaml_block <- grepl(l,pattern="^---$")
    idx = 2
    if(any(yaml_block)) idx <- max(which(yaml_block))
    params_block <- grepl(l,pattern="params:")
    if(any(params_block)) {
      idx <- max(which(params_block))
      l <- c(l[1:idx],buf,l[idx+1:length(l)])#add inside yaml, after params: if exists
    } else l <- c(l[1:(idx-1)],buf,l[idx:length(l)]) #add inside yaml, at end of yaml block
    l <- l[!is.na(l)]
    writeLines(l,fcon)
    close(fcon)
    return(TRUE)
  } else return(FALSE)
}
