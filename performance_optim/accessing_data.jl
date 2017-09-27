using BenchmarkTools


function row_means(X)
    n = size(X, 1)
    res = zeros(n)
    for i = 1:n
        res[i] = mean(X[i, :])
    end
    return res
end


function row_means2(X)
    n = size(X, 1)
    res = zeros(n)
    for i = 1:n
        res[i] = mean(view(X, i, :))
    end
    return res
end


A = randn(1_000_000, 1000)

@time row_means(A)
@time row_means2(A)
