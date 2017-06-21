using DataFrames
using DecisionTree
using StatsBase

cd("/Users/pstey/projects_code/julia_tutorials/statistics/code")

ckd = readtable("../data/chronic_kidney_disease.csv")

# Specify columns we want to keep
cols = [:age,
        :blood_pressure,
        :specific_gravity,
        :albumin,
        :sugar,
        :blood_glucose_random,
        :blood_urea,
        :serum_creatinine,
        :sodium,
        :potassium,
        :hemoglobin,
        :packed_cell_volume,
        :white_blood_cell_count,
        :red_blood_cell_count,
        :class]


## Part 1: Using list-wise deletion to eliminate data with
ckd_subset_cmpl = ckd[:, cols]
completecases!(ckd_subset_cmpl)

## Fitting Random Forest
# Cast data to numeric arrays
labels = convert(Array{Int,1}, map(x -> x == "ckd" ? 1 : 0, ckd_subset_cmpl[:class]))
features = convert(Array, ckd_subset_cmpl[:, 1:(end - 1)])


## Split data into training and test set
srand(137)                                 # set seed for random num generator
n_total = nrow(ckd_subset_cmpl)
n_train = round(Int, 0.7 * n_total)
train = sample(1:n_total, n_train, replace = false)
test = setdiff(1:n_total, train)

labels_trn = labels[train]
labels_tst = labels[test]

features_trn = features[train, :]
features_tst = features[test, :]


# Run n-fold cross validation for forests using 6 random
# features_trn, 100 trees, and 5 folds.
acc1 = nfoldCV_forest(labels_trn, features_trn, 6, 100, 5)

# Build forest with meta-parameters we like from CV above
fm1 = build_forest(labels_trn, features_trn, 6, 100, 5)

yhat1 = apply_forest(fm1, features_tst)
fm1_acc = mean(yhat1 .== labels_tst)



## PART 2a: Using random forests with hot-deck-imputed data
function hotdeck(x)
    non_na = [!isna(z) for z in x]
    vals = x[non_na]
    shuffle!(vals)
    xnew = similar(x)
    n = length(x)
    for i = 1:n
        xnew[i] = isna(x[i]) ? rand(vals) : x[i]
    end
    return xnew
end


function hotdeck_dataframe!(dat)
    p = ncol(dat)
    for j = 1:p
        dat[:, j] = hotdeck(dat[:, j])
    end
end

ckd_subset_imp = ckd[:, cols]

hotdeck_dataframe!(ckd_subset_imp)


# Cast data to numeric arrays
labels2 = convert(Array{Int,1}, map(x -> x == "ckd" ? 1 : 0, ckd_subset_imp[:class]))
features2 = convert(Array, ckd_subset_imp[:, 1:(end - 1)])


## Split data into training and test set
srand(137)                                 # set seed for random num generator
n_total2 = nrow(ckd_subset_imp)
n_train2 = round(Int, 0.7 * n_total2)
train2 = sample(1:n_total2, n_train2, replace = false)
test2 = setdiff(1:n_total2, train2)

labels2_trn = labels2[train2]
labels2_tst = labels2[test2]

features2_trn = features2[train2, :]
features2_tst = features2[test2, :]


# Run n-fold cross validation for forests using 6 random
# features2_trn, 100 trees, and 5 folds.
acc2 = nfoldCV_forest(labels2_trn, features2_trn, 6, 100, 5)

# Build forest with meta-parameters we like from CV above
fm2 = build_forest(labels2_trn, features2_trn, 6, 100, 5)

yhat2 = apply_forest(fm2, features2_tst)
fm2_acc = mean(yhat2 .== labels2_tst)








## PART 2b: Using random forests with mean-imputed data
function mean_impute(x)
    xmean = mean(dropna(x))
    n = length(x)
    xnew = zeros(n)
    for i = 1:n
        if isna(x[i])
            xnew[i] = xmean
        else
            xnew[i] = x[i]
        end
    end
    return xnew
end


function mean_impute_dataframe!(dat)
    p = ncol(dat)
    for j = 1:p
        dat[:, j] = mean_impute(dat[:, j])
    end
end

ckd_subset_imp = ckd[:, cols]

hotdeck_dataframe!(ckd_subset_imp)


# Cast data to numeric arrays
labels2 = convert(Array{Int,1}, map(x -> x == "ckd" ? 1 : 0, ckd_subset_imp[:class]))
features2 = convert(Array, ckd_subset_imp[:, 1:(end - 1)])


## Split data into training and test set
srand(137)                                 # set seed for random num generator
n_total2 = nrow(ckd_subset_imp)
n_train2 = round(Int, 0.7 * n_total2)
train2 = sample(1:n_total2, n_train2, replace = false)
test2 = setdiff(1:n_total2, train2)

labels2_trn = labels2[train2]
labels2_tst = labels2[test2]

features2_trn = features2[train2, :]
features2_tst = features2[test2, :]


# Run n-fold cross validation for forests using 6 random
# features2_trn, 100 trees, and 5 folds.
acc2 = nfoldCV_forest(labels2_trn, features2_trn, 6, 100, 5)

# Build forest with meta-parameters we like from CV above
fm2 = build_forest(labels2_trn, features2_trn, 6, 100, 5)

yhat2 = apply_forest(fm2, features2_tst)
fm2_acc = mean(yhat2 .== labels2_tst)




## Summary of Results
#   In this particular case, using the imputation methods seems
#   have been of not so much benefit relative to using list-wise deletion.
#   Moreover,the list-wise deletion method (e.g., Part 1) acheived
#   near-perfect prediction accuracy on the test set. This should be
#   viewed with some caution, however. The relatively small sample size,
#   should make us a bit skeptical of drawing far-reaching conclusions
#   regarding the observed differences.
