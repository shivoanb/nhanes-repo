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
  skimr
)

#*******IMPORT AND CHECK DATASET*********


#import Alz xlsx data set from BIOS640 Wk 2.1 Exercise
alz_data <- import(here("data", "alzheimers_disease_data.csv"))


#view alz data set
View(alz_data)
head(alz_data)

#provides dimensions - number of rows and columns
dim(alz_data)

# Shows the structure of data and data types
str(alz_data)

# check header and tail
head(alz_data) # to view the first few rows
tail(alz_data) # to view the last few rows

# to see the column names
names(alz_data)
colnames(alz_data)

# get basic summary statistics for each column
summary(alz_data)

# use skimr package for comprehensive overview of the data set
pacman::p_load(skimr)
# get an overview of the data
skim(alz_data)


#********CLEANING and SELECTING/REMOVING COLUMNS******


# automatically clean column names using the clean_names() function from the janitor package
# load package
pacman::p_load(janitor)

# clean names - i.e., lowercase and underscores
alzheimer_data <- alz_data %>%
  clean_names()

names(alzheimer_data)

# manually rename columns - assign columns a new name with dplyr package
pacman::p_load(dplyr)

alzheimer_rename_data <-alzheimer_data %>%

  # automatic column names cleaning
  janitor::clean_names() %>%
  
# manually re-name columns
  # NEW name               # OLD name
  rename(symptom_confusion      = confusion, 
         symptom_disorientation = disorientation, 
         symptom_personality    = personality, 
         symptom_tasks          = tasks, 
         symptom_forgetfulness  = forgetfulness)

names(alzheimer_rename_data)

# Selecting and Removing Columns of Interest

# keep only patient_id, age and diagnosis
select_columns <- alzheimer_rename_data %>% 
  select(patient_id, age, diagnosis)

head(select_columns)

# remove diagnosis and hospital
remove_columns <- alzheimer_rename_data %>%
  select(-diagnosis, -hospital)

head(remove_columns)

# ******Helper Functions*******
# everything() - Select all columns not explicitly mentioned.
# last_col() -	Select the last column in the dataset.
# where() -	Applies a function to all columns and selects those that are TRUE.
# contains("string") -	Select columns that contain a specified character string.
# starts_with("prefix") -	Select columns that start with a specified prefix.
# ends_with("suffix") -	Select columns that end with a specified suffix.
# any_of("cols") -	Select columns if they exist, but returns no error if not found.

# keep only columns related to symptoms, along with patient_id.
symptom_data <- alzheimer_rename_data %>%
  select(patient_id, contains("symptom"))

head(symptom_data)

# Reorder columns in a specific way - use select() and list column names in desired order
symptom_data <- symptom_data %>%
  select(
    patient_id, symptom_confusion, symptom_disorientation,
    symptom_forgetfulness, symptom_personality, symptom_tasks
  )

head(symptom_data)

#**********CONVERTING and RE_CODING VARIABLES**********

# using parse_number() function to CONVERT age variable (chr) into numeric type.
alzheimer_data_recoded <- alzheimer_rename_data %>% 
  mutate(new_age = parse_number(age))

#View and verify
head(alzheimer_data_recoded %>% 
       select(age, new_age))

str(alzheimer_data_recoded$new_age)

# RE-WRITING original age data with numeric age data
alzheimer_data <- alzheimer_rename_data %>%
  mutate(age = parse_number(age))

str(alzheimer_data_recoded$age)

#*******RE-CODING VARIABLES********

# re-coding gender variable from 0/1 to Male/Female for intuitive reading
alzheimer_data_recoded <- alzheimer_data %>%
  mutate(
    gender = recode(gender, `0` = "Male", `1` = "Female")
  )
# Verify changes using Table function
# old gender data
table(alzheimer_data$gender)
# re-coded gender data
table(alzheimer_data_recoded$gender)

#Doing same to re-code Ethnicity with "Caucasian" -> "European descent" 
alzheimer_data_recoded2 <- alzheimer_data_recoded %>%
  mutate(
    ethnicity = recode(ethnicity, `0` = "european_descent", `1` = "african_american", '2' = "Asian", '3' = "Other")
  )
