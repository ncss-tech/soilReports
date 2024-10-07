## Purpose: this file containst a list defining:
## - [name] report name- typically a taxonname
## -- [n] generalized horizon labels (GHL)
## -- [p] REGEX pattern used to match GHL
## -- [pedons] vector of unique pedon IDs used within the report

##
## Notes:
##
## 1. don't forget to include Cd, Cr, and R horizons!
##
##

# these describe horizon grouping patterns, used to lump like-horizons for {low,RV,high} 
gen.hz.rules <- list(
	'typic cryorthents'=list(
          n=c('A','C1','C2','C3'),
	        p=c('A$|A1', 'C1|Bw|C$|A2', 'C2|C$', 'C3')
	),
  'canisrocks'=list(
          n=c('Oi','A','Bw','C1','C2'),
          p=c('O', '^A$|A1|A2', 'Bw|2Bw', 'C1|C$|2C1', 'C2|C3|C4|2C2')
  ),         
   'mokelumne'=list(
          n=c('Oi','A','Bt1','Bt2','Cd'),
          p=c('O', 'A', 'AB|Bw|Bt|Bt1', 'BC|Bt[23]', '^C')
  ),
   'hornitos'=list(
          n=c('A','Bw','R'),
          p=c('A', 'B', 'R|Cr')
  ),
	'ultic haploxeralfs'=list(
	  n=c('Oi','A','Bt1','Bt2','Cd'),
	  p=c('O', 'A', 'AB|Bw|Bt|Bt1', 'BC|Bt[23]', '^C')
	),
  'wardsferry'=list(
    n=c('Oi','A','AB','Bt1','Bt2', 'Bt3','BCt','Cr','R'),
    p=c('Oi', 'A', 'AB|BA', '^Bt|Bt1', 'Bt2', 'Bt[3456]', 'BC|CB|C$', 'Cr', 'R')
  ),
  'deerflat'=list(
    n=c('Oi','A','AB','Bt1','Bt2', 'Bt3','BCt','Cr','R'),
    p=c('Oi', 'A', 'AB|BA', '^Bt|Bt1', 'Bt2', 'Bt[3456]', 'BC|CB|C$', 'Cr', 'R')
  ),
  'wallyhill'=list(
    n=c('Oi','A','AB','Bw','Bt1','Bt2', 'Bt3','BCt','Cr','R'),
    p=c('Oi', 'A', 'AB|BA', 'Bw', 'Bt|Bt1', 'Bt2', 'Bt[34]', 'BC|CB|^C', 'Cr', 'R')
  ),
	'arpatutu'=list(
	  n=c('Oi','A','BA','Bw','Bt1','Bt2', 'Bt3','BCt','Cr','R'),
	  p=c('Oi', 'A', 'AB|BA', 'Bw', 'Bt|Bt1', 'Bt2', 'Bt[34]', 'BC|CB|^C', 'Cr', 'R')
	),
	'sanquinetti'=list(
	  n=c('Oi','A','BA','Bw1','Bw2','Bt1','Bt2','BC','Cr','R'),
	  p=c('Oi', 'A', 'AB|BA', 'Bw1','Bw[23]', 'Bt|Bt[12]', 'Bt[345]', 'BC|CB|C', 'Cr', 'R')
	),
	'loafercreek'=list(
	  n=c('Oi','A','BA','Bw1','Bw2','Bt1','Bt2','BC','Cr','R'),
	  p=c('Oi', 'A', 'AB|BA', 'Bw1','Bw[23]', 'Bt|Bt[12]', 'Bt[345]', 'BC|CB|C', 'Cr', 'R')
	),
	'hetchy'=list(
	  n=c('Oi', 'A','AB','Bw','Bt1','Bt2','Bt3','BC','C','Cr', 'R'),
	  p=c('O', 'A','AB|BA|ABt','Bw','Bt1|^Bt','Bt2','Bt[34]','^BC|^2BC','^C$|^2C$','Cr', 'R')
	),
	'lickinfork'=list(
	  n=c('Oi', 'A','AB','Bw','Bt1','Bt2','Bt3','BC','C','Cr', 'R'),
	  p=c('O', 'A','AB|BA|ABt','Bw','Bt1|^Bt','Bt2','Bt[34]','^BC|^2BC','^C$|^2C$','Cr', 'R')
	),
	'nedsgulch'=list(
	  n=c('Oi', 'A','AB','Bw','Bt1','Bt2','Bt3','BC','C','Cr', 'R'),
	  p=c('O', 'A','AB|BA|ABt','Bw','Bt1|^Bt','Bt2','Bt[34]','^BC|^2BC','^C$|^2C$|CB','Cr', 'R')
	),
	'moccasinhill'=list(
	  n=c('A','AB','Bw1','Bw2','Bw3', 'R'),
	  p=c('A','AB|BA','Bw','Bw2','Bw[34]|BC', 'R')
	)
)


		