.pindex <- function(x, interval){
  if (class(x)[1] == "data.frame") {x1 <- ncol(x); x2 <- 1}
  if (class(x)[1] == "SoilProfileCollection") {x1 <- length(x); x2 <-0}
  if (class(x)[1] == "table") {x1 <- ncol(x); x2 <- 0}
  n <- x1 - x2
  times <- ceiling(n / interval)
  x <- rep(1:(times + x2), each = interval, length.out = n)
  }

.na_replace <- function(x){
  if(class(x)[1] == "character" | class(x)[1] == "logical") 
    {x <- replace(x, is.na(x) | x == "NA", "missing")} 
  else (x <-  x)
  }

.na_remove <- function(df, by = 2){
  df[, which(apply(df, by, function(x) !all(is.na(x))))]
  }

.precision_f <- function(x){
  if (!all(is.na(x))) {
    y = {format(x, scientific = FALSE, trim = TRUE) ->.;
      unlist(as.data.frame(strsplit(., "\\."))[2, ]) ->.;
      as.character(.) ->.;
      max(nchar(.))}
    } else y = 0
  if (is.na(y)) y = 0 else y = y
  return(y)
  }


.sum5n <- function(x, n = NULL) {
  variable <- unique(x$variable)
  precision <- .precision_f(x$value)
  n <- length(na.omit(x$value))
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- paste0("(", paste0(round(ci, precision), collapse=", "), ")", "(", n, ")") # add 'range' column for pretty-printing
  return(ci["range"])
}


.sum5n2 <- function(x) {
  variable <- unique(x$variable)
  v <- na.omit(x$value) # extract column, from long-formatted input data
  precision <- if(variable == 'Circularity') 1 else 0
  ci <- data.frame(rbind(quantile(x$value, na.rm = TRUE, probs = p)))
  ci$range <- with(ci, paste0("(", paste0(round(ci, precision), collapse=", "), ")")) # add 'range' column for pretty-printing
  return(ci["range"])
}


.metadata_replace <- function(df, invert=FALSE, NASIS=TRUE){
  get_metadata <- function() {
    # must have RODBC installed
    if(!requireNamespace('RODBC'))
      stop('please install the `RODBC` package', call.=FALSE)
    
    q <- "SELECT mdd.DomainID, DomainName, ChoiceValue, ChoiceLabel, ChoiceDescription, ColumnPhysicalName, ColumnLogicalName
    
    FROM MetadataDomainDetail mdd
    INNER JOIN MetadataDomainMaster mdm ON mdm.DomainID = mdd.DomainID
    INNER JOIN (SELECT MIN(DomainID) DomainID, MIN(ColumnPhysicalName) ColumnPhysicalName, MIN(ColumnLogicalName) ColumnLogicalName FROM MetadataTableColumn GROUP BY DomainID, ColumnPhysicalName) mtc ON mtc.DomainID = mdd.DomainID
    
    ORDER BY DomainID, ColumnPhysicalName, ChoiceValue;"
    
    # setup connection local NASIS
    channel <- RODBC::odbcDriverConnect(connection = "DSN=nasis_local; UID=NasisSqlRO; PWD=nasisRe@d0n1y")
    
    # exec query
    d <- RODBC::sqlQuery(channel, q, stringsAsFactors = FALSE)
    
    # close connection
    RODBC::odbcClose(channel)
    
    # done
    return(d)
  }
  
  # load current metadata table
  if (NASIS == TRUE){
    metadata <- get_metadata()
  } else data(nasis_metadata)
  
  # unique set of possible columns that will need replacement
  possibleReplacements <- unique(metadata$ColumnPhysicalName)
  
  # names of raw data
  nm <- names(df)
  # index to columns with codes to be replaced
  columnsToWorkOn.idx <- which(nm %in% possibleReplacements)
  
  # iterate over columns with codes
  for (i in columnsToWorkOn.idx){
    # get the current metadata
    sub <- metadata[metadata$ColumnPhysicalName %in% nm[i], ]
    if (NASIS == TRUE) {
      if (invert == FALSE){
        # replace codes with values
        df[, i] <- factor(df[, i], levels = sub$ChoiceValue, labels = sub$ChoiceLabel)
        # replace values with codes
      } else df[, i] <- factor(df[, i], levels = sub$ChoiceLabel, labels = sub$ChoiceValue)
      
      # convert SDA characters to factors
    } else {
      df[, i] <- factor(df[, i], levels = sub$ChoiceLabel)
    }
  }
  
  return(df)
}
