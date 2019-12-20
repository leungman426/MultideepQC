
# variable: (coverage)"coverage.QC.bases",
#(Not N coverage) 'genome_w.o_N.coverage.QC.bases',
#(QC reads/total reads) 'X.QC.bases..total.bases',
#(QC reads/total not N reads)'X.QC.bases..total.not_N.bases',
#(% incorrect PE orientation) 'X.incorrect.PE.orientation',
#(incorrect proper pair) 'X.incorrect.proper.pair',
#(Read 1 mapq = 0)'mapq.0.read1',
#(Read 1 mapq > 0 base quality median < base cutoff) 'mapq.0.BaseQualityMedian.basequalCutoff.read1',
#(Read 1 mapq > 0 base quality median > base cutoff) 'mapq.0.BaseQualityMedian..basequalCutoff.read1',
#(Read 1 mapq > 0 read length < min length) 'mapq.0.readlength.minlength.read1',
#(Read 1 duplicates) 'X.duplicates.read1..excluded.from.coverage.analysis.',
#(Read 2 mapq = 0)'mapq.0.read2', 
#(Read 2 mapq > 0 base quality median < base cutoff) 'mapq.0.BaseQualityMedian.basequalCutoff.read2',
#(Read 2 mapq > 0 base quality median > base cutoff) 'mapq.0.BaseQualityMedian..basequalCutoff.read2',
#(Read 2 mapq > 0 read length < min length) 'mapq.0.readlength.minlength.read2',
#(Read 2 duplicates)'X.duplicates.read2..excluded.from.coverage.analysis.'
otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/data/'
source('/function/depthofcoveragefunction.R')

library(pryr)
starttime <- Sys.time()
variables <- c("coverage.QC.bases", 'genome_w.o_N.coverage.QC.bases','X.QC.bases..total.bases','X.QC.bases..total.not_N.bases',
              'X.incorrect.PE.orientation', 'X.incorrect.proper.pair', 'mapq.0.read1','mapq.0.BaseQualityMedian.basequalCutoff.read1',
              'mapq.0.BaseQualityMedian..basequalCutoff.read1', 'mapq.0.readlength.minlength.read1', 
              'X.duplicates.read1..excluded.from.coverage.analysis.', 'mapq.0.read2',  'mapq.0.BaseQualityMedian.basequalCutoff.read2',
              'mapq.0.BaseQualityMedian..basequalCutoff.read2', 'mapq.0.readlength.minlength.read2',     'X.duplicates.read2..excluded.from.coverage.analysis.')       
for ( variable in variables ){
df <- df_retrival(otp_path, variable, path)
}

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'depthofcov_info.txt'))
