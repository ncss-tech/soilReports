

x <- read.csv('2017_NASS-RAT.csv', stringsAsFactors = FALSE)

head(x)



# levels
dput(x$ID)

# labels
dput(x$CLASS_NAME)

# colors
dput(rgb(x$RED, x$GREEN, x$BLUE, maxColorValue = 1))
