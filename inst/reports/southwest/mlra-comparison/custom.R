# MLRA comparison utility functions



# stat summary function
f.summary <- function(i, p) {
  
  # remove NA
  v <- na.omit(i$value)
  
  # compute quantiles
  q <- quantile(v, probs=p)
  res <- data.frame(t(q))
  
  ## TODO: implement better MADM processing and explanation  
  if(nrow(res) > 0) {
    #     # MADM: MAD / median
    #     # take the natural log of absolute values of MADM
    #     res$log_abs_madm <- log(abs(mad(v) / median(v)))
    #     # 0's become -Inf: convert to 0
    #     res$log_abs_madm[which(is.infinite(res$log_abs_madm))] <- 0
    
    # assign reasonable names (quantiles)
    names(res) <- c(paste0('Q', p * 100))
    
    return(res)
  }
  else
    return(NULL)
}