str(alzheimer_data_recoded2$ethnicity)

#Re-writing original data with re-codes
alzheimer_data <- alzheimer_data_recoded2 %>%
  mutate(ethnicity = recode(ethnicity, `0` = "european_descent", `1` = "african_american", '2' = "Asian", '3' = "Other")
  )

str(alzheimer_data$ethnicity)
str(alzheimer_data$age)
str(alzheimer_data$gender)

#***************ADDING COLUMNS to Dataset***************

# Creating New Column for AGE CATEGORY
# cut(age, ...) turns numeric age into categories
alzheimer_data <- alzheimer_data %>% mutate(
  age_cat = cut(
    age,
    breaks = c(59, 70, 80, 90), # define breakpoints
    labels = c("60-70", "71-80", "81-90") # define labels
  )
)
#Verify - show first 10 results
head(alzheimer_data %>% 
       select(age, age_cat), 10)

#Verify - show 10 results filtered to only 70 and 71 y/o
head(alzheimer_data %>% 
       filter(age %in% c(70, 71)) %>% 
       select(age, age_cat), 10)

# Inspect the distribution of age and age_cat with table().
table(alzheimer_data$age_cat,   alzheimer_data$age) 


#********INSPECT AND REMOVE DUPLICATES******

# check if there are duplicates
nrow(unique(alzheimer_data)) == nrow(alzheimer_data)

# view duplicated rows - show only first 5 rows and columns
duplicates <- alzheimer_data[duplicated(alzheimer_data), ]
head(duplicates, n = c(5, 5))

# Remove Duplicates 
# Use distinct() function to return new data frame with duplicates removed
alzheimer_data <- alzheimer_data %>%
  # remove duplicates
  distinct() 

# Check row count after duplicates removed
nrow(alzheimer_data)


#********SAVE AND EXPORT DATA SET****************
# save the clean Alz data as its own data frame for clarity
alzheimers_data_clean <- alzheimer_data

# export to the root of your R project folder
export(alzheimers_data_clean, "alzheimers_data_clean.csv")

# export to a subfolder called 'data-export' in your root R project folder
export(alzheimers_data_clean, here("data", "alzheimers_data_clean.csv"))


#**********GROUPING AND SUMMARIZING DATA*************

#GROUP by SINGLE Variable
#Use the dplyr function group_by() function to group alzheimer_data by gender.
grouped_data_gender <- alzheimer_data %>%
  group_by(gender)

grouped_data_gender #shows that there are 2grps but data doesn't change

#SUMMARTIZE Groups
# dplyr function summarize() collapses each group to single row of computed values
grouped_data_gender <- alzheimer_data %>%
  group_by(gender) %>% 
  summarize(count = n()) # e.g., count of records by gender
grouped_data_gender

#GROUP & SUMMARIZE by MULTIPLE Variables (e.g.,for Crosstabs later)
grouped_data_gender <- alzheimer_data %>% 
  group_by(gender, diagnosis) %>% 
  summarize(count = n())
grouped_data_gender

# Additional Summary Functions - used alongside summarize()
grouped_data_gender <- alzheimer_data %>% 
  group_by(gender, diagnosis) %>% 
  summarize(avg_mmse = mean(mmse)) #shows mean score across grps in new column
grouped_data_gender

# ADDING COUNTS by Group to Dataset
# add_count() function adds count of obs for each grp directly in data set
alzheimer_data_with_counts <- alzheimer_data %>%
  add_count(hospital)

head(alzheimer_data_with_counts %>%
       select(patient_id, n, hospital, age, gender, ethnicity))


#***************CREATING DATA TABLES********************

# Enhancing Data Tables with adorn_ Functions

#adorn_totals(): Adds totals for rows or columns in a data frame.
#adorn_title(): Adds titles to your tables for clarity.
#adorn_percentages(): Converts counts to percentages for easier interpretation.

