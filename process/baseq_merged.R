# obtain the mean and median methylation vs baseQ of all chromosomes for each samples
library(pryr)

otp_path <- '/icgc/dkfzlsdf/project/hipo/hipo_016/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/'
path <- '/home/liangwe/tool/data/'
source('/home/liangwe/tool/function/mergefunction.R')
starttime <- Sys.time()

dir.create(paste0(path, 'baseq_merged'))

filepattern <- c('baseq_mate1_CG_mC_ratio.csv', 'baseq_mate1_CH_mC_ratio.csv', 
                 'baseq_mate2_CG_mC_ratio.csv', 'baseq_mate2_CH_mC_ratio.csv')

merge_function(path, 'baseq_merged/', 0, 41, filepattern)


mem <- mem_used()
endtime <- Sys.time()
runtime <- endtime - starttime 
write(c(mem, runtime), paste0(path,'baseqmerged_info.txt'))
