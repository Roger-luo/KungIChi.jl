using KungIChi
using Documenter

DocMeta.setdocmeta!(KungIChi, :DocTestSetup, :(using KungIChi); recursive=true)

makedocs(;
    modules=[KungIChi],
    authors="Roger-Luo <rogerluo.rl18@gmail.com> and contributors",
    repo="https://github.com/Roger-luo/KungIChi.jl/blob/{commit}{path}#{line}",
    sitename="KungIChi.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Roger-luo.github.io/KungIChi.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Roger-luo/KungIChi.jl",
)