#CREATE CROSS TABLE with counts and % by gender and dx for the Alz dataset
gender_diagnosis_summary <- alzheimer_data %>%
  # cross-tabulate counts of gender and diagnosis
  tabyl(gender, diagnosis) %>%
 
   # add a row for total
  adorn_totals(where = "row") %>%
 
   # convert to proportions (decimals) with column denominator
  adorn_percentages(denominator = "col") %>% 
 
   # convert proportions to percentages 
  adorn_pct_formatting() %>%
 
   # display as: "count (percent)" 
  adorn_ns(position = "front") %>% 
 
   # adjust titles
  adorn_title(
    row_name = "Gender", 
    col_name = "Diagnosis"
  ) 
gender_diagnosis_summary


#**************BINDING COLUMNS**************

#bind_cols() places tables side-by-side and matches rows by their order
#bind_rows() stacks tables and matches columns by name
#Both assume the datasets are already aligned

# **Demonstrating bind_cols() by creating & binding two small data sets***

#Create FIRST summary table with the number of pts and % of Alz dx by hospital
hospital_summary <- alzheimer_data %>% 
  group_by(hospital) %>%
  summarize( 
    count = n(),
    percent = mean(diagnosis == 1) * 100
  )
hospital_summary

#Create 2ND table with the number of doctors and nurses at each hospital
hospital_data <- data.frame(
  hospital = c("Hospital A", "Hospital B", "Hospital C", 
               "Hospital D", "Hospital E", "Hospital F"),
  doctors = c(10, 15, 8, 12, 9, 11),
  nurses = c(20, 25, 15, 22, 18, 24)
)
hospital_data

# BIND TABLES SIDE-BY-SIDE - to add info about docs/nurses to hospital summary
hospital_staff <- bind_cols(hospital_summary, hospital_data)
hospital_staff

# Dropping duplicate hospital columns
hospital_staff2 <- hospital_staff %>%
  select(-hospital...4)
hospital_staff2

# Re-naming Hospital title
hospital_staff <- hospital_staff2 %>%
  rename(hospital = hospital...1)
hospital_staff


#**************BINDING ROWS**************
#Useful if receiving data set with new rows of data in same column structure 

#Creating NEW DATA FRAME for hospital summary data on 2 new hospitals
#IMPORTANT to ensure column structure is identical 
new_hospitals <- data.frame(
  hospital = c("Hospital G", "Hospital H"),
  count    = c(375, 415),
  percent  = c(40.2, 35.7),
  doctors  = c(7, 9),
  nurses   = c(12, 15)
)
new_hospitals

# bind_rows() stacks the tables vertically, matching columns by name:
hospital_staff_new <- bind_rows(hospital_staff, new_hospitals)
hospital_staff_new


#************JOINING DATASETS****************

#left_join - All rows from left data frame, matched rows from right data frame
#right_join - All rows from right data frame, matched rows from left data frame
#full_join - All rows from both data frames, fill NAs where available
#inner_join - Only matched rows from both data frames
#semi_join - Rows from L data with matches in R data frame;only col from L returned
#anti_join - Rows from L data without matches in R data frame;only col from L

#General syntax: result <- join(data_1, data_2, by = "key")

#Create data set 1 (Hospital-Dx data set)
hospital_dx <- data.frame(
  patient_id = 1:6,
  hospital_id = c("A", "C", "C", "A", "B", "A"),
  date_dx = as.Date(c("2024-01-01", "2024-01-02", "2024-01-03", "2024-01-04", "2024-01-05", "2024-01-06"))
  )
hospital_dx

#Create data set 2 (Pt Tx data set)
treatments <- data.frame(
  patient_id = c(1, 2, 3, 7, 8),
  treatment_type = c("CST", "AChE", "CST", "AChE", "AChE")
)
treatments

# ****LEFT JOIN***
left_result <- left_join(
  hospital_dx, treatments,  #(left, right)
  by = "patient_id" #key
) 
left_result 

# ****RIGHT JOIN***
right_result <- right_join( 
  hospital_dx, treatments, #(left, right)
  by = "patient_id" # key
) 
right_result

# ****FULL JOIN***
full_result <- full_join(
  # left    # right
  hospital_dx, treatments,
  by = "patient_id" # key
)
full_result

