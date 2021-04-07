# KongYiji

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Roger-luo.github.io/KongYiji.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://Roger-luo.github.io/KongYiji.jl/dev)
[![Build Status](https://github.com/Roger-luo/KongYiji.jl/workflows/CI/badge.svg)](https://github.com/Roger-luo/KongYiji.jl/actions)
[![Coverage](https://codecov.io/gh/Roger-luo/KongYiji.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/Roger-luo/KongYiji.jl)

*there are four different ways to write the 回 character, do you know all of them?*

A Julia port of [pydantic](https://pydantic-docs.helpmanual.io/).
Data validation and settings management ~using python type annotations~ just work in Julia with [Configurations](https://Roger-luo.github.io/Configurations.jl). Thus this package just provide you some convenient validation tools and some sugars for defining validations. 

It reexports the interface of `Configurations`, thus you don't have to depend on `Configurations` explicitly. If you only need a lightweight setting/configuration/option definition use `Configurations`.

## Installation

<p>
KongYiji is a &nbsp;
    <a href="https://julialang.org">
        <img src="https://raw.githubusercontent.com/JuliaLang/julia-logo-graphics/master/images/julia.ico" width="16em">
        Julia Language
    </a>
    &nbsp; package. To install KongYiji,
    please <a href="https://docs.julialang.org/en/v1/manual/getting-started/">open
    Julia's interactive session (known as REPL)</a> and press <kbd>]</kbd> key in the REPL to use the package mode, then type the following command
</p>

```julia
pkg> add KongYiji
```

## License

MIT License
