# type_basics.jl
using DataFrames



# Use the typeof() function to determine a variable's type
a = 42
typeof(a)

b = randn(10)
typeof(b)

c = "some words"
typeof(c)

Int64 <: Number
Real <: Number
String <: Float64
Array{Int,2} <: Any


df1 = DataFrame(a = rand(100), b = randn(100), c = rand(['x', 'y', 'z'], 100))

typeof(df1)

eltype(df1[:z])
