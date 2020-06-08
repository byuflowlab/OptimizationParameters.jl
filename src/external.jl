# functions designed to be used outside the optimization

# get functions
"""
    get_x0(optparam::OptimizationParameter)

Returns initial value(s) for `optparam`
"""
get_x0(optparam::OptimizationParameter) = optparam.x0

"""
    get_lb(optparam::OptimizationParameter)

Returns lower bound(s) for `optparam`
"""
get_lb(optparam::OptimizationParameter) = optparam.lb

"""
    get_ub(optparam::OptimizationParameter)

Returns upper bound(s) for `optparam`
"""
get_ub(optparam::OptimizationParameter) = optparam.ub

"""
    get_scaling(optparam::OptimizationParameter)

Returns scaling parameter(s) for `optparam`
"""
get_scaling(optparam::OptimizationParameter) = optparam.scaling

"""
    get_dv(optparam::OptimizationParameter)

Returns design variable flag(s) for `optparam`
"""
get_dv(optparam::OptimizationParameter) = optparam.dv

"""
    get_description(optparam::OptimizationParameter)

Returns the description for `optparam`
"""
get_description(optparam::OptimizationParameter) = optparam.description

"""
    get_x0(optparams, field)

Returns initial value(s) for `field` in `optparams`
"""
get_x0(optparams, field) = optparams[field].x0

"""
    get_lb(optparams, field)

Returns lower bound(s) for `field` in `optparams`
"""
get_lb(optparams, field) = optparams[field].lb

"""
    get_ub(optparams, field)

Returns upper bound(s) for `field` in `optparams`
"""
get_ub(optparams, field) = optparams[field].ub

"""
    get_scaling(optparams, field)

Returns scaling parameter(s) for `field` in `optparams`
"""
get_scaling(optparams, field) = optparams[field].scaling

"""
    get_dv(optparams, field)

Returns design variable flag(s) for `field` in `optparams`
"""
get_dv(optparams, field) = optparams[field].dv

"""
    get_description(optparams, field)

Returns the description for `field` in `optparams`
"""
get_description(optparams, field) = optparams[field].description

# set functions
"""
    set_x0(optparam::OptimizationParameter, x0)

Returns `optparam` with the initial value(s) given by `x0`
"""
set_x0(optparam::OptimizationParameter, x0)= OptimizationParameter(
    x0, lb=optparam.lb, ub=optparam.ub, scaling=optparam.scaling, dv=optparam.dv, description=optparam.description)

"""
    set_lb(optparam::OptimizationParameter, lb)

Returns `optparam` with the lower bound(s) given by `lb`
"""
set_lb(optparam::OptimizationParameter, lb) = OptimizationParameter(
    optparam.x0, lb=lb, ub=optparam.ub, scaling=optparam.scaling, dv=optparam.dv, description=optparam.description)

"""
    set_ub(optparam::OptimizationParameter, ub)

Returns `optparam` with the upper bound(s) given by `ub`
"""
set_ub(optparam::OptimizationParameter, ub) = OptimizationParameter(
    optparam.x0, lb=optparam.lb, ub=ub, scaling=optparam.scaling, dv=optparam.dv, description=optparam.description)

"""
    set_scaling(optparam::OptimizationParameter, scaling)

Returns `optparam` with the scaling parameter given by `scaling`
"""
set_scaling(optparam::OptimizationParameter, scaling) = OptimizationParameter(
    optparam.x0, lb=optparam.lb, ub=optparam.ub, scaling=scaling, dv=optparam.dv, description=optparam.description)

"""
    set_dv(optparam::OptimizationParameter, dv)

Returns `optparam` with the design variable flag(s) given by `dv`
"""
set_dv(optparam::OptimizationParameter, dv) = OptimizationParameter(
    optparam.x0, lb=optparam.lb, ub=optparam.ub, scaling=optparam.scaling, dv=dv, description=optparam.description)

"""
    set_description(optparam::OptimizationParameter, description)

Returns `optparam` with the description given by `description`
"""
set_description(optparam::OptimizationParameter, description) = OptimizationParameter(
    optparam.x0, lb=optparam.lb, ub=optparam.ub, scaling=optparam.scaling, dv=optparam.dv, description=description)

"""
    set_x0!(optparams::AbstractDict, field, x0)

Modifies the `field` in `optparams` to have the initial value(s) given by `x0`
"""
function set_x0!(optparams::AbstractDict, field, x0)
    optparams[field] = set_x0(optparams[field], x0)
    return optparams
end

"""
    set_lb!(optparams::AbstractDict, field, lb)

Modifies the `field` in `optparams` to have the lower bound(s) given by `lb`
"""
function set_lb!(optparams::AbstractDict, field, lb)
    optparams[field] = set_lb(optparams[field], lb)
    return optparams
end

