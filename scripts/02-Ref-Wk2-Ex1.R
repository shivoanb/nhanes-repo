source("00-functions.R")
library(pacman)
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
  readxl
)

#Compare version of R with latest version
R.version.string

# update all packages
update.packages(ask = FALSE, checkBuilt = TRUE)


#import COVID xlsx data set from BIOS640 Wk 2 Exercises
covid_data <- import(here("data", "covid-hospital.xlsx"))

#view data set
View(covid_data)

#provides number of rows and columns
dim(covid_data)

# Shows the structure of data
str(covid_data)

#import COVID xlsx data set (Sheet Glen) from BIOS640 Wk 2 Exercises
covid_data <- import(here("data", "covid-hospital.xlsx"),
                    which = "Glen" )

View(covid_data)

# read sheet names
sheet_names <- excel_sheets(here("data", "covid-hospital.xlsx"))
print(sheet_names)

# create an empty list
covid_data <- vector(
  mode = "list",
  length = length(sheet_names)
)

# sequentially read and save the Excel sheets
for (i in seq_along(sheet_names)) {
  covid_data[[i]] <- import(
    here("data", "covid-hospital.xlsx"),
    which = sheet_names[i]
  )
}

# name data set with corresponding sheet name
names(covid_data) <- sheet_names

# view data from Montreal General Hospital
head(covid_data$`Montreal General Hospital`, n = c(5, 5))

#List files in daily folder
files <- dir(here("data", "daily"))
files 

