# functions_review.jl

function add_one(x)
    res = x + 1
    return res
end


function add_something(x, a)
    res = x + a
    return res
end


function add_many_somethings(x, a)
    n = length(x)
    res = zeros(n)
    for i = 1:n
        res[i] = x[i] + a
    end
    return res
end
