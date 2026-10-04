library(pacman)
pacman::p_load(
  #project and file mgmt
  here, #file paths relative to R project root folder
  rio, #import/export of many types of data
  #general data mgmt
  tidyverse, #several packages for tidy data manipulation
  viridis, # colour-blind friendly palettes
  dplyr,
  lubridate,
  readr,
  tydr,
  readxl,
  janitor,
  skimr,
  knitr,
  kableExtra,
  formatR,
  gridExtra,
  RColorBrewer,
  cowplot,
  ggpubr,
  ggokabeito,
  gghighlight,
  rcartocolor
  
)

#import clean nhanes csv data for BIOS640 Wk 4 Exercises
nhanes_data <- import(here("data", "cleaned_nhanes.csv"))

nrow(nhanes_data)

