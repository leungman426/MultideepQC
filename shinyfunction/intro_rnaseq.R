tabItem(tabName = "guide_rna", align = "left",style="width:80%;",
        tags$div(class="header", checked=NA,
                 
                 tags$br(),       
                 tags$b("RNA Sequencing (RNA-Seq)",
                        style = 'text-align:center;
                        font-family:Bradley Hand;
                        font-size:200%;margin-left:5%'),
                 tags$br(),
                 tags$br(), 
                 tags$ol(
                   tags$li("Flagstat", style = 'font-family:Comic Sans MS;
                           font-size:150%;
                           color:DarkCyan'), 
                   tags$p('SAM FLAG in the SAM files summarises the properties of the reads. 
                          The Flagstat report provides counts for each of the 15 categories in the FLAG field such as the number of total reads, 
                          number of mapped reads, duplicates reads and so on. ',
                          style = 'font-family:Comic Sans MS; font-size:120%'),
                   tags$li("RNASeQC Read Count Metrics", style = 'font-family:Comic Sans MS;
                           font-size:150%; color:DarkCyan'),
                   tags$p('RNASeQC tool generates the read count metrics including plenties of read count parameters',
                          style = 'font-family:Comic Sans MS; font-size:120%'),
                   
                   tags$b('> Total Reads', style = 'font-family:Comic Sans MS; font-size:120%'),
                   tags$p('Total read count metrics and the rRNA mapping ratio',  
                          style = 'font-family:Comic Sans MS; font-size:100%'),
                   tags$b('> Mapped Reads', style = 'font-family:Comic Sans MS; font-size:120%'),
                   tags$p('Mapped Reads count metrics', style = 'font-family:Comic Sans MS; font-size:100%'),
                   tags$b('> Transcript Associated Reads', style = 'font-family:Comic Sans MS; font-size:120%'),
                   tags$p('Transcript Associated Read count metrics, intronic, exonic and intergenic regions mapping ratio',  
                          style = 'font-family:Comic Sans MS; font-size:100%'),
                   tags$b('> Strand Specific Reads', style = 'font-family:Comic Sans MS; font-size:120%'),
                   tags$p('Strand Specific read count metrics and End1/End2 sense percentage',  
                          style = 'font-family:Comic Sans MS; font-size:100%'),
                   tags$li('Expression level for transcripts', style = 'font-family:Comic Sans MS;
                           font-size:150%; color:DarkCyan'),
                   tags$p('The expression level for protein coding RNA, lincRNA, miRNA, miscRNA, rRNA, snRNA and snoRNA.',
                          style = 'font-family:Comic Sans MS; font-size:120%'),
                   tags$li('Expression level versus gene (exon) length', style = 'font-family:Comic Sans MS;
                           font-size:150%;
                           color:DarkCyan'),
                   tags$p('The tool investigates the relationship between the expression level and 
                          the gene length and exon length. ',
                          style = 'font-family:Comic Sans MS;font-size:120%'),
                   tags$li('Gene Expression Level', style = 'font-family:Comic Sans MS;
                           font-size:150%;
                           color:DarkCyan'),
                   tags$p('The tool shows the gene expression level of all samples via heatmap.
                          The genes are groupped into high, intermeidate and low expression level genes.',
                          style = 'font-family:Comic Sans MS;
                          font-size:120%'),
                   tags$li('Clustering Analysis', style = 'font-family:Comic Sans MS;
                           font-size:150%;
                           color:DarkCyan'),
                   tags$p('The unspervised sample clustering analysis based on the gene expression level via PCA and dendrogram ',
                          style = 'font-family:Comic Sans MS;
                          font-size:120%')
                   
                   )
                   )
                   )