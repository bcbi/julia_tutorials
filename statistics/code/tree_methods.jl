using DataFrames
using DecisionTree
using StatsBase

cd("/Users/pstey/projects_code/julia_tutorials/statistics/code")

ckd = readtable("../data/chronic_kidney_disease.csv")

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


cols = [:age,
        :blood_pressure,
        :specific_gravity,
        :albumin,
        :sugar,
        :blood_urea,
        :serum_creatinine,
        :sodium,
        :potassium,
        :hemoglobin,
        :packed_cell_volume,
        :white_blood_cell_count,
        :red_blood_cell_count,
        :class]


ckd_subset = ckd[:, cols]

function hotdeck_dataframe!(dat)
    p = ncol(dat)
    for j = 1:p
        dat[:, j] = hotdeck(dat[:, j])
    end
end

hotdeck_dataframe!(ckd_subset)



## Fitting Random Forest
# Cast data to numeric arrays
labels = convert(Array{Int,1}, map(x -> x == "ckd" ? 1 : 0, ckd_subset[:class]))
features = convert(Array, ckd_subset[:, 1:(end - 1)])


## Split data into training and test set
srand(137)                                 # set seed for random num generator
n_total = nrow(ckd)
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


## Fitting Boosted Trees
# Cross validation for boosted stumps, using 50 iterations and 5 folds
acc2 = nfoldCV_stumps(labels_trn, features_trn, 100, 5)


fm2, coeffs = build_adaboost_stumps(labels_trn, features_trn, 100)
# apply learned model
yhat2 = apply_adaboost_stumps(fm2, coeffs, features_tst)
fm2_acc = mean(yhat2 .== labels_tst)
