using KongYiji
using Test

@testset "KongYiji.jl" begin
    # Write your tests here.
end

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
using Expronicon

Foo(x=1)
prettify(ex)

struct Goo{T}
    x::Constraint{T, LessThan(2)}
end

@option struct Poo
    x::Constraint{Int, LessThan(2)} = 1.0
    y::Int

    @validate begin
        1 < x < 2
        1 < y < 10
        x + y < 8
    end
end

Poo(1.0)
