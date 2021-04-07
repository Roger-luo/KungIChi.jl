using KongYiji
using Test
using Expronicon

multiple_of(x, n) = isinteger(x/n)

function check_space(y)
    @info "space checked"
    return 2y
end

@schema struct Foo
    x::Int = 1
    y::Int

    @validate function (x)
        @assert x < 10
        return x
    end

    @validate check_space(y)

    @check multiple_of(y, 1.0)
    @check multiple_of(x, 2.0)
    @check function (x)
        x > 0
    end
end

d = Foo(2, 2) |> to_dict

to_json(Foo(2, 2))
Foo(-2, 2)

funcs, validate_calls, checker_calls, msg = KongYiji.split_validate_fn(def)

funcs
validate_calls

KongYiji.codegen_ast_validate_fn(def)

throw(KongYiji.ValidationError("x > 1"))

interval(gt=1)
interval(ge=1)
interval(le=1)
interval(lt=1)

interval(gt=1, le=2)
interval(gt=1, lt=2)
interval(ge=1, lt=2)
interval(ge=1, le=2)

ex = @macroexpand @option struct Foo{T}
    x::Constraint{T, LessThan(2)}
end
Expronicon.print_ast(stdout, prettify(ex))

def = @expr JLKwStruct struct Foo{T}
    x::Constraint{T, LessThan(2)}
end

Expronicon.uninferrable_typevars(def)

using Expronicon

Foo(x=1)
prettify(ex)

struct Goo{T}
    x::Constraint{T, LessThan(2)}
end

def = @expr JLKwStruct struct Poo
    x::Constraint{Int, LessThan(2)} = 1.0
    y::Int

    @validate function (x)
        1 < x < 2
        return 2x
    end

    @validate function (x, y)
       sum(x) == 1 || error("test") 
       1 < y < 10 || error("test")
       x + y < 8 || error("test")
       return x, 2y
    end
end

def.misc
using MLStyle
function codegen_ast_validate_fn(def::JLKwStruct)
    validate_fns = []
    misc = []
    for each in def.misc
        @switch each begin
            @case Expr(:macrocall, Symbol("@validate"), line, body)
                push!(validate_fns, JLFunction(body))
            @case _
                push!(misc, each)
        end
    end
    def.misc = misc
    return validate_fns
end

codegen_ast_validate_fn(def)



Poo(1.0)


struct Foo{T}
    x::Constraint{T, LessThan(2)}
end

Foo|>methods

struct Moo
    x::Constraint{Int, LessThan(2)}
end

methods(Moo)

struct Foo2{T}
    x::T
end
methods(Foo2)

struct Foo3{T}
    x::NTuple{2, T}
end
methods(Foo3)
Foo3((2, 2))

struct Foo4{T}
    x::Foo2{T}
end
methods(Foo4)

Foo4(2)