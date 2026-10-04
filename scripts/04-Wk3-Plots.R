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

#import clean Alz xlsx data set from BIOS640 Wk 2.1 Exercise
alzheimer_data <- import(here("data", "alzheimers_data_clean.csv"))

#view alz data set
View(alzheimer_data)
head(alzheimer_data)

#****************CREATING GGPLOT****************

#Use ggplot() to create a blank canvas for adding layers
#Use data = in ggplot() to specify the data set
ggplot(data = alzheimer_data)

#Further layers can be added using the + symbol.
#End the command with a + to keep it open for additional layers.
#The plot renders when the final layer is added without a trailing +
ggplot(data = alzheimer_data, aes(x = age)) +
  geom_histogram()

#ADD DESIGN ELEMENTS
#color = "pink" to change the color of the border around bars
#labs() to rename the x and y axes
#theme() to resize the font of the axes text
#geom_histogram() uses 30 bins by default, can set binwidth or bins also
ggplot(data = alzheimer_data, aes(x = age)) +
  geom_histogram(color = "pink") +
  labs(x = "Age (years)") +
  theme(text = element_text(size = 12))

#**********MAPPING DATA TO AXES**********
#specify which column of data becomes x-axis and y-axis; 
#done with aes()(aesthetic) function

#Mapping One Variable to the X-Axis 
# Produces one-dimensional plot (eg histogram - counts obs along one axis)
ggplot(data = alzheimer_data, mapping = aes(x = age)) +
  geom_histogram()
#can drop argument names data = and mapping =. R matches by position (eg earlier)

#Mapping Two Variables (one to x, one to y)
#produces a two-dimensional plot (like a scatter plot):
ggplot(alzheimer_data, aes(x = age, y = mmse)) +
  geom_point()


#data = and mapping = aes() can be Inside ggplot(): inherited by every geom layer after OR
#Inside a specific geom_*(): applies only to that layer
#three code snippets below produce the same plot:

#1 all specified in ggplot() - MOST COMMON
ggplot(data = alzheimer_data, mapping = aes(x = age)) +
  geom_histogram()

#2 data in ggplot(), mapping in geom_
ggplot(data = alzheimer_data) +
  geom_histogram(mapping = aes(x = age))
#3 both in geom_
ggplot() +
  geom_histogram(data = alzheimer_data, mapping = aes(x = age))

#*******PLOT AESTHETIC************

#Aesthetics
#shape - Type of point (dot, square, triangle, star)
#fill -	Interior color (of a bar, boxplot, or filled point shape)
#color -	Exterior line or border color of a bar, boxplot, etc.; the point color for hollow shapes
#size -	Thickness of lines or size of points
#alpha -	Transparency (1 = opaque, 0 = invisible)
#binwidth -	Width of histogram bins
#width -	Width of “bar plot” columns
#linetype -	Line type (solid, dashed, dotted)

#Every geom_*() layer takes visual properties like color, fill, size, shape, and alpha. 
#Plot aesthetics can be assigned values in two ways, and where you place them determines what they do:

#1 OUTSIDE aes(): the property is a static value (e.g. color = "blue")  
#applied to every observation identically.Use to change the overall look.
ggplot(alzheimer_data, aes(x = age)) +
  geom_histogram(color = "turquoise")
#For point-based geoms, the interaction between color and fill depends on the point shape

#Eg SCATTER PLOT of MMSE against age with static blue point borders (shape 22)
ggplot(alzheimer_data, aes(x = age, y = mmse)) +
  geom_point(shape = 22, color = "blue") #
#Eg Scatter plot of MMSE against age with static blue point interiors (shape 22 with fill)
ggplot(alzheimer_data, aes(x = age, y = mmse)) +
  geom_point(shape = 22, fill = "blue")
#color sets the point's border, fill sets its interior
#only matters for shapes that have both a border and a fill.

#2 INSIDE aes(): the property is mapped to a data column (e.g. color = gender). 
#Every observation gets a value determined by its column entry. Use to distinguish groups.
#makes the aesthetic reflect a variable in the data;ggplot2 automatically produces a legend
#Eg Histogram of age grouped by gender (fill aesthetic)
ggplot(alzheimer_data, aes(x = age)) +
  geom_histogram(aes(fill = gender))

#Mapping Column Values to Point Aesthetics
#Scatter plot of age and MMSE with point fill mapped to dx groups (grouped by dx)
ggplot(alzheimer_data, aes(x = age, y = mmse)) +
  geom_point(aes(fill = diagnosis), shape = 22)

