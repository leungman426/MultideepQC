
illu_cov <- function(par) {
  if ( par == "coverage.QC.bases"){
    text <- '(X) the mean read depth (coverage) on the base positions which pass the QC'
    title <- 'coverage'
  }
  if ( par ==  'genome_w.o_N.coverage.QC.bases'){
    text <- '(X) the mean read depth (coverage) on the non-N base positions which pass the QC'
    title <- 'Not N coverage'
  }
  if ( par ==  'X.QC.bases..total.bases'){
    text <- '(%) coverage on the QC-pass base positions/coverage on the total base positions'
    title <- 'QC bases/total bases ('
  }
  if ( par ==  'X.QC.bases..total.not_N.bases'){
    text <- '(%) coverage on the non-N QC-pass base positions/coverage on the total non-N base positions'
    title <- 'QC bases/total not N bases'
  }
  if ( par ==  'X.incorrect.PE.orientation'){
    text <- '(%) coverage on the base positions with incorret paired-end orientation/coverage on the total base positions'
    title <- '% incorrect PE orientation'
    }
  if ( par ==  'X.incorrect.proper.pair'){
    text <- '(%) coverage on the base positions with incorret proper pair/coverage on the total base positions'
    title <- 'incorrect proper pair'
    }
  if ( par ==  'mapq.0.read1'){
    text <- 'number of read1 (mapq = 0)'
    title <- "Read 1 mapq = 0" 
  }
  if ( par == 'mapq.0.BaseQualityMedian.basequalCutoff.read1'){
    text <- 'number of read1 (mapq > 0 & base quality median < base cutoff)'
    title <- 'Read 1 mapq > 0 base quality median < base cutoff'
  }
  if ( par ==  'mapq.0.BaseQualityMedian..basequalCutoff.read1'){
    text <-'number of read1 (mapq > 0 & base quality median > base cutoff)'
    title <- 'Read 1 mapq > 0 base quality median > base cutoff'
  }
  if ( par ==  'mapq.0.readlength.minlength.read1'){
    text <- 'number of read1 (mapq > 0 & read length < min length)'
    title <- 'Read 1 mapq > 0 read length < min length'
  }
  if ( par ==  'X.duplicates.read1..excluded.from.coverage.analysis.'){
    text <- 'number of duplicated read1' 
    title <- 'Read 1 duplicates'
  }
  if ( par == 'mapq.0.read2'){
    text <- 'number of read2 (mapq = 0)'
    title <- 'Read 2 mapq = 0'
  }
  if ( par ==  'mapq.0.BaseQualityMedian.basequalCutoff.read2'){
    text <- 'number of read2 (mapq > 0 & base quality median < base cutoff)'
    title <- 'Read 2 mapq > 0 base quality median < base cutoff'
  }
  if ( par ==  'mapq.0.BaseQualityMedian..basequalCutoff.read2'){
    text <-'number of read2 (mapq > 0 & base quality median > base cutoff)'
    title <- 'Read 2 mapq > 0 base quality median > base cutoff'
  }
  if ( par == 'mapq.0.readlength.minlength.read2'){
    text <- 'number of read2 (mapq > 0 & read length < min length)'
    title <- 'Read 2 mapq > 0 read length < min length'
  }
  if ( par ==  'X.duplicates.read2..excluded.from.coverage.analysis.'){
    text <- 'number of duplicated read2'
    title <- 'Read 2 duplicates'
  }
  
return(list(text, title))
}