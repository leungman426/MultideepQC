check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    message(new.pkg, ' package is required for this tool.')
}
check.packages(c('tidyr', 'data.table','GetoptLong', 'GenomicRanges',
                 'stringr', 'jsonlite', 'argparse'))

library(tidyr)
library(data.table)
library(GetoptLong)
library(GenomicRanges)
library(stringr)
library(jsonlite)
library(argparse)

get_scriptdir = function() {
  args = commandArgs()
  f = grep("^--file=", args, value = TRUE)
  if(length(f)) {
    f = gsub("^--file=(.*)$", "\\1", f[1])
    return(dirname(normalizePath(f))) 
  } else {
    return(NULL)
  }
}

toolpath <- get_scriptdir()
funs <- list.files(paste0(toolpath, '/function/'))
for (file in funs) {
  source(paste0(toolpath,'/function/', file))
}

parser <- ArgumentParser()
parser$add_argument("--WGBS", action="store_true", default=TRUE,
                    help="enter the WGBS HIP0 project e.g. hipo_016")

parser$add_argument("--RNASeq", action="store_true", default=TRUE,
                    help="enter the RNASeq  HIPO project e.g. hipo_043")
parser$add_argument("-path", action="store_true", default=TRUE,
                    help="enter the local path where the new data files will be saved. e.g /home/document")

path <- paste0(args$path, '/')
args <- parser$parse_args()
dir.create(paste0(path, 'data'))

# WGBS######################################################################################
# baseq.R
if (args$WGBS) {
otp_path_wgbs <- paste0('/icgc/dkfzlsdf/project/hipo/', args$WGBS, 
                          '/sequencing/whole_genome_bisulfite_sequencing/view-by-pid/')
baseq(otp_path_wgbs, path)

# baseq_merged.R
dir.create(paste(path, 'baseq_merged/'))
filepattern <- c('baseq_mate1_CG_mC_ratio.csv', 'baseq_mate1_CH_mC_ratio.csv', 
                 'baseq_mate2_CG_mC_ratio.csv', 'baseq_mate2_CH_mC_ratio.csv')
merge_function(path, 'baseq_merged/', 0, 41, filepattern)

# depthofcoverage.R
dir.create(paste0(path, 'depthofcov/'))
variables <- c("coverage.QC.bases", 'genome_w.o_N.coverage.QC.bases','X.QC.bases..total.bases',
               'X.QC.bases..total.not_N.bases', 'X.incorrect.PE.orientation', 'X.incorrect.proper.pair',
               'mapq.0.read1','mapq.0.BaseQualityMedian.basequalCutoff.read1',
               'mapq.0.BaseQualityMedian..basequalCutoff.read1', 'mapq.0.readlength.minlength.read1', 
               'X.duplicates.read1..excluded.from.coverage.analysis.', 'mapq.0.read2',  
               'mapq.0.BaseQualityMedian.basequalCutoff.read2',
               'mapq.0.BaseQualityMedian..basequalCutoff.read2', 'mapq.0.readlength.minlength.read2', 
               'X.duplicates.read2..excluded.from.coverage.analysis.')       
for ( variable in variables ){
  df <- df_retrival(otp_path_wgbs, variable, path)
}

# depthofcoverage_merged.R
path <- paste0(path, 'depthofcov/') 
dir.create(paste0(path, 'depthofcov_merged/'))
depthofcov_merged(path, 'depthofcov_merged/')

# flagstat
df_flagstat(otp_path_wgbs, path)

# global methylation
globalmethy(otp_path_wgbs, path)

# global methylation mereged
dir.create(paste0(path, 'globalmethy_merged/'))
globalmethy_merged(path, 'globalmethy_merged/')

groupping(otp_path_wgbs, path)

# methylation level per read position
methylation_pos(otp_path_wgbs, path)

# methylation level per read position merged
dir.create(paste0(path, 'methylationpos_merged/'))
filepattern <- c('position_mate1_CG_mC_ratio.csv', 'position_mate2_CG_mC_ratio.csv')
merge_function(path, 'methylationpos_merged/', 1,125, filepattern)

# methylation calling
dir.create(paste0(path,'islands_merged/'))
dir.create(paste0(path,'shores_merged/'))
dir.create(paste0(path,'all_merged/'))
cpgoverlap_func(otp_path_wgbs, path)

combined_fun('all', otp_path_wgbs, path)
combined_fun('shores', otp_path_wgbs, path)
combined_fun('islands', otp_path_wgbs, path)

methylationcalling_merged(otp_path_wgbs, path, 'islands_merged/', 'islands')
methylationcalling_merged(otp_path_wgbs, path, 'shores_merged/', 'shores')
methylationcalling_merged(otp_path_wgbs, path, 'all_merged/', 'all')

# methylation level at each coverage
methylationcov(otp_path_wgbs, path)

# methylation level at each coverage merged
dir.create(paste(path, 'methylationcov_merged/'))
filepattern <- c('cov_CG.csv', 'cov_CH.csv')
merge_function(path, 'methylationcov_merged/', 1,200, filepattern) 

}
# RNASeq #######################################################
if (args$RNASeq) {
  otp_path_rnaseq <- paste0('/icgc/dkfzlsdf/project/hipo/', args$RNASeq, 
                            '/sequencing/rna_sequencing/view-by-pid/')
# RNASeQC read count metrics
rnaseq_fun(otp_path_rnaseq, path)

# flagstat
flagstat_rnaseq(otp_path_rnaseq, path)

# expression level 
expressionlevel1(otp_path_rnaseq, path)
expressionlevel2(otp_path_rnaseq, path)

}
###############################################################
# copy shinyapp scritps to the data folder

file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyprocess/'))), path)     
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/baseq/'))), path)          
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/depthofcov/'))), path)          
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/expressionlevel/'))), path)          
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/flagstat/'))), path)          
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/globalmethy/'))), path)          
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/methylationcalling/'))), path)
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/methylationcov/'))), path) 
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/methylationpos/'))), path) 
file.copy(paste0(toolpath, list.files(paste0(toolpath, '/shinyfunction/globalmethy/'))), path) 
file.copy(paste0(toolpath, '/shinyfunction/intro.R'), paste0(path, '/intro.R'))
file.copy(paste0(toolpath, '/shinyfunction/wgbs.R'), paste0(path, '/wgbs.R'))


