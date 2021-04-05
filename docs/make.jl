using KongYiji
using Documenter

DocMeta.setdocmeta!(KongYiji, :DocTestSetup, :(using KongYiji); recursive=true)

makedocs(;
    modules=[KongYiji],
    authors="Roger-Luo <rogerluo.rl18@gmail.com> and contributors",
    repo="https://github.com/Roger-luo/KongYiji.jl/blob/{commit}{path}#{line}",
    sitename="KongYiji.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Roger-luo.github.io/KongYiji.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Roger-luo/KongYiji.jl",
)
