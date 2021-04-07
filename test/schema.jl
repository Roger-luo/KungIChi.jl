using KungIChi
using Test

function multiply_by_two(y)
    @test true
    return 2y
end

@schema struct Foo
    x::Int = 1
    y::Int

    @validate function (x)
        @test true
        @assert x < 10
        return x
    end

    @validate multiply_by_two(y)

    @check multiple_of(y, 1.0)
    @check multiple_of(x, 2.0)
    @check function (x)
        x > 0
    end
end

@testset "@validate/@check" begin
    @test Foo(2, 2).y == 4
    @test_throws ValidationError Foo(1, 2)
    @test_throws ValidationError Foo(-2, 2)
end
