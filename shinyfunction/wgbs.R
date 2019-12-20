tabItem(tabName = "guide_wgbs", align = "left",style="width:80%;",
                  tags$div(class="header", checked=NA,
                          
                  tags$br(),       
                  tags$b("Multiple-sample QC for Whole Genome Bisulfite Sequencing (WGBS)",
                         style = 'text-align:center;
                                  font-family:Bradley Hand;
                                  font-size:200%'),
                  tags$br(),    
                    tags$ol(
                    tags$li("General Coverage", style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                                          color:DarkCyan'), 
tags$p('Coverage of sequencing is the average number of times that each nucleotide is expected to be sequenced. 
This tool looks into the different coverage parameters such as total coverage, non-N coverage, 
incorrect proper pair reads and so on. ',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%'), 
                    tags$li("Flagstat", style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                                           color:DarkCyan'), 
tags$p('SAM FLAG in the SAM files summarises the properties of the reads. 
       The Flagstat report provides counts for each of the 13 categories in the FLAG field such as the number of total reads, 
       number of mapped reads, duplicates reads and so on. ',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%'),
                    tags$li("Global Methylation", style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                                       color:DarkCyan'),
tags$p('The tool investigates the methylation ratio of CG or CH sites in the whole genome and in each chromosome.',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%'),
                    tags$li('Methylation for Read Positions', style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                            color:DarkCyan'),
tags$p('The average methylation ratio at each read position.',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%'),
                    tags$li('Distribution of CG/CH Coverage', style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                            color:DarkCyan'),
tags$p('The distribution of CG sites and CH sites coverage. ',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%'),
                    tags$li('Methylation for Each Base Q Score', style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                            color:DarkCyan'),
tags$p('The tool looks into the base Q score of each methylation ratio.',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%'),
                    tags$li('Methylation Distribution', style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                            color:DarkCyan'),
tags$p('The distribution of methylation level in all regions, in CpG islands and in CpG shores respectively.',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%'),
                    tags$li('Clustering Analysis', style = 'font-family:Comic Sans MS;
                                           font-size:150%;
                            color:DarkCyan'),
tags$p('Unsupervised clustering of samples based on their CpG sits methylation level via PCA and dendrogram. ',
                           style = 'font-family:Comic Sans MS;
                                           font-size:120%')
                  
                    )
                  )
)              
                  
                  
                  
                  
                  
                 
                 
                  