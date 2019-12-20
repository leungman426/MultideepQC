library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_043/sequencing/rna_sequencing/view-by-pid/'
path <- '/data/'
source('/function/rnaseqcfunction.R')
starttime <- Sys.time()


rnaseq_fun(otp_path, path)

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'rnaseqc_info.txt'))
