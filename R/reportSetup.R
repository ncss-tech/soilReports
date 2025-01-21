

# helper fuction for installing required packages from CRAN
# a simple check is done to see if each is already installed
# p: vector of package names
# up: logical- upgrade installed packages?
.ipkCRAN <- function(p, up){
  if(up) {
    install.packages(p, dependencies = TRUE)
  } else {
    new.pkg <- p[! (p %in% installed.packages()[, "Package"])]
    if (length(new.pkg) > 0) {
      message('installing packages from CRAN...')
      install.packages(new.pkg, dependencies = TRUE)
    }
  }
}

# helper function for installing required packages from GH
# no way to check and see if they are already installed
.ipkGH <- function(p){
  message('installing packages from GitHub...')
  # this function is vectorized
  remotes::install_github(p, dependencies=FALSE, upgrade=FALSE, build=FALSE)
}

#' Install packages needed for a report
#'
#' @param reportName Name of report, as found in `listReports.` Format: `directory/reportName`.
#' @param upgrade Upgrade CRAN packages? Default: `TRUE`
#'
#' @return Installed packages from CRAN and GitHub in user library, as specified in report-specific manifest.
#' 
#' @export
#'
reportSetup <- function(reportName, upgrade = TRUE) {
  
  reportName <- .convert_region(reportName)
  
  # get base directory where reports are stored within package
  base.dir <- system.file(paste0('reports/', reportName), package = 'soilReports')
  
  if (dir.exists(base.dir)) {
    # all reports must have setup.R file
    setup.file <- paste0(base.dir, '/setup.R')
    
    if (file.exists(setup.file)) {
      # source file into temp environment
      env <- new.env()
      sys.source(setup.file, envir = env)
      
      # install any missing packages from CRAN
      if (exists('.packages.to.get', envir = env)) {
        p <- get('.packages.to.get', envir = env)
        .ipkCRAN(p, up = upgrade)
      } else
        message("no CRAN packages listed as dependencies")
      
      # install any missing packages from GH
      if (exists('.gh.packages.to.get', envir = env)) {
        p <- get('.gh.packages.to.get', envir = env)
        .ipkGH(p)
      } else
        message("no GitHub packages listed as dependencies")
      
      # perform any manual fixes specified in the setup.R
      # this is a list, each item is a command
      if (exists('.fixes', envir = env)) {
        message('applying manual fixes...')
        f <- get('.fixes', envir = env)
        sapply(f, function(i)
          eval(parse(text = i)))
      }
      
      # let user know that we are ready to go
      message('required packages are installed!')
    } else
      stop(sprintf("setup.R does not exist in %s", base.dir), call. = FALSE)
  } else
    stop(sprintf("report %s does not exist", base.dir), call. = FALSE)
}
