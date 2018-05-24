

## project description
get_project_meta <- function(SS=TRUE, fixLineEndings=TRUE) {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT projectiid, uprojectid, projectname, projectdesc
  
  FROM 
  project_View_1
  ;
  "
  # setup connection local NASIS
  channel <- RODBC::odbcDriverConnect(connection=getOption('soilDB.NASIS.credentials'))
  
  # toggle selected set vs. local DB
  if(SS == FALSE) {
    q <- gsub(pattern = '_View_1', replacement = '', x = q, fixed = TRUE)
  }
  
  # exec query
  d <- RODBC::sqlQuery(channel, q, stringsAsFactors=FALSE)
  
  # close connection
  RODBC::odbcClose(channel)
  
  # convert codes
  d <- uncode(d)
  
  # optionally convert \r\n -> \n
  if(fixLineEndings){
    d$projectdesc <- gsub(d$projectdesc, pattern = '\r\n', replacement = '\n', fixed = TRUE)
  }
  
  
  # done
  return(d)
}


