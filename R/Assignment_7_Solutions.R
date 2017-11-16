library(readr)
library(dplyr)
library(caret)

# set working dir
setwd("/Users/alee35/Google Drive/repos/julia_tutorials/R/data/")

# read data
dia <- read_csv('diabetic_data.csv', na = '?')
map <- read_csv('IDs_mapping.csv', na = 'NULL', col_names = FALSE)

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

# check for NAs in response variable and remove
sum(is.na(dia$readmitted))
dia <- dia %>%
  filter(!is.na(readmitted))

# recode response variable
dia <- dia %>%
  mutate(readmitted = ifelse(readmitted == 'NO', 0, 1))

# remove some variables because only one factor level
dia <- dia %>%
  select(-c(citoglipton, examide))
# remove weight because ~95% missing values
dia <- dia %>%
  select(-c(weight))
# patient number and encounter id because they dont say anything about whether a patient will be readmitted
dia <- dia %>%
  select(-c(patient_nbr, encounter_id))

# plot numeric variables as histogram
ggplot(dia, aes(x = time_in_hospital, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
ggplot(dia, aes(x = num_lab_procedures, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
ggplot(dia, aes(x = num_procedures, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
ggplot(dia, aes(x = num_medications, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
ggplot(dia, aes(x = number_outpatient, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
ggplot(dia, aes(x = number_emergency, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
ggplot(dia, aes(x = number_inpatient, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
ggplot(dia, aes(x = number_diagnoses, fill = as.factor(readmitted))) +
  geom_histogram(alpha = 0.5, position = 'identity')
# none of the numeric variables appear to separate the two classes very well
# because both values of readmitted have the same distributions

# split the data into train/test
set.seed(999)
split <- createDataPartition(dia$readmitted, p = 0.6, list = FALSE)
train <- dia[split, ]
test <- dia[-split, ]

# fit a logistic regression model
glm <- glm(readmitted ~ ., train, family = binomial)
summary(glm)

# remove some insignificant variables and check how model compares to first model
# this is just an example - should do this multiple times and compare several different models
glm2 <- glm(readmitted ~ . - miglitol, data = train, family = binomial)
summary(glm2)

# final model accuracy
threshold <- 0.5

test_predictions <- data.frame(prob = predict(glm2, test, type = 'response')) %>%
  mutate(class = ifelse(prob > threshold, 1, 0))

confusion_mx <- table(test_predictions$class, test$admit)

accuracy <- function(tb) {
  acc <- (tb[1,1] + tb[2,2]) / sum(tb)
  return(acc)
}

accuracy(confusion_mx)
