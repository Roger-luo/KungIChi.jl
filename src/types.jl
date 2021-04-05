struct ValidationError <: Exception
    msg::String
end

struct Constraint{T, F}
    x::T
end

function Base.show(io::IO, con::Constraint{T, F}) where {T, F}
    show(io, con.x)
    printstyled(io, " #=", F, "=#"; color=:light_black)
end

const Positive{T} = Constraint{T, >(0)}
const Negative{T} = Constraint{T, <(0)}

for N in [16, 32, 64]
    PF = Symbol(:PositiveF, N)
    NF = Symbol(:NegativeF, N)
    F = Symbol(:Float, N)

    @eval begin
        export $PF, $NF
        const $PF = Positive{$F}
        const $NF = Negative{$F}
    end
end

for N in [8, 16, 32, 64, 128]
    PI = Symbol(:PositiveI, N)
    NI = Symbol(:NegativeI, N)
    I = Symbol(:Int, N)

    @eval begin
        export $PI, $NI
        const $PI = Positive{$I}
        const $NI = Negative{$I}
    end
end

function Base.convert(::Type{Constraint{T, F}}, x) where {T, F}
    F(x) || throw(ValidationError("validation failed: $x does not satisfy $F"))
    return Constraint{T, F}(x)
end

struct MultipleOf{T <: Integer}
    n::T
end

Base.show(io::IO, f::MultipleOf) = print(io, "multiple_of(", f.n, ")")
(f::MultipleOf)(x::Integer) = iszero(rem(x, f.n))

struct SecretString <: AbstractString
    content::String
end

Base.length(s::SecretString) = length(s.content)
# do not indicate the length
Base.show(io::IO, ::SecretString) = print(io, "********")
Base.print(io::IO, ::SecretString) = print(io, "********")
