#to ensure pacman package is installed on device before running script (e.g., new or colleague computer)
if (!requireNamespace(pacman)) install.packages("pacman")

pacman::p_load(
  #project and file mgmt
  here, #file paths relative to R project root folder
  rio, #import/export of many types of data
  
  #general data mgmt
  tidyverse, #several packages for tidy data manipulation
  
  #plot options
  viridis, # colour-blind friendly palettes
)

#recurrent functions
my_sum_function <- function(x) {
  mysum <- sum(x < 0)
  return(mysum)
}