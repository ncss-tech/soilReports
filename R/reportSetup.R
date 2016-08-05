
# helper fuction for installing required packages from CRAN
# a simple check is done to see if each is already installed
.ipkCRAN <- function(p){
  new.pkg <- p[! (p %in% installed.packages()[, "Package"])]
  if (length(new.pkg) > 0) {
    message('installing packages from CRAN...')
    install.packages(new.pkg, dependencies = TRUE)
  }
}

# helper function for installing required packages from GH
# no way to check and see if they are already installed
.ipkGH <- function(p){
  message('installing packages from GitHub...')
  # this function is vectorized
  devtools::install_github(p, dependencies=FALSE, upgrade_dependencies=FALSE)
}

# install packages / work-arounds needed for a named report
reportSetup <- function(reportName) {
  
  # get base directory where reports are stored within package
  base.dir <- system.file(paste0('reports/', reportName), package='soilReports')
  
  # all reports use the same setup file
  setup.file <- list.files(base.dir, recursive = FALSE, pattern='setup.R')
  setup.file <- paste0(base.dir, '/', setup.file)
  
  # source file into temp environment
  env <- new.env()
  sys.source(setup.file, envir = env)
  
  # install any missing packages from CRAN
  p <- get('.packages.to.get', envir = env)
  if(!is.null(p))
    .ipkCRAN(p)
  
  # install any missing packages from GH
  p <- get('.gh.packages.to.get', envir = env)
  if(!is.null(p))
    .ipkGH(p)
  
  # perform any manual fixes specified in the setup.R
  # this is a list, each item is a command
  f <- get('.fixes', envir = env)
  sapply(f, function(i) eval(parse(text=i)))
  
  # let user know that we are ready to go
  message('required packages are installed') 
}

