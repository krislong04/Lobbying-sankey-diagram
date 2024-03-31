
# USTR Lobbying 2016-2020 -------------------------------------------------
  # Author: Kris Long
  # Organization: KU Trade War Lab
  # Date: March 2024
  # R version 4.3.2 Eye Holes

# Set up work space --------------------------------------------------------

#clear R

rm(list = ls())

#set working directory (this will need to change to a file on your computer)
setwd("/Users/kristopherlong/Desktop/KU/Research/Trade_War_Lab/David_help")

#load packages
library(tidyverse)
library(readxl)
library(openxlsx)

#If you get errors
### install.packages(c("tidyverse","readxl","openxlsx"))

#load data (your excel sheet might not be named this)
USTR <- read_xlsx("Copy USTR Lobbying 2016-2021.xlsx")

# Rename variables so R likes them ----------------------------------------

USTR <-
  USTR %>%
  rename(var_16 = `2016.0`)%>%
  rename(var_17 = `2017.0`)%>%
  rename(var_18 = `2018.0`)%>%
  rename(var_19 = `2019.0`)%>%
  rename(var_20 = `2020.0`)%>%
  rename(var_21 = `2021.0`)

#Drop last two rows with total and total combined
USTR <- USTR[-c(1484,1485),]

# Variable across years -------------------------

# This will create a series of variables coded that include previous years that
# we can later sum up to get your combined totals. I'm using the "case_when"
# argument in the mutate function, which is a bit like "if_else" in Python. This
# function uses a logical test to assign values to a new variable you are making
# using the mutate function. Here, I will ask it to to assign the variable a value 
# of "1" if it is true that BOTH the given year, for example 2018, has a value 
# of "1" AND the variable I have created for all previous years also has a value of
# "1". If one of these things isn't true, the variable will be coded "0". To create 
# the first variable I will just use the existing var_16 and var_17 variables. 

#2016-2017 variable

USTR  <-
  USTR %>% 
  mutate(var16_17 = case_when(var_16 == 1 & var_17 == 1 ~ 1,
                              var_16 == 0 | var_17 == 0 ~ 0))

#2016-2018 variable
USTR  <-
  USTR %>% 
  mutate(var16_18 = case_when(var16_17 == 1 & var_18 == 1 ~ 1,
                              var16_17 == 0 | var_18 == 0 ~ 0))

#2016-2019 variable
USTR  <-
  USTR %>% 
  mutate(var16_19 = case_when(var16_18 == 1 & var_19 == 1 ~ 1,
                              var16_18 == 0 | var_19 == 0 ~ 0))

#2016-2020 variable
USTR  <-
  USTR %>% 
  mutate(var16_20 = case_when(var16_19 == 1 & var_20 == 1 ~ 1,
                              var16_19 == 0 | var_20 == 0 ~ 0))

#2016-2021 variable
USTR  <-
  USTR %>% 
  mutate(var16_21 = case_when(var16_20 == 1 & var_21 == 1 ~ 1,
                              var16_20 == 0 | var_21 == 0 ~ 0))


# Sums --------------------------------------------------------------------
# Now, we can sum up the variables and see how many companies continue from
# year to year. I've assigned them to objects here so they live in my environment,
# which saves me time because I don't have to scroll up on the R console or rerun 
# the code if I forget a value. 

# Here is what I found:
  # In 2016, 482 organizations lobbied
  # 356 of them lobbied again in 2017
  # 243 continued to 2018
  # 213 continued to 2019
  # 179 continued to 2020
  # 156 lobbied every year (2016-2021)

year_2016 <- sum(USTR$var_16)

range2016_2017 <- sum(USTR$var16_17)

range2016_2018 <- sum(USTR$var16_18)

range2016_2019 <- sum(USTR$var16_19)

range2016_2020 <- sum(USTR$var16_20)

range2016_2021 <- sum(USTR$var16_21)


# Add final row -----------------------------------------------------------

Total <- data.frame(
  Organizations = "Total",
  var_16 = sum(USTR$var_16),
  var_17 = sum(USTR$var_17),
  var_18 = sum(USTR$var_18),
  var_19 = sum(USTR$var_19),
  var_20 = sum(USTR$var_20),
  var_21 = sum(USTR$var_21),
  var16_17 = range2016_2017,
  var16_18 = range2016_2018,
  var16_19 = range2016_2019,
  var16_20 = range2016_2020,
  var16_21 = range2016_2021
)

USTR <- rbind(USTR, Total)
  


# Further data stuff ------------------------------------------------------

# If you want to know, for example, the names of organizations that lobbied from 
# 2016 all the way to 2021, you can use the subset function.
  # USTR_2 <- subset(USTR, var16_21 == 1)
  # USTR_2$Organizations



# Save new excel file -----------------------------------------------------

#This will be saved in your working directory
write.xlsx(USTR, "USTR totals across years.xlsx")



