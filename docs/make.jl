using Documenter
using OptimizationParameters

makedocs(
    sitename = "OptimizationParameters",
    pages = [
        "Home" => "index.md",
        "Example" => "example.md",
        "Library" => "library.md"
    ],
#    format = Documenter.HTML(),
    modules = [OptimizationParameters]
)

deploydocs(
    repo="github.com/byuflowlab/OptimizationParameters.jl.git",
)
