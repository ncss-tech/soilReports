## merge into aqp once resolved: https://github.com/ncss-tech/aqp/issues/214

## consider using depths() to re-init from data.frame vs. x[0, ]

#' @title Make an Empty, Single Profile `SoilProfileCollection` from Template
#'
#' @param x template `SoilProfileCollection`
#' @param fakeID a new, fake ID
#' @param top a new top depth
#' @param bottom a new bottom depth
#'
#' @return `SoilProfileCollection` containing a single, fake profile
#' @export
#'
#' @examples
#' 
#' # simplest case, use a SPC
#' data("jacobs2000")
#' emtpySPC(jacobs2000)
#' 
#' # convert to SPC with data.table internals
#' x <- jacobs2000
#' aqp_df_class(x) <- 'data.table'
#' x <- rebuildSPC(x)
#' 
#' emtpySPC(x)
#' 
#' # convert to SPC with tibble internals
#' x <- jacobs2000
#' aqp_df_class(x) <- 'tibble'
#' x <- rebuildSPC(x)
#' 
#' emtpySPC(x)
#' 
emtpySPC <- function(x, fakeID = 'MISSING', top = 0, bottom = max(x)) {
  
  # use the first profile / horizon
  # as template
  fake <- x[1, 1]
  
  # critical IDs and depths
  idn <- idname(x)
  hzid <- hzidname(x)
  htb <- horizonDepths(x)
  hzname <- hzdesgnname(x)
  
  # min required for @site
  s <- site(fake)
  # set all columns to NA
  s[] <- NA
  # ID
  s[[idn]] <- fakeID
  
  # min required for @horizons
  h <- horizons(fake)
  # set all columns to NA
  h[] <- NA
  
  # IDs
  h[[idn]] <- fakeID
  h[[hzid]] <- fakeID
  
  # depths
  h[[htb[1]]] <- top
  h[[htb[2]]] <- bottom
  
  # hzname if possible
  if(hzname != '') {
    h[[hzname]] <- ''
  }
  
  # re-pack
  fake@site <- s
  fake@horizons <- h
  
  return(fake)
}



harmonizeVar <- function(x, varName, shortName) {
  
  # de-normalization instructions
  v.names <- 
    list(
      c(
        Low = sprintf("%s_l", varName),
        RV = sprintf("%s_r", varName),
        High = sprintf("%s_h", varName)
      )
    )
  
  # short name used to refer to denormalized variable
  names(v.names) <- shortName
  
  # split l,rv,h -> 3 new profiles
  z <- harmonize(x, x.names = v.names, grp.name = 'hgroup')
  
  # combine component name with l,rv,h
  z$.label <- sprintf("%s-%s", z$compname, z$hgroup)
  
  return(z)
  
}



## hack: this references objects outside of function scope
## just component data
thematicComponentSketches <- function() {
  
  
}


## OSD + component + component pedons
OverviewSketches <- function(osds.sub, co.sub, p.sub) {
  
  # max depth for sketch of combined SPCs
  # add some space below for labels
  md <- max(
    max(osds.sub),
    max(co.sub),
    max(p.sub),
    na.rm = TRUE
  ) + 15
  
  n.p <- length(osds.sub) + length(co.sub) + length(p.sub)
  
  g0 <- expand.grid(
    x = seq(from = 1, to = n.p - 1) + 0.4,
    y = c(5, 10, 25, 50, 75, 100, 150)
  )
  
  g1 <- expand.grid(
    x = seq(from = 1, to = n.p - 1) + 0.6,
    y = c(5, 10, 25, 50, 75, 100, 150)
  )
  
  # list of SPCs to sketch together
  spcs <- list(
    osds.sub,
    co.sub, 
    p.sub
  )
  
  
  # 
  arg.list <- list(
    list(width = 0.25, name.style = 'center-center', hz.depths = TRUE, cex.names = 0.66),
    list(width = 0.25, label = '.label', name.style = 'center-center', hz.depths = TRUE, cex.names = 0.66),
    list(width = 0.25, label = '.pedon_label', name.style = 'center-center', hz.depths = TRUE, cex.names = 0.66)
  )
  
  par(mar = c(0, 1, 0, 0))
  
  plotMultipleSPC(
    spcs, label.offset = 4,
    group.labels = c('OSD', 'Component', 'Component Pedons'), 
    bracket.base.depth = md,
    max.depth = md + 10,
    plot.depth.axis = FALSE,
    args = arg.list
  )
  
  segments(x0 = g0$x, x1 = g1$x, y0 = g0$y, y1 = g1$y, col = grey(0.75))
  
}

## hack: this references objects outside of function scope
## OSD + component l,rv,h + component pedons
thematicSketches <- function(v.co, v.p, fig.title, osds.sub, co.sub, p.sub) {
  
  # max depth for sketch of combined SPCs
  # add some space below for labels
  md <- max(
    max(osds.sub),
    max(co.sub),
    max(p.sub),
    na.rm = TRUE
  ) + 15
  
  ## harmonize by variable
  z <- harmonizeVar(co.sub, varName = v.co, shortName = v.p)
  
  spcs <- list(
    osds.sub,
    z, 
    p.sub
  )
  
  
  arg.list <- list(
    list(width = 0.25, name.style = 'center-center', hz.depths = TRUE, cex.names = 0.66),
    list(width = 0.25, label = 'hgroup', name.style = 'center-center', hz.depths = TRUE, cex.names = 0.66, plot.order = c(2,3,1)),
    list(width = 0.25, label = '.pedon_label', name.style = 'center-center', hz.depths = TRUE, cex.names = 0.66)
  )
  
  n.p <- length(osds.sub) + length(z) + length(p.sub)
  
  g0 <- expand.grid(
    x = seq(from = 1, to = n.p - 1) + 0.4,
    y = c(5, 10, 25, 50, 75, 100, 150)
  )
  
  g1 <- expand.grid(
    x = seq(from = 1, to = n.p - 1) + 0.6,
    y = c(5, 10, 25, 50, 75, 100, 150)
  )
  
  par(mar = c(0, 1, 3, 0))
  
  plotMultipleSPC(
    spcs, label.offset = 7,
    group.labels = c('OSD', co.sub$.label, 'Component Pedons'), 
    bracket.base.depth = md,
    max.depth = md + 5, 
    plot.depth.axis = FALSE,
    args = arg.list,
    merged.legend = v.p, 
    merged.legend.title = fig.title
  )
  
  segments(x0 = g0$x, x1 = g1$x, y0 = g0$y, y1 = g1$y, col = grey(0.75))
}

