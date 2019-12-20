check.packages <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    message(new.pkg, ' package is required for this tool.')
}
check.packages(c('shiny', 'shinydashboard','shinyWidgets', 'DT',
                 'scales', 'ggplot2', 'plotly', 'tidyr', 'ggdendro', 
                 'ComplexHeatmap', 'circlize'))
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)
library(scales)
library(ggplot2)
library(plotly)
library(tidyr)
library(ggdendro)
library(ComplexHeatmap)
library(circlize)

# get the path where the script is located

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

if(interactive()) {
  path <- dirname(rstudioapi::getSourceEditorContext()$path)
} else {
  path <- get_scriptdir()
}




files <- list.files(path, pattern = '.R')
path <- paste0(path, '/')
for (file in files) {
  if (!(file %in% c("server.R", "shiny.R", "ui.R"))) {
   source(paste0(path, file))
    }
}

if(interactive()) {
  runApp(path)
} else {
  runApp(path, launch.browser = TRUE)
}

#runApp(paste0(path, '/shinyapp'))



