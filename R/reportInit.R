
# save a local copy of a report's configuration file
reportInit <- function(reportName, outputDir=NULL, overwrite=FALSE, updateReport=FALSE) {
  # output is saved in working dir when not specified
  
  # get base directory where reports are stored within package
  base.dir <- system.file(paste0('reports/', reportName), package='soilReports')
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
      print("Successfully initiated report!")
    } else stop("Failed to instantiate report -- no paths to copy specified in setup.R!")
  } else {
    #TODO: could try and infer which files are "config" and ignore those, requiring only the .paths.to.copy variable
    #      but for now, just require reports to specify what gets updated when updateReport is called
    if(exists('.update.paths.to.copy', envir = env)) {
      pa <- get('.update.paths.to.copy', envir = env)
      lapply(pa, FUN=copyPath, base.dir, outputDir, overwrite=T)
      print("Successfully updated report!")
      #TODO: should there be a check that required components are present? check against ".paths.to.copy"? only look for R/Rmds?
    } else stop("Failed to update report -- no update paths to copy specified in setup.R!")
  }
  
  # Add HTML comment containing report name, version and instance creation date/time above YAML header at top of report.Rmd
  metadat_vars <- c(".report.name",".report.version",".report.description")
  if(exists('.report.name', envir=env) & exists('.report.version', envir=env) & exists('.report.description', envir=env)) {
    rname <- get('.report.name', env)
    rvers <- get('.report.version', env)
    rdesc <- get('.report.description', env)
    headtxt <- paste0("<!-- ",  rname," (v", rvers, ") -- instance created ", Sys.time(), "-->  \n")
    report.file <- paste0(outputDir,'/report.Rmd')
    
    defineInCodeChunk(report.file,metadat_vars,c(paste0("\'",rname,"\'"),paste0("\'",rvers,"\'"),paste0("\'",rdesc,"\'")))
    appendBelowYAML(report.file, headtxt)
    
    if(exists('.has.shiny.interface')) { #put note at top of shiny file if one is defined.
      shiny.file <- paste0(outputDir,'/shiny.Rmd')
      defineInCodeChunk(shiny.file,metadat_vars,c(paste0("\'",rname,"\'"),paste0("\'",rvers,"\'"),paste0("\'",rdesc,"\'")))
      appendBelowYAML(shiny.file, headtxt)
    }
  }
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

appendBelowYAML <- function(filepath, what) {
  if(file.exists(filepath)) {
    fcon <- file(filepath, 'r+')
    l <- readLines(fcon)
    yaml_block <- grepl(l,pattern="^---$")
    idx = 1
    if(any(yaml_block)) idx <- max(which(yaml_block))
    l <- c(l[1:idx],what,l[idx+1:length(l)]) #add below YAML but above everything else
    l <- l[-is.na(l)]
    writeLines(l,fcon)
    close(fcon)
    return(TRUE)
  } else return(FALSE)
}

defineInCodeChunk <- function(filepath, param.name, param.value) {
  #NOTE: param values will be directly injected; need to include e.g. escaped quotes for strings
  buf = c("```{r, echo=FALSE, results='hide', warning=FALSE, message=FALSE}")
  for(p in 1:length(param.name)) buf=c(buf, paste0("\t",param.name[p], " <- ",param.value[p]))
  buf = c(buf, "```")
  return(appendBelowYAML(filepath,buf))
}

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
    l <- l[-is.na(l)]
    writeLines(l,fcon)
    close(fcon)
    return(TRUE)
  } else return(FALSE)
}

reportUpdate <- function(reportName, outputDir=NULL) {
  #Uses report init, only with overwrite and updateReport default value override
  reportInit(reportName, outputDir, overwrite = T, updateReport = T)
}

# renaming reportInit(), more intuitive
copyReport <- function(reportName, outputDir=NULL, overwrite=FALSE) {
  reportInit(reportName, outputDir, overwrite)
}