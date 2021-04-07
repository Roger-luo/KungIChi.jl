module OpenAPI

using Configurations: Maybe
using ..KongYiji: @schema

# TODO:
# implement customize lowering
# to generate the key $ref
@schema struct Reference
    ref::String
end

@schema struct Contact
    name::Maybe{String} = nothing
    url::Maybe{String} = nothing
    email::Maybe{String} = nothing
end

@schema struct License
    name::String
    url::Maybe{String} = nothing
end

@schema struct Info
    title::String
    description::Maybe{String} = nothing
    termsOfService::Maybe{String} = nothing
    contact::Maybe{Contact} = nothing
    license::Maybe{License} = nothing
    version::String
end

@schema struct ServerVariable
    enum::Maybe{Vector{String}} = nothing
    default::String
    description::String

    # @check !isempty(enum)
end

@schema struct Schema
end

@schema struct Response
end

@schema struct Parameter
end

@schema struct Example
end

@schema struct RequestBody
end

@schema struct Header
end

@schema struct SecurityScheme
end

@schema struct Link
end

@schema struct Callback
end

@schema struct Operation
end

@schema struct Server
    url::Maybe{String} = nothing
    description::Maybe{String} = nothing
    variables::Maybe{Dict{String, ServerVariable}} = nothing
end

@schema struct PathItem
    ref::String
    summary::Maybe{String} = nothing
    description::Maybe{String} = nothing
    get::Operation
    put::Operation
    post::Operation
    delete::Operation
    options::Operation
    head::Operation
    patch::Operation
    trace::Operation
    servers::Vector{Server}
    parameters::Vector{Parameter}
end

@schema struct Components
    schemas::Maybe{Dict{String, Schema}} = nothing
    responses::Maybe{Dict{String, Response}} = nothing
    parameters::Maybe{Dict{String, Parameter}} = nothing
    examples::Maybe{Dict{String, Example}} = nothing
    requestBodies::Maybe{Dict{String, RequestBody}} = nothing
    headers::Maybe{Dict{String, Header}} = nothing
    securitySchemes::Maybe{Dict{String, SecurityScheme}} = nothing
    links::Maybe{Dict{String, Link}} = nothing
    callbacks::Maybe{Dict{String, Callback}} = nothing
end

@schema struct Security
end

@schema struct Tag
end

@schema struct ExternalDocumentation
end

# TODO:
# custom lowering/parsing
@schema struct Paths
    path::String
    item::PathItem
end

@schema struct OpenAPIObject
    openapi::VersionNumber
    info::Info
    servers::Vector{Server}
    paths::Vector{Paths}
    components::Components
    security::Security
    tags::Vector{Tag}
    externalDocs::Vector{ExternalDocumentation}
end

end
