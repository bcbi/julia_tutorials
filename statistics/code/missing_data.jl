using DataFrames

cd("/Users/pstey/projects_code/julia_tutorials/statistics/code")

ckd = readtable("../data/chronic_kidney_disease.csv", makefactors = true)

"""
    mean_impute(x)
Given a vector or column from a dataframe, this function
returns a new vector where all NA values have been replaced
by the mean value of the observed data. Note that this function
is only reasonable for numeric data; missing data in categorical
variables must be handled differently.
"""
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

## Example of using mean_impute() function
ckd[:blood_pressure_cmpl] = mean_impute(ckd[:blood_pressure])


"""
    hotdeck(x)
Given a vector or column from a dataframe, this function
returns a new vector where all NA values have been replaced
by a random draw from the observed values. This is the so-called
hot-deck imputation method. Note that this works with both
categorical and contiuous values. Also note sampling is done
in such a way as to preserve the original distribution of the
observed data.
"""
function hotdeck(x)
    non_na = [!isna(z) for z in x]
    vals = x[non_na]
    suffle!(vals)
    xnew = similar(x)
    n = length(x)
    for i = 1:n
        xnew[i] = isna(x[i]) ? rand(vals) : x[i]
    end
    return xnew
end

## Example of using the hotdeck() function
ckd[:pus_cell_cmpl] = hotdeck(ckd[:pus_cell_cmpl])
