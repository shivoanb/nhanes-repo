pacman::p_load(
  #project and file mgmt
  here, #file paths relative to R project root folder
  rio, #import/export of many types of data
  
  #general data mgmt
  tidyverse, #several packages for tidy data manipulation
  
  #plot options
  viridis, # colour-blind friendly palettes
  
  #Other
  dplyr,
  lubridate,
  readr,
  tydr,
  readxl,
  janitor,
  skimr,
  rmarkdown,
  pandoc,
  tinytex
)
tinytex::install_tinytex()


#*******MAKE R MARKDOWN OUTPUT/REPORT (through code)*******
#Good for automation and flexibility/controlling aspects of output 
#Use as alternative to "Knit" button use after Rmd file created

#Create output using alz-report Rmd file (reports folder), using render() function
rmarkdown::render(input = "reports/alzheimer_report.Rmd")

#Show all the usage arguments of render function
?render

#render() arguments to format output:
#output_format = The output format to convert to (e.g. "html_document", "pdf_document", "word_document", or "all")
#output_file = The name of the output file (and file path). You can use here() or str_glue() to automatize file naming
#output_dir = The output directory (folder) to save file. Can choose a diff output folder than dir with .Rmd file.

#save report in subfolder named “reports” and include current date in file name
rmarkdown::render(
  input         = "reports/alzheimer_report.Rmd",
  output_format = "word_document",
  output_file   = str_glue("report_{Sys.Date()}.docx")
)