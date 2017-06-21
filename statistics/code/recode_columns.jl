using DataFrames

# Set working directory
cd("/Users/pstey/projects_code/julia_tutorials/statistics/code")


dia = readtable("../data/diabetic_data.csv", nastrings = ["?"], makefactors = true)


# Some variables need recoding to map numerical codes to meaning
code_vals = readtable("../data/IDs_mapping.csv")

showall(code_vals)

# Write function to perform re-coding
function recode!(dat::DataFrame, col::Symbol, lookup::Dict)
    n = nrow(dat)
    new_col = DataArray{String, 1}(repeat([""], inner = n))
    for i = 1:n
        if !isna(new_col[i])
            new_col[i] = lookup[dat[i, col]]
        else
            new_col[i] = NA
        end
    end
    dat[col] = pool(new_col)
end


# Create lookup dictionaries for recoding
admiss_typ_lookup = Dict((parse(code_vals[i, 1]), code_vals[i, 2]) for i = 1:8)
dischar_lookup = Dict((parse(code_vals[i, 1]), code_vals[i, 2]) for i = 11:40)
admiss_src_lookup = Dict((parse(code_vals[i, 1]), code_vals[i, 2]) for i = 43:67)

recode!(dia, :admission_type_id, admiss_typ_lookup)
recode!(dia, :discharge_disposition_id, dischar_lookup)
recode!(dia, :admission_source_id, admiss_src_lookup)
