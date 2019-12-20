library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_043/sequencing/rna_sequencing/view-by-pid/'
path <- '/home/liangwe/tool/data/'
source('/home/liangwe/tool/function/flagstat_rnaseqfunction.R')
starttime <- Sys.time()


flagstat_rnaseq(otp_path, path)

mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'flagrna_info.txt'))