ggplot(alzheimer_data, aes(x = age, y = mmse)) +
  geom_point(aes(coulour = diagnosis), shape = 22)

#Depending on the geom_, you will use different arguments to group the data:
#With geom_point(), you will likely use color =, shape =, or size =
#With geom_bar() you are more likely to use fill =.

#SHAPES
#R has 25 built-in point shapes, identified by numbers:
#Hollow shapes (0–14) with outline determined by color; no interior.
#Filled shapes (21–24) with outline determined by color and interior determined by fill.


#**********BAR CHARTS****************

#USING GEOM-BAR())
#geom_bar() counts the number of observations in each category of a variable and draws a bar for each
#only need to map the categorical variable to x or y as ggplot2 handles the counting
#Use when  data has one row per observation and you want ggplot2 to do the counting

#eg  Bar chart of ethnicity with x = ethnicity (vertical bars)
ggplot(alzheimer_data, aes(x = ethnicity)) +
  geom_bar(fill = "steelblue", width = 0.5)

#Bar chart of ethnicity with y = ethnicity (horizontal bars).
ggplot(alzheimer_data, aes(y = ethnicity)) +
  geom_bar(fill = "forestgreen")

#geom_bar() accepts a handful of static aesthetic arguments :
#fill: the interior color of the bars (e.g., fill = "steelblue").
#color: the outline color of the bars (e.g., color = "black").
#the bar width, on a 0–1 scale. default is around 0.9

#Grouping Bar Charts by a Second Variable

#Need to ensure 2nd variable is categorical eg for binary Dx var convert to factor first
alzheimer_data <- alzheimer_data |>
  mutate(
    diagnosis = factor(
      diagnosis,
      levels = c(0, 1),
      labels = c("No", "Yes")
    )
  )

#eg Bar chart distribution of diagnosis within each ethnicity group
#Bar chart of ethnicity grouped by diagnosis, using the default position = "stack"
#Use stack when want to communicate both  total per category &  group breakdown in single view
ggplot(alzheimer_data, aes(x = ethnicity, fill = diagnosis)) +
  geom_bar()

#Alternative: position = "fill" normalizes every bar to the same height (1.0, or 100%)
#proportion of each group within each category rather than absolute counts.
#y-axis now represents a proportion, not a count
ggplot(alzheimer_data, aes(x = ethnicity, fill = diagnosis)) +
  geom_bar(position = "fill")

#Alternative: Side-By-Side Counts with position = "dodge"
#places the grouped bars side by side within each category rather than stacking them
#Each colored bar starts from the same baseline (zero)
#Use it when you want to compare group counts directly
#Eg How many participants of each ethnicity have an Alzheimer's diagnosis?
#"Yes" bars sit side by side on the same baseline
ggplot(alzheimer_data, aes(x = ethnicity, fill = diagnosis)) +
  geom_bar(position = "dodge")

#USING GEOM_COL() FOR BAR CHARTS
#geom_col() produces the same visual output as geom_bar(), but have to pass pre-computed values for bar heights
#need to summarize the data first, usually with dplyr and (for cross-tabulations) janitor::tabyl()
#USe when data is aggregated, eg a table of means, rates, or counts pulled from summary report

#Workflow - summarize the data using group_by() + summarise():
summary_ethnicity <- alzheimer_data %>%
  group_by(ethnicity) %>%
  summarize(count = n())
summary_ethnicity

#Then pass the summary to geom_col(), specifying both categorical variable (x) and pre-computed value (y):
ggplot(summary_ethnicity, aes(x = ethnicity, y = count)) +
  geom_col(fill = "steelblue")

#GROUPED geom_col() CHART
#summarized data needs to be in long format, one row per (category, group) combination
#janitor::tabyl() produces a wide two-way cross-tabulation & pivot_longer() reshapes it to long format

# prepare the data
summary_eth <- alzheimer_data %>%
  tabyl(ethnicity, diagnosis) %>%
  pivot_longer(
    cols = c("Yes", "No"),
    names_to = "diagnosis",
    values_to = "count"
  )
summary_eth

# plot grouped data by passing long summary to geom_col() and map fill to the grouping variable
ggplot(
  summary_eth,
  aes(x = ethnicity, y = count, fill = diagnosis)
) +
  geom_col(position = "dodge")