# ****INNER JOIN***
inner_result <- inner_join(
  # left     # right 
  hospital_dx, treatments,
  by = "patient_id" # key
) 
inner_result 

# ****SEMI JOIN***
semi_result <- semi_join(
  # left    # right 
  hospital_dx, treatments,
  by = "patient_id" # key
) 
semi_result 

# ****ANTI JOIN*** (useful for examining people with missing data somewhere else)
anti_result <- anti_join(
  # left    # right 
  hospital_dx, treatments, 
  by = "patient_id" # key
) 
anti_result

#Switching data set positions
anti_result <- anti_join(
  # left    # right 
  treatments, hospital_dx,
  by = "patient_id" # key
) 
anti_result


#****************DATA RESHAPING/PIVOTING  - WIDE TO LONG FORMAT******************

#Wide format keeps each variable in own column
#Long format combines variables into two columns: 1 for Variable name, 1 for Value

#long format is what most tidyverse functions expect
#most stat modeling/plotting functions assume one row per observation (long format)
#generally reshape to long, then pivot back to wide for presentation/reporting

#pivot_longer() from tidyr is used to convert wide data into long format
#has 3 main arguments:
#cols specifies which columns to pivot;can list explicitly or use tidyselect helpers (eg. starts_with("diagnosis"))
#names_to defines the name of the new column that will hold the old column names
#values_to defines the name of the new column that will hold the values


#Create Data set for Pivot Longer example
patient_data <- tibble(
  patient_id     = c(1, 2, 3),
  age            = c(65, 70, 55),
  diagnosis_2019 = c("Mild", "Severe", "Mild"),
  diagnosis_2020 = c("Severe", "Severe", "Moderate"),
  diagnosis_2021 = c("Moderate", "Severe", "Moderate")
)
patient_data

#Applying pivot to longer
patient_data_long <- patient_data %>% 
  pivot_longer(
    cols = starts_with("diagnosis"), 
    names_to = "year",
    values_to = "diagnosis"
  )
patient_data_long

#Cleaning value names in long data (i.e., removing"diagnosis_" from year)
#Use names_pattern function - writes what is inside parenthesis to names col 
# .* means "any characters, any length"
patient_data_long <- patient_data %>%
  pivot_longer(
    cols = starts_with("diagnosis"), 
    names_to = "year",
    values_to = "diagnosis", 
    names_pattern = "diagnosis_(.*)"
  ) 
patient_data_long 


#****************DATA RESHAPING/PIVOTING - LONG to WIDE FORMAT******************

#use pivot_wider() to convert long data back into wide format (e.g., for reporting)
#pivot_wider() from tidyr takes three main arguments:
#names_from - specifies the column whose values will become the new column names
#values_from - defines the column whose values will fill those new columns
#names_prefix is an optional string added in front of each new column name

#Applying pivot_wider() to long format hospital data
patient_data_wide <- patient_data_long %>%
  pivot_wider( 
    names_from = year,
    values_from = diagnosis, 
    names_prefix = "diag_"
  ) 
patient_data_wide 


#*****************Combined Example - Pivoting and Joining*************

# want to add lab test results from another dataset called lab_test to Long data

#Create lab data
lab_test <- data.frame(
  patient_id = c(1, 1, 1, 2, 2, 2, 3, 3, 3),
  year = c('2019', '2020', '2021', '2019', '2020', '2021',
           '2019', '2020', '2021'),
  lab_results = sample(0:100, 9, replace = TRUE)
)
lab_test

#Combine lab data with Long patient data set
combined_data <- left_join(
  patient_data_long, lab_test,
  by = c("patient_id", "year")
)
combined_data

#Pivoting back to wide format adding lab results requires additional argument
#names_glue: creates column names that combines original var name (dx/lab) with yr
#{.value} represents each of the values in the values_from argument (here, dx/lab)
#{year} represents the values in the names_from column (year)
#The . in {.value} indicates that each var in values_from should be combined with
#each unique value in names_from to create distinct column names.

combined_data_wide <- combined_data %>%
  pivot_wider( 
    names_from = year,
    values_from = c(diagnosis, lab_results),
    names_glue = "{.value}_{year}"
  )
combined_data_wide


