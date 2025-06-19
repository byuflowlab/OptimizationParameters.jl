# OptimizationParameters

[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://flow.byu.edu/OptimizationParameters.jl/dev)
[![Build Status](https://github.com/byuflowlab/OptimizationParameters.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/byuflowlab/OptimizationParameters.jl/actions/workflows/CI.yml?query=branch%3Amain)

*Convenient optimization framework parameter manipulation in Julia*

Author: Taylor McDonnell

**OptimizationParameters** provides a unified framework for managing both design variables and parameters within nonlinear optimization frameworks.

## Package Features
- Easily enable/disable design variables
- Automatically scale/descale design variables
- Use arbitrarily shaped design variables
- Customize design variable bounds and scaling
- Set up optimizations and store optimization results and parameters using simple, yet powerful, CSV files
- Access design variables by name rather than index within the optimization framework
- Perform all of these tasks with negligible overhead during the optimization

## Installation

Enter the package manager by typing `]` and then run the following:

```julia
pkg> add https://github.com/byuflowlab/OptimizationParameters.jl
```

## Usage

See the [documentation](https://flow.byu.edu/OptimizationParameters.jl/dev)
