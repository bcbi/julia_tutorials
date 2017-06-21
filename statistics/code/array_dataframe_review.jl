using DataFrames                        # assumes DataFrames is installed

# Set our working directory
cd("/Users/pstey/projects_code/julia_tutorials/statistics/code/")



# Vectors
v = [4, 5, 6]
u = [1.2, 4.5, 6.5]
w = ["dog", "cat", "bird"]


# Initializing vectors
a = Int[]                       # initialize empty Int vector
a2 = Array{Int, 1}()            # identical to the above
a3 = Vector{Int}()              # also identical to above


# Growing array "in place"
push!(a, 12)                    # inserts 12 in to a
push!(a, 1000)

append!(a, [9, 18, 27])         # append vector [9, 18, 27] to original `a`


# Vectors are typed
a = [3, 4, 5]                   # vector of Int64s

push!(a, 3.14)                  # FAIL: trying to push Float into vector of Ints



# Pre-Allocating vectors
x1 = zeros(Int, 10)             # create vector of ten 0s of type Int64

x2 = falses(5)                  # create vector of 5 Bool set to false

s = ["this", "is", "a string vector"]


# Accessing elements of vector
s[2]                            # get second element
s[3]                            # third element
s[1] = "that"                   # assign to first element

# Taking a slice of vector
s[1:2]                          # get subset of vector (1st and 2nd elements)
s[2:end]                        # subset from 2nd element to last element


# Indexing a vector
animals = ["dog", "cat", "fish", "mouse", "potato"]
mammals_indcs = [1, 2, 4]       # vector for indexing

animals[mammals_indcs]          # identical to `animals[[1, 2, 4]]`


# Boolean indexing
b = [1, 4, 3, 2, 4]

b .== 2
is_greater = b .> 2
display(is_greater)
display(b[is_greater])           # use vector of booleans to return subset



# Concatenating vectors
x1 = [1, 2, 3]
x2 = [4, 5, 6]

x3 = [x1; x2]                   # concatenating with [] and ;

x4 = vcat(x1, x2)               # concatenate with vcat() is same as above


# Matrices (2-D Arrays)
a = Array{Float64}(5, 3)        # initialize 5-by-3 matrix (start as 0.0)

z = zeros(5, 3)                 # same as above

b = [1 2 3;
     4 5 6;
     7 8 9]                     # semi-colon used to indicate end of row

b[3, 1]                         # gets entry in third row first column
b[2, :]                         # gets all of second row
b[:, 3]                         # gets all of third column

b2 = hcat(b, [777, 888, 999])   # add column
display(b2)
b3 = vcat(b2, [111, 222, 333, 444]')
display(b3)


# Reading array from .csv file
d = readdlm("../data/somedata.csv", ',')             # specify comma-delimited
d1 = readdlm("../data/otherdata.tsv", '\t')          # specify tab is the delimiter
d2 = readcsv("../data/somedata.csv")                 # equivalent to readdlm() with ','

d3 = readcsv("../data/somedata.csv", header = true)  # treat first line as col. heading

typeof(d3)

d3[1]                                                # 1st element in Tuple is data array
d3[2]                                                # 2nd element in Tuple is header

d4 = readcsv("../data/somedata.csv", header = true, skipstart = 3)   # skip 3 lines

d4[1]


# Working with DataFrames
df1 = readtable("../data/somedata.csv")

df1[2, 3]                               # get second row, third column
df1[4, :]                               # get all of 4th row

df1[3, :condition]                      # index with column names
df1[:condition]                         # get single column

col_subset = [:gender, :condition]      # specify columns to extract
df1[:, col_subset]                      # get subset of columns

df1[:, [:gender, :condition]]           # equivalent to above

df1[:, [3, 4]]                          # equivalent to above

is_female = df1[:gender] .== "f"        # get boolean vector indicating females

df1[is_female, :]                       # use boolean vector for subsetting

df1[df1[:gender] .== "f", :]            # equivalent to above


# Optional arguments to readtable()
df2 = readtable("../data/somedata.csv", makefactors = true)              # treat string as factors
df4 = readtable("../data/otherdata.tsv", nastrings = ["999"])            # Value `999` is coded as NA
df5 = readtable("../data/somedata.csv", nastrings = ["", "NA", "999"])   # multiple values coded as NA

# Summarized data in DataFrame
describe(df2)
