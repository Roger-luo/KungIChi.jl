macro schema(ex)
    schema_m(ex) |> esc
end

macro schema(typealias::String, ex)
    schema_m(ex, typealias) |> esc
end

macro validate(ex)
    error("@validate must be called inside @schema")
end

macro check(ex)
    error("@check must be called inside @schema")
end

function schema_m(ex::Expr, typealias=nothing)
    def = JLKwStruct(ex, typealias)

    has_plain_constructor(def) && return
    funcs, validate_calls, checker_calls, msgs = split_validate_fn(def)

    ret = Expr(:block)
    # generate name
    for fn in funcs
        push!(ret.args, codegen_ast(fn))
    end

    body = Expr(:block)
    for call in validate_calls
        lhs = Expr(:tuple, call.args[2:end]...)
        push!(body.args, :($lhs = $call))
    end

    for (call, msg) in zip(checker_calls, msgs)
        vars = filter(x->isa(x, Symbol), call.args[2:end])
        got = Expr(:call, :string)
        for v in vars
            push!(got.args, "$v=")
            push!(got.args, v)
        end
        push!(body.args, :($call || throw($ValidationError($msg, $got))))
    end

    fields = [f.name for f in def.fields]
    typevars = name_only.(def.typevars)
    new = isempty(def.typevars) ? :new : Expr(:curly, :new, typevars...)
    push!(body.args, Expr(:call, new, fields...))

    constructor = JLFunction(;
        name = struct_name_plain(def),
        args = fields,
        whereparams = isempty(def.typevars) ? nothing : typevars,
        body = body,
    )

    push!(def.constructors, constructor)
    push!(ret.args, Configurations.codegen_option_type(def))
    return ret
end

function split_validate_or_check(funcs, calls, msg, body)
    if is_function(body)
        fn = JLFunction(body)

        if msg !== nothing
            if fn.name === nothing
                push!(msg, string(prettify(fn.body)))
            else
                push!(msg, fn.name)
            end
        end

        fn.name = gensym(:validate)
        push!(funcs, fn)
        push!(calls, Expr(:call, fn.name, name_only.(fn.args)...))
    else
        body isa Expr && body.head === :call ||
            throw(ArgumentError("expect function definition or function call"))

        push!(calls, body)
        msg === nothing || push!(msg, string(prettify(body)))
    end
    return
end

function split_validate_fn(def::JLKwStruct)
    msg, misc, funcs, validate_calls, checker_calls = [], [], [], [], []

    for each in def.misc
        @switch each begin
            @case Expr(:macrocall, Symbol("@validate"), _, body)
                split_validate_or_check(funcs, validate_calls, nothing, body)
            @case Expr(:macrocall, Symbol("@check"), _, body)
                split_validate_or_check(funcs, checker_calls, msg, body)
            @case _
                push!(misc, each)
        end
    end
    def.misc = misc
    return funcs, validate_calls, checker_calls, msg
end
