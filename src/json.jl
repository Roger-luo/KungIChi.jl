function to_json(io::IO, x, indent; kw...)
    d = to_dict(x; kw...)
    JSON.print(io, d, indent)
end

function to_json(io::IO, x; kw...)
    d = to_dict(x; kw...)
    JSON.print(io, d)
end

function to_json(filename::String, x, xs...; kw...)
    d = to_dict(x; kw...)
    open(filename, "w+") do io
        JSON.print(io, d, xs...)
    end
end

function to_json(x, xs...; kw...)
    d = to_dict(x; kw...)
    JSON.json(d, xs...)
end

function from_json(::Type{T}, filename::String; kw...) where T
    is_option(T) || error("not an option type")
    d = JSON.parsefile(filename)
    d["#filename#"] = filename
    return from_dict(T, d; kw...)
end

function from_json(::Type{T}, io::IO; kw...) where T
    is_option(T) || error("not an option type")
    d = JSON.parse(io)
    return from_dict(T, d; kw...)
end
