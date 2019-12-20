otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/data/'
source('/function/depthofcov_mergedfunction.R')

library(pryr)
starttime <- Sys.time()

merged_function(path, 'depthofcoverage_merged/')


mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'depthofcovmerged_info.txt'))
