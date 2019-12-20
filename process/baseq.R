library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/home/liangwe/tool/data/'
source('/home/liangwe/tool/function/baseqfunction.R')
starttime <- Sys.time()


baseq(otp_path, path)


mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'baseq_info.txt'))
