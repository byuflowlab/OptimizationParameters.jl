using Documenter
using OptimizationParameters

makedocs(;
    modules = [OptimizationParameters]
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Example" => "example.md",
        "Library" => "library.md"
    ],
    repo = "https://github.com/byuflowlab/OptimizationParameters.jl/blob/{commit}{path}#L{line}",
    sitename = "OptimizationParameters.jl",
    authors = "Taylor McDonnell <taylormcd@byu.edu>",
)

deploydocs(
    repo="github.com/byuflowlab/OptimizationParameters.jl.git",
)
