## generalized horizon designations
gen.hz.rules <- list(
  'Carrizo'=list(
    n=c('C', 'A', '2Bk', '2Ckq', '2Btkqb', 'Bk'),
    p=c('C', '^A', 'BA|^Bk|^2Bk', 'C1$|C2$|^BCk|^2BCk|^Ck|^2Ck|^Cq|^2Cq', 'Bt|^2Bkqb')
  ),
  'Cajon'=list(
    n=c('A', 'Bk', 'Ck'),
    p=c('^A', '^BA|^Bk|^Bw', '^C|BC')
  ),
  "Genesee"=list(
    n=c("Ap", "A", "Bw", "C", "Cg", "Ab", "2Bt", "NA"),
    p=c("Ap|Ap1|Ap2|AP", "^A$|A1|A2|A3", "^B", "C|C1|C10|C2|C3|C4|C5|C6|C7|C8|C9", "^Cg", "Ab", "^2Bt","NA")
  ),
  "Miamian"=list(
    n=c("Ap", "A", "E", "Bt", "BC", "C", "Cd", "NA"),
    p=c("Ap|AP|1A|A1|A2|A p", "^A$", "E", "BE", "Bt|BT|1B|B2|B3|BA|B1|B t1|B t2", "BC", "^B$", "C", "Cd","NA")
  ),
  "Crosby"=list(
    n=c("Ap", "A", "BE", "Bt", "BCt", "Cd", "NA"),
    p=c("Ap|1A p", "1A|A", "BE|^E|1E", "^1B t|^2B t|^2Bt|^B1|^B2|^Btg|BTG|^Bg|^Bt|^BT", "1BC|2BC|3BC|^BC|BCT|1C|^2C|^C", "Cd","^2H|^3H|^4H|^5H|^H|R|NA")
  ),
  "Mahalasville"=list(
    n=c("Ap", "Btg", "2Btg", "2BCg", "2Cg", "NA"),
    p=c("Ap|AP", "Bt|BT|1B|B2|B3|B4|BA|B1|B t1|B t2|2B t3|2B t4|2Bk|BW|B&A|Bt3|Btk", "BC", "^B$", "C", "Cd", "NA")
  ),
  "Xenia"=list(
    n=c("Ap", "E", "Bt", "2Bt", "2BCt", "2Cd", "NA"),
    p=c("Ap", "E", "Bt|BT|1B|B2|B3|B4|BA|B1|B t1|B t2|2B t3|2B t4|2Bk|BW|B&A|Bt3|Btk|2B5|B t3|B t4|B t5|2Bd3", "BC|Bc2", "^B$", "C", "Cd", "NA")
  ),
  "Patton"=list(
    n=c("Ap", "Bg", "Cg", "NA"),
    p=c("^A|1A", "^1B g|^B", "1C g|^2C|^C", "Eg|^H|NA")
  ),
  "Cincinnati"=list(
    n=c("Ap", "Bt", "Btx", "2Bt", "3Bt", "3B't", "3C", "NA"),
    p=c("^A", "^Bt1|^Bt2|^B21t|^B22T|BT", "^BX|Bx2|^2Btx|^2Bx|^Btx", "^IIB", "^3Btb|^3B t|Bt3|^IIIB", "3B't", "3C|^C|IIIC", "^2C|^4B|^4C|^5|BA|E|R")
  )
)
ghr <- gen.hz.rules
# summary(factor(f$genhz))
# f$genhz <- as.character(f$genhz)
# f$genhz <- ifelse(is.na(f@horizons$genhz), generalize.hz(f$hzname,
# gen.hz.rules$carrizo$n, gen.hz.rules$carrizo$p), f@horizons$genhz)
# f$genhz <- factor(f$genhz, levels=gen.hz.rules$carrizo$n, ordered=T)
# summary(factor(f$genhz))