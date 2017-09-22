# type_system.jl
using DataFrames

# Type-Stable functions
function strip_first_char(s)
    if isna(s)
        res = NA
    else
        res = s[2:end]
    end
    res
end


function strip_first_char2(s::String)
    res = s[2:end]
    res
end


function strip_first_char2(s::NAtype)
    res = NA
    res
end


function strip_char_column!(v)
    n = length(v)
    for i = 1:n
        v[i] = strip_first_char(v[i])
    end
end


function strip_char_column2!(v)
    n = length(v)
    for i = 1:n
        v[i] = strip_first_char2(v[i])
    end
end

n = 10_000_000
words = rand(Any["a man", "a plan", "a canal", "panama", NA], n)
nums = randn(n)
df1 = DataFrame(a = words, b = nums)

@time strip_char_column2!(df1[:, 1])

@code_warntype strip_first_char2("no")
