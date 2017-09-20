# type_basics.jl


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
