
# temp hack to get daff chunks into an rmarkdown doc
wrapDaffHTML <- function(chunkHTML, chunkTitle) {
  cat("<div class='highlighter' style='align:center; font-size:80%;'>")
  cat(paste0("<h3>", chunkTitle, "</h3>"))
  cat(chunkHTML)
  cat("</div><br><br>")
}


