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

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
