using DataFrames
using RCall

cd("/Users/pstey/projects_code/julia_tutorials/statistics/code")


# Read in Diabetes Data
dia = readtable("../data/diabetic_data.csv", nastrings = ["?"], makefactors = true)

# Send dia dataframe to R
@rput dia

# Execute a command in R
R"mean_lab_proc <- mean(dia[, 'num_lab_procedures'])"

# Get object from R
@rget mean_lab_proc
