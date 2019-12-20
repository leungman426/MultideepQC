# random selection 0.01 rows for islands and shores overlap

cpgoverlap_func <- function(filepath, path1){
 
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
  
cpg_file <- read.csv2(paste0(toolpath, '/cpgislands'), sep = '\t')

gr_cpg <- GRanges(
                  seqnames = Rle(cpg_file[,'chrom']),
                  ranges = IRanges(cpg_file[,'chromStart'], end = cpg_file[,'chromEnd'])
                  )


shore1 <- flank(gr_cpg, 2000)
shore2 <- flank(gr_cpg, 2000, FALSE)
shore1_2 <- reduce(c(shore1,shore2))
cpgi_shores <- setdiff(shore1_2, gr_cpg)
shores_cpg <- cpgi_shores[width(cpgi_shores)>=500]

sampleID <- c(list.files(filepath))

for (sample in sampleID){

    allchr_file <- data.frame()

    for (chr in c(1:22, 'X', 'Y')){
     
         if (file.exists(paste0(filepath, sample, '/tumor/paired/merged-alignment/'))){
             path <- paste0(filepath, sample, '/tumor/paired/merged-alignment/methylation/merged/methylationCalling/')    
             file <- paste0(path,'tumor','_',sample,'_merged.mdup.bam.',chr,'.CG.bed.gz')
         } else if (file.exists(paste0(filepath, sample, '/tumor02/paired/merged-alignment/'))){
             path <- paste0(filepath, sample, '/tumor02/paired/merged-alignment/methylation/merged/methylationCalling/')      
             file <- paste0(path,'tumor02','_',sample,'_merged.mdup.bam.',chr,'.CG.bed.gz')
         } else if (file.exists(paste0(filepath, sample, '/control/paired/merged-alignment/'))){
             path <- paste0(filepath, sample, '/control/paired/merged-alignment/methylation/merged/methylationCalling/')    
             file <- paste0(path,'control','_',sample,'_merged.mdup.bam.',chr,'.CG.bed.gz')
         } 
         file <- fread(qq('zcat @{file}'))
         file <- file[,c(1,2,3,6,7)]
         allchr_file <- rbind(allchr_file, file)
            
    }    
     colnames(allchr_file) <- c('chromosome', 'cpg', 'strand', 'methy', 'unmethy') 
   
     # select same CpG sites for each sample
     index <- seq(1:10000)*(length(allchr_file$cpg)/10000)  
     allchr_file_all <- allchr_file[index,]
     write.csv2(allchr_file_all, paste0(path1, 'all_merged/', sample, '_all_CG.csv'))
     
     for (chr in c(1:22, 'X', 'Y')){
          index <- seq(1:50000)*(length(allchr_file$cpg)/50000)  
          allchr_file_chr <- allchr_file[index,]
          new_file <- allchr_file_chr[allchr_file_chr$chromosome==chr,]
          write.csv2(new_file, paste0(path1, chr, '_', sample, '_all_CG.csv'))
     }


     
     # allchr_file[,'cpg'] is 'data.table' 'data.frame'; allchr_file$cpg is 'integer'
     gr_sample <- GRanges(
                         seqnames = Rle(paste0('chr', allchr_file$chromosome)),
                         ranges = IRanges(allchr_file$cpg, end = allchr_file$cpg)
                         )
  
     
     shores_a <- countOverlaps(gr_sample, shores_cpg)
     islands_a <- countOverlaps(gr_sample, gr_cpg)
     allchr_shores <- cbind(allchr_file, shores_a)
     allchr_islands <- cbind(allchr_file, islands_a)
     colnames(allchr_shores) <- c('chromosome', 'cpg', 'strand', 'methy', 'unmethy', 'overlap')     
     colnames(allchr_islands) <- c('chromosome', 'cpg', 'strand', 'methy', 'unmethy', 'overlap')   
     
     allchr_shores <- allchr_shores[allchr_shores$overlap!=0,]
     allchr_islands <- allchr_islands[allchr_islands$overlap!=0,]

     if (length(allchr_islands$overlap) > 10000){  
         index <- seq(1:10000)*(length(allchr_islands$overlap)/10000)   
         allchr_islands_all <- allchr_islands[index,] }    

     if (length(allchr_shores$overlap) > 10000){  
         index <- seq(1:10000)*(length(allchr_shores$overlap)/10000)   
         allchr_shores_all <- allchr_shores[index,] }    
    
     write.csv2(allchr_islands_all, paste0(path1, 'islands_merged/', sample, '_islands_CG.csv'))     
     write.csv2(allchr_shores_all, paste0(path1, 'shores_merged/', sample, '_shores_CG.csv')) 
        
     for (chr in c(1:22, 'X', 'Y')){
          index <- seq(1:50000)*(length(allchr_islands$overlap)/50000) 
          index <- seq(1:50000)*(length(allchr_shores$overlap)/50000) 
          allchr_islands_chr <- allchr_islands[index,]
          allchr_shores_chr <- allchr_shores[index,]
          new_islands <- allchr_islands_chr[allchr_islands_chr$chromosome==chr,]
          new_shores <- allchr_shores_chr[allchr_shores_chr$chromosome==chr,]
          write.csv2(new_islands, paste0(path1, chr, '_', sample, '_islands_CG.csv'))
          write.csv2(new_shores, paste0(path1, chr, '_', sample, '_shores_CG.csv'))       
     }
  } 
}


  
