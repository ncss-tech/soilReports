## TODO: figure out how to add to an existing .Rprofile
## ideas from here: https://cran.r-project.org/bin/windows/base/rw-FAQ.html#What-are-HOME-and-working-directories_003f

installRprofile <- function(overwrite=FALSE) {
  
  # information
  message(paste('HOME directory:\n ', path.expand('~'), collapse = ''))
  message(paste('Current R library paths:', paste('\n ', .libPaths(), collapse='')))
  
  # location
  rp <- file.path(path.expand('~'), '.Rprofile')
  
  # check for existing
  if(file.exists(rp) & ! overwrite)
    stop(paste0('set `overwrite=TRUE` argument to replace existing .Rprofile file:\n  ', rp), call. = FALSE)
  
  # new /HOME/.Rprofile that should direct packages to C:/
  # this should have NO indentiation !!!
  Rprofile.contents <- "
# 2018-10-15
# Customize R environment for use within USDA-NRCS network.
#


# establish path to where we would like R packages to be stored
c.my.documents <- file.path('C:/Users', Sys.getenv('USERNAME'), 'Documents')

# determine the sub-dir for current version of R
R.ver <- paste(R.version$major, sub('\\\\..*$', '', R.version$minor), sep='.')

# full path to where we want R packages to live
R.path.personal.lib <- file.path(c.my.documents, 'R', 'win-library', R.ver)

# if this dir is missing, make it and sub dirs
if(!dir.exists(R.path.personal.lib)) {
  message(paste0('Creating personal R package library at: ', R.path.personal.lib))
  dir.create(R.path.personal.lib, recursive = TRUE)
}

# register environmental variable for new personal library
Sys.setenv(R_LIBS_USER=R.path.personal.lib)

# change any references to network shares in env variables
Sys.setenv(HOME=c.my.documents, HOMEDRIVE='C:', HOMESHARE=c.my.documents, R_USER=c.my.documents, TEMP='C:/Temp/', TMP='C:/Temp/')

# cleanup
rm(c.my.documents, R.ver, R.path.personal.lib)

# debugging
message(paste('R library paths:', paste('\n', .libPaths(), collapse='')))

# update other evn. variables
invisible(.libPaths(c(unlist(strsplit(Sys.getenv('R_LIBS'), ';')), unlist(strsplit(Sys.getenv('R_LIBS_USER'), ';')))))
"

  # overwrite existing .Rprofile in user's HOME directory
  cat(Rprofile.contents, file = rp)
  
  # source the file, so that we can install immediately
  source(rp, echo = FALSE)

}

