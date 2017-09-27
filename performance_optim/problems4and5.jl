# Challenge Problem 4.
# The functions below read in a DataFrame object and modify
# the contents of one column based on whether or not a value
# appears in a column of a different DataFrame. The current
# performance can be improved considerably. Find a way to
# improve the performance using one (or several) of the
# techniques discussed to this point.

using Requests
using DataFrames
using StatsBase


diabetes = readtable(IOBuffer(get("https://raw.githubusercontent.com/bcbi/julia_tutorials/master/statistics/data/diabetic_data.csv").data))


display(diabetes)

dia_consent = readtable(IOBuffer(get("https://raw.githubusercontent.com/bcbi/julia_tutorials/master/performance_optim/diabetes_consent.csv").data))

# Pre-allocate column we will populate with true/false
# based on whether or not the patient has repeat visits
# and has consented to be in our study.

t1 = time()
n = nrow(diabetes)
n2 = nrow(dia_consent)
dia_consent[:include_patient] = falses(n2)

for i = 1:n
    println("Checking id: $(diabetes[i, :patient_nbr])")
    id = diabetes[i, :patient_nbr]
    row_indcs = find(diabetes[:, :patient_nbr] .== id)
    if length(row_indcs) > 1
        m = nrow(dia_consent)
        idx = 0
        for j = 1:m
            if dia_consent[j, :patient_nbr] == id
                idx = j
            end
        end
        if dia_consent[idx, :study_consent]
            dia_consent[idx, :include_patient] = true
        end
    end
end


println("elapsed: $(time() - t1)")

t2 = time()














# Challenge Problem 5.
# You are given a dataset with three columns. Column 1 has patient
# IDs. Both columns 2 and 3 have ICD-10 codes for that patient.
# Your task is to optimize the code below that generates how frequently
# each pair of ICD-10 codes co-occur.

using Combinatorics

icd = readcsv(IOBuffer(get("https://raw.githubusercontent.com/bcbi/julia_tutorials/master/performance_optim/repeat_ed_visits.csv").data))

icd_codes = vcat(icd[:, 2], icd[:, 3])
uniq_codes = unique(icd_codes)
n_codes = length(uniq_codes)

pairs = collect(combinations(uniq_codes, 2))
n_pairs = length(pairs)
pairs = hcat(zeros(Int, n_pairs))

n_patients = size(icd, 1)
cnts = zeros(Int, n_pairs)

for i = 1:n_pairs
    for j = 1:n_patients
        if pairs[i] == icd[j, 2:3]
            cnts[i] += 1
        end
    end
end
