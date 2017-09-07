# type system

function count_letters(x)
    res = Dict()
    n = length(x)
    for i = 1:n
        res[x[i]] = get(res, x[i], 0) + 1
    end
    res
end


function count_letters2(x)
    res = Dict{Char, Int}()
    n = length(x)
    for i = 1:n
        res[x[i]] = get(res, x[i], 0) + 1
    end
    res
end


a = rand(['a', 'b', 'c', 'd'], 50_000_000)
@time count_letters(a)
@time count_letters2(a)
