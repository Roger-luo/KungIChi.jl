struct ValidationError <: Exception
    stmt::String
    got::String
end

function Base.show(io::IO, err::ValidationError)
    print(io, "ValidationError: got ")
    printstyled(io, err.got; color=:light_green)
    print(io, " failed to validate ")
    printstyled(io, err.stmt; color=:light_cyan)
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
    F(x) || throw(ValidationError("$x does not satisfy $F"))
    return Constraint{T, F}(x)
end

struct MultipleOf{T}
    n::T
end

Base.show(io::IO, f::MultipleOf) = print(io, "multiple_of(", f.n, ")")
(f::MultipleOf)(x::Integer) = multiple_of(x, f.n)

struct SecretString <: AbstractString
    content::String
end

Base.length(s::SecretString) = length(s.content)
# do not indicate the length
Base.show(io::IO, ::SecretString) = print(io, "********")
Base.print(io::IO, ::SecretString) = print(io, "********")


struct LessThan{T}
    x::T
end

struct LessEqual{T}
    x::T
end

struct GreaterThan{T}
    x::T
end

struct GreaterEqual{T}
    x::T
end

(f::LessThan)(y) = y < f.x
(f::LessEqual)(y) = y ≤ f.x
(f::GreaterThan)(y) = y > f.x
(f::GreaterEqual)(y) = y ≥ f.x

struct Interval{L <: Union{GreaterThan, GreaterEqual}, U <: Union{LessThan, LessEqual}}
    lower::L
    upper::U
end

function interval(;gt=nothing, lt=nothing, ge=nothing, le=nothing)
    @match (gt, lt, ge, le) begin
        (nothing, nothing, nothing, nothing) => throw(ArgumentError("no boundary is specified"))
        (gt, nothing, nothing, nothing) => GreaterThan(gt)
        (nothing, lt, nothing, nothing) => LessThan(lt)
        (nothing, nothing, ge, nothing) => GreaterEqual(ge)
        (nothing, nothing, nothing, le) => LessEqual(le)

        (gt, lt, nothing, nothing) => Interval(GreaterThan(gt), LessThan(lt))
        (gt, nothing, nothing, le) => Interval(GreaterThan(gt), LessEqual(le))
        (nothing, lt, ge, nothing) => Interval(GreaterEqual(ge), LessThan(lt))
        (nothing, nothing, ge, le) => Interval(GreaterEqual(ge), LessEqual(le))

        (gt, nothing, ge, nothing) => throw(ArgumentError("duplicated upperbound: gt=$gt, ge=$ge"))
        (nothing, lt, nothing, le) => throw(ArgumentError("duplicated upperbound: lt=$lt, le=$le"))
        _ => error("case not handled")
    end
end

Base.show(io::IO, x::GreaterThan) = print(io, "(", x.x, ", ∞)")
Base.show(io::IO, x::GreaterEqual) = print(io, "[", x.x, ", ∞)")
Base.show(io::IO, x::LessThan) = print(io, "(-∞, ", x.x, ")")
Base.show(io::IO, x::LessEqual) = print(io, "(-∞, ", x.x, "]")

function Base.show(io::IO, x::Interval)
    print_interval(io, x.lower)
    print(io, ", ")
    print_interval(io, x.upper)
end

print_interval(io::IO, x::GreaterEqual) = print(io, "[", x.x)
print_interval(io::IO, x::GreaterThan) = print(io, "(", x.x)
print_interval(io::IO, x::LessThan) = print(io, x.x, ")")
print_interval(io::IO, x::LessEqual) = print(io, x.x, "]")
