library(readr)
library(dplyr)
library(reshape2)
library(e1071)
library(caret)
library(car)

x <- rnorm(100)  
y <- runif(100)


###################
# Descriptive stats
###################
mean(x)
median(x)
mode(x)
sd(x)
var(x)
min(x)
max(x)
skewness(x)      # measure of symmetry (left/right skew indicates mean!=median)
kurtosis(x)      # tail shape of distribution (thin/fat compared to standard tail of ~N(0,1))


###################
# Exploratory stats
###################
quantile(x)
IQR(x)
boxplot(x)
stem(x)
qqnorm(x)         # visual check if distribution is normal
qqline(x)         # adds line indicating theoretical normal
qqnorm(y)         
qqline(y)


#############
# Correlation 
#############
# Pearson's correlation between two variables
set.seed(1)
n = 1000
a = rnorm(n)
b = 1.5 * a + rnorm(n)

cor(a, b)
cor.test(a, b)
plot(a, b)

p <- mtcars[1:3]
q <- mtcars[4:6]
cor(p, q)


##########################################
# Linear Models - Simple Linear Regression
##########################################

# y = α + βx + ϵ
# If we choose the parameters α and β in the simple linear
# regression model so as to minimize the sum of squares of the
# error term ϵ, we will have the estimated simple regression equation.
# It allows us to compute fitted values of y based on values of x.

head(Prestige)
# fit the model
lm <- lm(income ~ education, data = Prestige)
# how good is our model? is the relationship between predictor and response significant?
# - residual standard error is an estimate of the standard deviation of the residuals
# - r squared is the coefficient of determination or how much of the variance in the data is explained by the model
# - f statistic is a ratio of the variance explained by the model parameters and the residual/unexplained variance
summary(lm)
# plot the regression line
plot(Prestige$education, Prestige$income)
abline(lm, col='red')

# diagnostic plots check model assumptions and can help fit better models
# - data are normally distributed
# - variance in y is homogeneous over all x values (homoscedasticity) 
# - a y value at a certain x value should not influence other y values (independence)
#   - transformation (log, square, etc.) on either or both variables (plots 1,3 - if there is structure)
#   - remove outliers (plot 4 - values with high leverage (upper right or lower right))
par(mfrow = c(2,2))
plot(lm)
dev.off()

# remove outliers and see how it affects the model fit
pres <- Prestige[!(row.names(Prestige) %in% c('general.managers', 'physicians')), ]
lm2 <- lm(income ~ education, data = pres)
summary(lm2)
summary(lm)

plot(pres$education, pres$income)
abline(lm, col='red')
abline(lm2, col='blue')

par(mfrow = c(2,2))
plot(lm2)
dev.off()

# Estimate the income for a job where the average years of education is 20 years
newdata <- data.frame(education = 20)
predict(lm2, newdata)
summary(pres)


############################################
# Linear Models - Multiple Linear Regression
############################################

# y = α + ∑βkxk + ϵ, where k = predictors
# predicted income = β0 + β1*education + β2*women + β3*prestige + (β4*type) + error

head(Prestige)
summary(Prestige)
lm <- lm(income ~ education + women + prestige + type, data = Prestige)
summary(lm)

# Categorical variables are dummy coded in R
contrasts(Prestige$type)
# - the reference value is blue collar and the interpretation of categorical variables in
# - regression output is the difference between the means of the contrasts
# - typeprof: the mean diff between a professional and blue collar job is $324
# - typewc: the mean diff between a white collar and blue collar job is $235

# Education is not significant, though it was significant in our simple linear model
vif(lm)
lm2 <- lm(income ~ women + prestige + type, data = Prestige)
summary(lm2)
vif(lm2)

# Check model assumptions
par(mfrow = c(2,2))
plot(lm2)
dev.off()

# Remove outliers and fit another model
lm3 <- lm(income ~ women + prestige + type, data = pres)
summary(lm3)

# Remove type because it is not significant
lm4 <- lm(income ~ women + prestige, data = pres)
summary(lm4)

# estimate the incomes for 2 jobs where prestige is the same, 85, but
# percent women is 85% in 1 job and 15% in the other.
newdata <- data.frame(women = c(85, 15), prestige = c(85, 85))
predict(lm4, newdata)


#################################################
# Generalized Linear Models - Logistic Regression
#################################################

# log(p/(1-p)) = β0 + β1*A + β2*B + β3*C2 + β4*C3
# The logistic regression coefficients give the change in the log odds of the
# outcome for a one unit increase in the predictor variable.

adm <- read_csv('admission.csv')
head(adm)
summary(adm)

# split into test and train data
set.seed(999)
split <- createDataPartition(adm$admit, p = 0.6, list = FALSE)
train <- adm[split, ]
test <- adm[-split, ]

# convert the categorical variable to a factor
train$rank <- as.factor(train$rank)
test$rank <- as.factor(test$rank)

# fit the model
glm <- glm(admit ~ gre + gpa + rank, data = train, family = "binomial")

# how well does our model fit the data? 
summary(glm)
contrasts(train$rank)
# - deviance is a measure of badness of fit
# - AIC is a measure of relative goodness of fit and can be used to compare models
#   - it is like adjusted R squared in that it penalizes adding irrelevant predictors

# remove rank
glm2 <- glm(admit ~ gre + gpa, data = train, family = "binomial")
summary(glm2)
# likelihood ratio test - should we remove rank?
# - null hypothesis: all coefficients of rank are equal to 0
anova(glm, glm2, test="LRT")

# remove gpa
glm3 <- glm(admit ~ gre + rank, data = train, family = "binomial")
summary(glm3)

# prediction and model accuracy
threshold <- 0.5
test_predictions <- data.frame(prob = predict(glm, test, type = 'response')) %>%
  mutate(class = ifelse(prob > threshold, 1, 0))
confusion_mx <- table(test_predictions$class, test$admit)
accuracy <- function(tb) {
  acc <- (tb[1,1] + tb[2,2]) / sum(tb)
  return(acc)
}
accuracy(confusion_mx)



###########
# Resources
###########

# Introduction to Prob and Stats in R: https://cran.r-project.org/web/packages/IPSUR/vignettes/IPSUR.pdf