"""
    set_ub!(optparams::AbstractDict, field, ub)

Modifies the `field` in `optparams` to have the upper bound(s) given by `ub`
"""
function set_ub!(optparams::AbstractDict, field, ub)
    optparams[field] = set_ub(optparams[field], ub)
    return optparams
end

"""
    set_scaling!(optparams::AbstractDict, field, scaling)

Modifies the `field` in `optparams` to have the scaling parameter(s)
given by `scaling`
"""
function set_scaling!(optparams::AbstractDict, field, scaling)
    optparams[field] = set_scaling(optparams[field], scaling)
    return optparams
end

"""
    set_dv!(optparams::AbstractDict, field, dv)

Modifies the `field` in `optparams` to have the design variable flag(s)
given by `dv`
"""
function set_dv!(optparams::AbstractDict, field, dv)
    optparams[field] = set_dv(optparams[field], dv)
    return optparams
end

"""
    set_description!(optparams::AbstractDict, field, description)

Modifies the `field` in `optparams` to have the description given by `description`
"""
function set_description!(optparams::AbstractDict, field, description)
    optparams[field] = set_description(optparams[field], description)
    return optparams
end

"""
    set_x0(optparams::AbstractDict, field, x0)

Modifies the `field` in `optparams` to have the initial value(s) given by `x0`
"""
set_x0(optparams::AbstractDict, field, x0) = set_x0!(copy(optparams), field, x0)

"""
    set_lb(optparams::AbstractDict, field, lb)

Modifies the `field` in `optparams` to have the lower bound(s) given by `lb`
"""
set_lb(optparams::AbstractDict, field, lb) = set_lb!(copy(optparams), field, lb)

"""
    set_ub(optparams::AbstractDict, field, ub)

Modifies the `field` in `optparams` to have the upper bound(s) given by `ub`
"""
set_ub(optparams::AbstractDict, field, ub) = set_ub!(copy(optparams), field, ub)

"""
    set_scaling(optparams::AbstractDict, field, scaling)

Modifies the `field` in `optparams` to have the scaling parameter(s)
given by `scaling`
"""
set_scaling(optparams::AbstractDict, field, scaling) = set_scaling!(copy(optparams), field, scaling)

"""
    set_dv(optparams::AbstractDict, field, dv)

Modifies the `field` in `optparams` to have the design variable flag(s)
given by `dv`
"""
set_dv(optparams::AbstractDict, field, dv) = set_dv!(copy(optparams), field, dv)

"""
    set_description(optparams::AbstractDict, field, description)

Modifies the `field` in `optparams` to have the description given by `description`
"""
set_description(optparams::AbstractDict, field, description) = set_description!(copy(optparams), field, description)

"""
    set_x0(optparams::NamedTuple, field, x0)

Modifies the `field` in `optparams` to have the initial value(s) given by `x0`
"""
set_x0(optparams::NamedTuple{names}, field, x0) where names =
    NamedTuple{names}(Tuple(name == field ? set_x0(optparam, x0) : optparam
    for (name, optparam) in pairs(optparams)))

"""
    set_lb(optparams::NamedTuple, field, lb)

Modifies the `field` in `optparams` to have the lower bound(s) given by `lb`
"""
set_lb(optparams::NamedTuple{names}, field, lb) where names =
    NamedTuple{names}(Tuple(name == field ? set_lb(optparam, lb) :
    optparam for (name, optparam) in pairs(optparams)))

"""
    set_ub(optparams::NamedTuple, field, ub)

Modifies the `field` in `optparams` to have the upper bound(s) given by `ub`
"""
set_ub(optparams::NamedTuple{names}, field, ub) where names =
    NamedTuple{names}(Tuple(name == field ? set_ub(optparam, ub) :
    optparam for (name, optparam) in pairs(optparams)))

"""
    set_scaling(optparams::NamedTuple, field, scaling)

Modifies the `field` in `optparams` to have the scaling parameter(s)
given by `scaling`
"""
set_scaling(optparams::NamedTuple{names}, field, scaling) where names =
    NamedTuple{names}(Tuple(name == field ? set_scaling(optparam, scaling) :
    optparam for (name, optparam) in pairs(optparams)))

"""
    set_dv(optparams::NamedTuple, field, dv)

Modifies the `field` in `optparams` to have the design variable flag(s)
given by `dv`
"""
set_dv(optparams::NamedTuple{names}, field, dv) where names =
    NamedTuple{names}(Tuple(name == field ? set_dv(optparam, dv) :
    optparam for (name, optparam) in pairs(optparams)))

"""
    set_description(optparams::NamedTuple, field, description)

Modifies the `field` in `optparams` to have the description given by `description`
"""
set_description(optparams::NamedTuple{names}, field, description) where names =
    NamedTuple{names}(Tuple(name == field ? set_description(optparam, description) :
    optparam for (name, optparam) in pairs(optparams)))

