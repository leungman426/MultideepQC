
illu_globalmethy <- function(par){
  if (par == 'CG_C_globalmethylation') {
    text <- 'number of CG sites with unmethylated C'
  }
  if (par == 'CG_mC_globalmethylation') {
    text <- 'number of CG sites with methylated C'
  }
  if (par == 'CG_ratio_globalmethylation') {
    text <- '(%) ratio of CG sites with methylated C'
  }
  if (par == 'CH_C_globalmethylation') {
    text <- 'number of CH sites with unmethylated C'
  }
  if (par == 'CH_mC_globalmethylation') {
    text <- 'number of CH sites with methylated C'
  }
  if (par == 'CH_ratio_globalmethylation') {
    text <- '(%) ratio of CH sites with unmethylated C'
  }
return(text)
} 