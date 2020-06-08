module OptimizationParameters

using DelimitedFiles
using DataStructures
using StaticArrays

"""
    OptimizationParameter{S, TX, TF, TB, DV}

The basic building block of the interface, representing one potential design
variable. `S` is a tuple with the dimensions of the underlying data and `DV`
indicates whether a design variable is activated for the variable.
"""
struct OptimizationParameter{S, TX, TF, TB, DV}
    x0::TX
    lb::TF
    ub::TF
    scaling::TF
    dv::TB
    description::String
end
Base.size(::OptimizationParameter{S, TX, TF, TB, DV}) where {S, TX, TF, TB, DV} = S
Base.eltype(::OptimizationParameter{S, TX, TF, TB, DV}) where {S, TX, TF, TB, DV} = TX

"""
    OptimizationParameter(x0; lb=-Inf, ub=Inf, scaling=1.0, dv=false, description="")

The default constructor for objects of type OptimizationParameter.  `x0`, `lb`,
`ub`, `scaling`, and `dv` may be either scalars or arrays, however, all array
inputs must have the same dimensions.
"""
function OptimizationParameter(x0; lb=-Inf, ub=Inf, scaling=1.0, dv=false, description="")

    # get all array inputs
    args = (x0, lb, ub, scaling, dv)
    idx = findall(arg->typeof(arg)<:AbstractArray, args)

    # return result if all inputs are scalars
    if isempty(idx)
        S = Tuple{1}
        TX = typeof(x0)
        TF = Float64
        TB = Bool
        DV = dv
        return OptimizationParameter{S, TX, TF, TB, DV}(x0, lb, ub, scaling, dv, description)
    end

    # otherwise check that array inputs have the same dimensions
    dims = size(args[idx[1]])
    if !(all(arg->size(arg)==dims, args[idx]))
        error("The size of all array arguments in constructor for OptimizationParameter must be identical.")
    end

    # change all scalar inputs to arrays
    args = Tuple(ifelse(typeof(arg) <: AbstractArray, arg, fill(arg, dims)) for arg in args)

    x0 = args[1]

    # ensure identical type for lb, ub, and scaling
    lb, ub, scaling = promote(args[2:4]...)

    # ensure design variable flag element type is Bool
    dv = Bool.(args[5])

    S = Tuple{dims...}
    TX = typeof(x0)
    TF = typeof(lb)
    TB = typeof(dv)
    DV = any(dv)

    return OptimizationParameter{S,TX,TF,TB,DV}(x0, lb, ub, scaling, dv, description)
end

export OptimizationParameter

# functions run outside of optimization (not performance critical)
include("external.jl")
export get_x0, get_lb, get_ub, get_scaling, get_dv, get_description
export set_x0!, set_lb!, set_ub!, set_scaling!, set_dv!, set_description!
export set_x0, set_lb, set_ub, set_scaling, set_dv, set_description
export update_parameters!, update_parameters
export update_design_variables!, update_design_variables
export assemble_input
export named_tuple_to_dict, dict_to_named_tuple

# functions run inside of optimization (performance critical)
include("internal.jl")
export get_values
export print_design_variables

# functions for working with csv files of optimization parameters
include("io.jl")
export read_parameters
export write_parameters

end # module
