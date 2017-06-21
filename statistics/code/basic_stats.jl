using DataFrames
using Distributions
using HypothesisTests

cd("/Users/pstey/projects_code/julia_tutorials/statistics/code")
include("../utils/plot_utils.jl")


# Read in Diabetes Data
dia = readtable("../data/diabetic_data.csv", nastrings = ["?"], makefactors = true)

mean(dia[:num_medications])
median(dia[:num_medications])
mode(dia[:num_medications])
std(dia[:num_medications])
var(dia[:num_medications])
minimum(dia[:num_medications])
maximum(dia[:num_medications])



## Binomial Test
gender = dropna(dia[:gender])
is_female = gender .== "Female"                  # cast x to vector of Booleans
display(BinomialTest(is_female, 0.5))            # test null hypothesis that p = 0.5



## T-test
# Life Expectancy Example:
# Simulate data from Gaussian, test whether smokers
# and non-smokers have same life expectancy
non_smokers_gaussian = Normal(72, 7)
smokers_gaussian = Normal(68, 7)

srand(137)

n = 2500
non_smokers = rand(non_smokers_gaussian, n)      # n random draws from Gaussian
smokers = rand(smokers_gaussian, n)

display(EqualVarianceTTest(smokers, non_smokers))         # two-sample t-test (assumes eq. var)

hist2(smokers, non_smokers)




## Pearson correlation
n = 1000
x = randn(n)
y = 1.5x .+ randn(n)

scatterplot(x, y)


cor(x, y)

# pairwise correlation of all variables in a matrix
A = randn(100, 5)
cor(A)
