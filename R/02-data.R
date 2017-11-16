library(readr)
library(dplyr)
library(reshape2)
library(e1071)
library(caret)
library(car)

##############
# Loading Data
##############

# From CSV/TSV/Delimited files
getwd()
setwd('/Users/alee35/Google Drive/repos/julia_tutorials/R/data/')
df1 <- read.csv('mydata.csv', na.strings = c("999"))
df1 <- read_csv('mydata.csv', na = c("999"))
df2 <- read_delim('mydata.txt', delim = '\t', na = c("999"))

# From Excel
library(gdata)                  
df <- read.xls("mydata.xls")                  # read from first sheet
library(XLConnect)                
wb <- loadWorkbook("mydata.xls")              # read all sheets
df <- readWorksheet(wb, sheet="Sheet1")       # assign first seet to dataframe

# From SPSS
library(foreign)                  
df <- read.spss("mydata.sav", to.data.frame=TRUE)

# From SAS
library(sas7bdat)
df <- read.sas7bdat("mydata.sas7bdat")


#############
# dplyr verbs
#############

head(df1)
glimpse(df1)

# 5 Single Table Verbs
# - mutate() adds new variables that are functions of existing variables
# - select() picks variables based on their names
# - filter() picks observations based on their values
# - summarise() aggregates multiple values down to a summary
# - arrange() changes the ordering of the rows
# AND
# - group_by() perform any of these verbs "by group"
filter(df1, Status == "Yes")

df1 %>%
  filter(Status == "Yes") 
df1 %>%
  filter(Status == "Yes") %>%
  select(Name, Status) 
df1 %>%  
  mutate(AgeGroup = ifelse(Age > 30, "> 30", "< 30")) %>%
  arrange(Race)
df1 %>% 
  group_by(Status) %>% 
  summarise(count = n(), mean_age = mean(Age))

# Two Table Verbs
# - mutating joins: add new variables and/or new observations
#   - inner, full, left, right behave differently with observations not in common between the two tables
# - filtering joins: only affect the observations
#   - semi_join(x, y) keeps all observations in x that have a match in y
#   - anti_join(x, y) drops all observations in x that have a match in y
# - set operations: requires that x and y have same variables
#   - intersect(x, y) return only observations in both x and y
#   - union(x, y) return unique observations in x and y
#   - setdiff(x, y) return observations in x and not y
mammals <- data.frame(Name = c('whale', 'hippo', 'dog', 'horse', 'cat'),
                      Size = c('large', 'large', NA, 'large', 'small'),
                      stringsAsFactors = F)
water <- data.frame(Name = c('whale', 'hippo', 'eel', 'octopus', 'jellyfish'),
                    Size = c('large', 'large', 'small', 'small', 'small'),
                    stringsAsFactors = F)
water2 <- data.frame(Name = c('whale', 'hippo', 'eel', 'octopus', 'jellyfish'),
                     Tentacles = c(F, F, F, T, T),
                     stringsAsFactors = F)

mammals %>%
  inner_join(water2)
mammals %>%
  full_join(water2)
mammals %>%
  left_join(water2)
mammals %>%
  right_join(water2)
mammals %>%
  anti_join(water2)
mammals %>%
  semi_join(water)
mammals %>%
  anti_join(water)
# specify columns to join on
mammals %>%
  inner_join(water2, by = 'Name')

mammals %>%
  intersect(water)
mammals %>%
  union(water)
mammals %>%
  setdiff(water)
# not valid
mammals %>%
  intersect(water2)
mammals %>%
  union(water2)
mammals %>%
  setdiff(water2)


###################
# Challenge Problem
###################

# Diabetes Dataset from the Center for Clinical and Translational Research, VCU
# Available from the UCI Machine Learning Repository at:
# https://archive.ics.uci.edu/ml/datasets/Diabetes+130-US+hospitals+for+years+1999-2008#

# read data
dia <- read_csv('diabetic_data.csv', na = '?')
# map <- read_csv('IDs_mapping.csv', na = 'NULL', col_names = FALSE)

# - Calculate the total number of procedures for each patient, then get the mean nr of procs per patient
nr_procs <- dia %>%
  group_by(patient_nbr) %>%
  summarise(tot_procs = sum(num_procedures))
colMeans(nr_procs)[2]

# - Subset patient_nbrs and total number of procedures for patients who had more procedures than the mean
many_procs <- nr_procs %>%
  filter(tot_procs > colMeans(nr_procs)[2])



######################
# Preparing Dirty Data
######################

map <- read_csv('IDs_mapping.csv', na = 'NULL', col_names = FALSE)

# Problems with the data
# - ? marks as NAs
# - recode four variables
# - standardize ICD9 codes
# - dummy code categorical variables

# Recode variables
# split the variables to be recoded into three dataframes
admission_type_id <- as.data.frame(map[2:9,])
discharge_disposition_id <- as.data.frame(map[12:41,])
admission_source_id <- as.data.frame(map[44:nrow(map),])
# set column names
colnames(admission_type_id) <- c('admission_type_id', 'admission_type_id_desc')
colnames(discharge_disposition_id) <- c('discharge_disposition_id', 'discharge_disposition_id_desc')
colnames(admission_source_id) <- c('admission_source_id', 'admission_source_id_desc')
# convert code columns from character to integer
admission_type_id$admission_type_id <- as.integer(admission_type_id$admission_type_id)
discharge_disposition_id$discharge_disposition_id <- as.integer(discharge_disposition_id$discharge_disposition_id)
admission_source_id$admission_source_id <- as.integer(admission_source_id$admission_source_id)
# join the dataframes and remove variables with codes
dia <- dia %>%
  full_join(admission_type_id, by = 'admission_type_id') %>%
  select(-admission_type_id)
dia <- dia %>%
  full_join(discharge_disposition_id, by = 'discharge_disposition_id') %>%
  select(-discharge_disposition_id)
dia <- dia %>%
  full_join(admission_source_id, by = 'admission_source_id') %>%
  select(-admission_source_id)

# standardize ICD codes
dia$diag_1 <- gsub('\\.', '', dia$diag_1)
dia$diag_2 <- gsub('\\.', '', dia$diag_2)
dia$diag_3 <- gsub('\\.', '', dia$diag_3)

# convert character columns to factor
dia <- dia %>%
  mutate_if(is.character, as.factor)

# spot check and convert types
glimpse(dia)
# dia$age <- as.factor(dia$age)
# dia$medical_specialty <- as.factor(dia$medical_specialty)
# dia$`glyburide-metformin`  <- as.factor(dia$`glyburide-metformin`)
# dia$`glipizide-metformin` <- as.factor(dia$`glipizide-metformin`)
# dia$`glimepiride-pioglitazone` <- as.factor(dia$`glimepiride-pioglitazone`)
# dia$`metformin-rosiglitazone` <- as.factor(dia$`metformin-rosiglitazone`)
# dia$`metformin-pioglitazone` <- as.factor(dia$`metformin-pioglitazone`)

summary(dia)


###########
# Resources
###########

# dplyr documentation: https://www.rdocumentation.org/packages/dplyr/versions/0.5.0
# R for Data Science: http://r4ds.had.co.nz/index.html
# R Cookbook Manipulating Data: http://www.cookbook-r.com/Manipulating_data/