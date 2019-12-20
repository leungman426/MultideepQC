
file_rnaseqqc <- function(path, par){
  if (par == 'total') {
  file <- read.csv2(paste0(path, 'totalread.csv'), stringsAsFactors = FALSE)
  colnames(file) <- c("samples", "Alternative Alignments",           
                      "Base Mismatch Rate", "Chimeric Pairs",                   
                      "Duplicates", "Duplicates Rate",                   
                      "Estimated Library Size", "Failed Vendor QC Check",              
                      "Paired I nSequencing", "Properly Paired",                   
                      "Properly Paired Percentage", "QC Failed Reads",                    
                      "rRNA Rate", "rRNA Reads",                        
                      "Read Length" , "Secondary Alignments",             
                      "Singletons", "Singletons Percentage",             
                      "Split Reads", "Supplementary Alignments",          
                      "Total Purity Filtered Reads Sequenced", "Total Read Counter",                 
                      "Unpaired Reads")
  }
  if (par == 'mapped'){
    file <- read.csv2(paste0(path, 'mappedread.csv'), stringsAsFactors = FALSE)
    colnames(file) <- c("samples", "Mapped",                          
                        "Mapped Pairs", "Mapped Read1",                    
                        "Mapped Read2", "Mapped Unique",                  
                        "Mpped Unique Rate Of Total", "Mapping Rate",                      
                        "Total Mapped Read Counter", "Total Mapped Read Counter Percentage", 
                        "Transcripts Detected", "Unique Rate of Mapped", 
                        "With Itself And Mate Mapped", 'With Mate Mapped To Different Chr',  
                        "With Mate Mapped To Different Chr Maq" )
  }
  if (par == 'transcripts'){
    file <- read.csv2(paste0(path, 'transcriptsreads.csv'), stringsAsFactors = FALSE)
    colnames(file) <- c("samples", "Exonic Rate",                   
                        "Expression Profiling Efficiency", "Genes Detected",                 
                        "Insert Size Mean", "Insert Size SD",                 
                        "Intergenic Rate", "Intragenic Rate",               
                        "Intronic Rate", "Transcripts Detected") 
  }
  if (par == 'strand'){
    file <- read.csv2(paste0(path, 'strandspecificity.csv'), stringsAsFactors = FALSE)
    colnames(file) <- c("samples", "End1 Antisense", "End1 Mapping Rate",    
                        "End1 Mismatch Rate", "End1 Percentage Sense", "End1 Sense",           
                        "End2 Antisense", "End2 Mapping Rate", "End2 Mismatch Rate",    
                        "End2 Percentage Sense", "End2 Sense")
  }
  return(file)
}