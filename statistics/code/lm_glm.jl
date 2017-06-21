using DataFrames
using GLM

cd("/Users/pstey/projects_code/julia_tutorials/statistics/code")
ckd = readtable("../data/chronic_kidney_disease.csv")

fm1 = lm(@formula(blood_pressure ~ 1 + age), ckd)    # fit linear model regressing BP on age

coef(fm1)                         # get model coefficients (i.e., Betas)
stderr(fm1)                       # standard error of coefficients
confint(fm1)                      # confidence intervals for coefficients
predict(fm1)                      # predicted value for each observation (i.e., y_hat)
residuals(fm1)                    # residuals (i.e., y - y_hat)

# fit indices
deviance(fm1)
aic(fm1)
bic(fm1)

# make predictions with fitted model
new_data = DataFrame(age = [10, 20, 30, 40, 50])

predict(fm1, new_data)

# Adding predictors
fm2 = lm(@formula(blood_pressure ~ 1 + age + hemoglobin), ckd)      # add hemoglobin as predictor

# Adding interaction terms
fm4 = lm(@formula(blood_pressure ~ 1 + age + serum_creatinine + age*serum_creatinine), ckd)


## Binomial Logistic Regression
dia = readtable("../data/diabetic_data.csv", nastrings = ["?"], makefactors = true)

# Some variables need recoding to map numerical codes to meaning
code_vals = readtable("../data/IDs_mapping.csv")


# Write function to perform re-coding
function recode!(dat::DataFrame, col::Symbol, lookup::Dict)
    n = nrow(dat)
    new_col = DataArray{String, 1}(repeat([""], inner = n))
    for i = 1:n
        if !isna(new_col[i])
            new_col[i] = lookup[dat[i, col]]
        else
            new_col[i] = NA
        end
    end
    dat[col] = pool(new_col)
end

# Create lookup dictionaries for recoding
admiss_typ_lookup = Dict((parse(code_vals[i, 1]), code_vals[i, 2]) for i = 1:8)
dischar_lookup = Dict((parse(code_vals[i, 1]), code_vals[i, 2]) for i = 11:40)
admiss_src_lookup = Dict((parse(code_vals[i, 1]), code_vals[i, 2]) for i = 43:67)

recode!(dia, :admission_type_id, admiss_typ_lookup)
recode!(dia, :discharge_disposition_id, dischar_lookup)
recode!(dia, :admission_source_id, admiss_src_lookup)

dia[:readmitted] = [x == "<30" ? 1 : 0 for x in dia[:readmitted]]

fm5 = glm(@formula(readmitted ~ 1 + admission_type_id), dia, Binomial())          # defaults to logit-link
display(fm5)

coef(fm5)
stderr(fm5)
confint(fm5)

# Fit indices
deviance(fm5)
aic(fm5)
bic(fm5)


## Poisson Regression
fm6 = glm(@formula(num_procedures ~ 1 + admission_type_id + time_in_hospital), dia, Poisson())  # defaults to log link

display(fm6)

display(fm6)
coef(fm6)
stderr(fm6)
confint(fm6)
deviance(fm6)
aic(fm6)
bic(fm6)
