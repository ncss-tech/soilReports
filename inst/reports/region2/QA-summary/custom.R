

## project description
get_project_meta <- function(SS=TRUE, fixLineEndings=TRUE) {
  # must have RODBC installed
  if(!requireNamespace('RODBC'))
    stop('please install the `RODBC` package', call.=FALSE)
  
  q <- "SELECT projectiid, uprojectid, projectname, CAST(projectdesc AS ntext) AS projectdesc
  
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
  
  # replace tabs with spaces
  # tabs at the beginning of a line will confuse the MD parser, generating <code><pre> blocks
  d$projectdesc <- gsub(d$projectdesc, pattern = '\t', replacement = ' ', fixed = TRUE)
  
  # optionally convert \r\n -> \n
  if(fixLineEndings){
    d$projectdesc <- gsub(d$projectdesc, pattern = '\r\n', replacement = '\n', fixed = TRUE)
  }
  
  
  # done
  return(d)
}


