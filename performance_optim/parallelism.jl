using Base.Threads

function mult_by_threadid(n)
    res = ones(Int, n)
    @threads for i = 1:n
        res[i] = res[i] * threadid()
    end
    res
end

a = mult_by_threadid(1024)
showall(a)