"""
    update_parameters(optparams, params)

Inserts parameters from `params` into `optparams` and returns the result.
`optparams` is a named tuple or dictionary filled with objects of type OptimizationParameter.
`params` is a named tuple or dictionary with the parameter values to be replaced or a vector of scaled design variables.
"""
function update_parameters(optparams::NamedTuple, params)
    optparams = named_tuple_to_dict(optparams)
    params = named_tuple_to_dict(params)
    new = update_parameters!(optparams, params)
    return dict_to_named_tuple(new)
end

function update_parameters(optparams::NamedTuple, x::AbstractVector)
    optparams = named_tuple_to_dict(optparams)
    new = update_parameters!(optparams, x)
    return dict_to_named_tuple(new)
end

function update_parameters(optparams::AbstractDict, params)
    params = named_tuple_to_dict(params)
    new = update_parameters!(copy(optparams), params)
    return new
end

function update_parameters(optparams::AbstractDict, x::AbstractVector)
    new = update_parameters!(copy(optparams), x)
    return new
end

"""
    update_parameters!(optparams, params)

Inserts parameters from `params` into `optparams` and returns the result.
`optparams` is a dictionary filled with objects of type OptimizationParameter
`params` is a dictionary with the parameter values to be replaced or a vector of scaled design variables
"""
function update_parameters!(optparams, params)
    for name in keys(params)
        optparams[name] = set_x0(optparams[name], params[name])
    end
    return optparams
end

function update_parameters!(optparams, x::AbstractVector)
    params = get_values(optparams, x)
    for name in keys(params)
        optparams[name] = set_x0(optparams[name], params[name])
    end
    return optparams
end

"""
    update_design_variables(original, optimized)

Copies design variables that are active in both `original` and `optimized` from
`optimized` into `original` and returns the result.
`original` is a named tuple or dictionary filled with objects of type OptimizationParameter
`optimized` is a named tuple or dictionary filled with objects of type OptimizationParameter
"""
function update_design_variables(original::NamedTuple, optimized)
    original = named_tuple_to_dict(original)
    optimized = named_tuple_to_dict(optimized)
    new = update_design_variables!(original, optimized)
    return dict_to_named_tuple(new)

end

function update_design_variables(original::AbstractDict, optimized)
    optimized = named_tuple_to_dict(optimized)
    new = update_design_variables!(original, optimized)
    return new
end

"""
    update_design_variables!(original, optimized)

Copies design variables that are active in both `original` and `optimized` from
`optimized` into `original` and returns the result.
`original` is a named tuple or dictionary filled with objects of type OptimizationParameter
`optimized` is a named tuple or dictionary filled with objects of type OptimizationParameter
"""
function update_design_variables!(original, optimized)

    # loop through all fields in original optimization parameters
    for name in keys(original)

        # check if the optimized solution has this field
        if name in keys(optimized)

            # extract old and new parameters
            old = original[name]
            opt = optimized[name]

            # check if the old and optimized parameters have the same length
            if length(old.x0) == length(opt.x0)

                # update design variables that are active in both sets of parameters
                if typeof(old.x0) <: AbstractArray
                    T = promote_type(eltype(old.x0), eltype(opt.x0))
                    x0 = T.(old.x0)
                    idv = findall(old.dv .& opt.dv)
                    for i in idv
                        x0[i] = opt.x0[i]
                    end
                else
                    x0 = opt.x0
                end

                # overwrite old parameter
                original[name] = set_x0(old, x0)
            end
        end
    end

    return original
end

"""
    assemble_input(optparams)

Assembles the input for the optimization problem: x0, lb, ub
"""
function assemble_input(optparams)

    # get indices and number of design variables
    indices, ndv = design_variable_indices(optparams)

    # initialize output arrays
    x0 = Array{Float64,1}(undef, ndv)
    lb = Array{Float64,1}(undef, ndv)
    ub = Array{Float64,1}(undef, ndv)

    # populate output arrays
    for (name, optparam) in pairs(optparams)
        if any(optparam.dv)
            c_lb = optparam.lb
            c_ub = optparam.ub
            scaling = optparam.scaling
            idv = findall(optparam.dv)
            for j = 1:length(indices[name])
                initial = optparam.x0[idv[j]]
                lower = optparam.lb[idv[j]]
                upper = optparam.ub[idv[j]]
                scaling = optparam.scaling[idv[j]]
                offset = design_variable_offset(lower, upper)
                lb[indices[name][j]] = (lower + offset) * scaling
                x0[indices[name][j]] = (initial + offset) * scaling
                ub[indices[name][j]] = (upper + offset) * scaling
            end
        end
    end

    return x0, lb, ub
end

"""
    named_tuple_to_dict(nt)

Converts a named tuple to an ordered dictionary
"""
named_tuple_to_dict(nt) = OrderedDict(pairs(nt))

"""
    dict_to_named_tuple(dict)

Converts a dictionary to a named tuple
"""
dict_to_named_tuple(dict) = (; dict...)
