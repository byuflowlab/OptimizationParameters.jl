using Documenter, OptimizationParameters

makedocs(;
    modules = [OptimizationParameters],
    format = Documenter.HTML(),
    pages = [
        "Home" => "index.md",
        "Example" => "example.md",
        "Library" => "library.md"
    ],
    sitename = "OptimizationParameters.jl",
    authors = "Taylor McDonnell <taylormcd@byu.edu>",
)

deploydocs(
    repo="github.com/byuflowlab/OptimizationParameters.jl.git",
)
