##
## functions related to cLHS sub-sampling and multivariate analysis
##

# return variables safe for cLHs
# required to resolve https://github.com/ncss-tech/soilReports/issues/87
# x: data.frame in wide format
# id: vector of IDs variables to exclude from SD test, first element is the group ID
# tol: tolerance for near-0 SD test
findSafeVars <- function(x, id, tol=1e-5) {
  
  n <- names(x)
  
  # find non-id vars
  non.id.vars <- n[-match(id, n)]
  
  # test must be applied over IDs
  # the group ID must be the first ID in `id`
  group.id <- id[1]
  xl <- split(x, x[[group.id]])
  
  # iterate over chunks as split by ID
  v <- lapply(xl, function(i) {
    
    # compute SD by variable, after removing ID columns
    low.sd <- lapply(i[, non.id.vars], function(j) {
      i.sd <- sd(j, na.rm = TRUE)
      return(i.sd < tol)
    } )
    
    # treat 0 length as 0 variance
    if (length(low.sd) == 0)
      return(NA)
    
    # get variable names associated with low SD
    bad.vars <- names(which(sapply(low.sd, isTRUE)))
  })
  
  # reduce and get unique names; omit 0 length == NA
  v <- unique(na.omit(unlist(v)))
  
  if(length(v) > 0) {
    # remove from names
    idx <- match(v, non.id.vars)
    non.id.vars <- non.id.vars[- idx]
  }
  
  return(non.id.vars)
}

## note: this will fail when SD ~ 0
# https://github.com/pierreroudier/clhs/issues/2
# cut down to reasonable size: using cLHS
cLHS_subset <- function(i, n, non.id.vars) {
  # if there are more than n records, then sub-sample
  if(nrow(i) > n) {
    # columns with IDs have been pre-filtered
    idx <- clhs(i[, non.id.vars], size=n, progress=FALSE, simple=TRUE, iter=1000)
    i.sub <- i[idx, ]
  }
  #	otherwise use what we have
  else
    i.sub <- i
  
  return(i.sub)
}


