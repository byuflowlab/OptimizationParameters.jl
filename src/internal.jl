# functions designed to be used inside the optimization

"""
    get_value(optparam[, x])

Returns the value(s) of the optimization parameter(s) given a scalar/vector of design
variables.  If `x` is not provided, the default parameter values are returned.
"""
get_value

get_value(optparam::OptimizationParameter) = optparam.x0
get_value(optparam::OptimizationParameter{<:Any, <:Any, <:Any, <:Any, false}, x) = optparam.x0
get_value(optparam::OptimizationParameter{<:Any, <:Number, <:Any, <:Any, true}, x) = x[1]/optparam.scaling + design_variable_offset(optparam.lb, optparam.ub)

function get_value(optparam::OptimizationParameter{S, <:AbstractArray{<:Any, N}, <:Any, <:Any, true}, x) where {S, N}

    TFX = eltype(x)

    result = MArray{S, TFX, N}(optparam.x0)

    # find all active design variables for this parameter
    idv = findall(optparam.dv)

    # remove the scaling and offset from the active design variables
    for i = 1:length(idv)
        idx = idv[i]
        scaling = optparam.scaling[idx]
        offset = design_variable_offset(optparam.lb[idx], optparam.ub[idx])
        result[idx] = x[i]/scaling - offset
    end

    return SArray(result)
end

"""
    get_values(optparam[, x])

Returns a named tuple or dictionary of the values of the optimization parameter(s)
given a vector of design variables.  If `x` is not provided, the default parameter
values are returned.
"""
get_values

# same, but for a NamedTuple of OptimizationParameter
function get_values(optparams::NamedTuple{names, types}) where {names, types}
    T = Tuple{eltype.(tuple(types.parameters...))...}
    return NamedTuple{names, T}(optparam.x0 for (name, optparam) in pairs(optparams))
end

function get_values(optparams::NamedTuple{names}, x) where names

    # get design variable indices
    indices, ndv = design_variable_indices(optparams)

    # create tuple of parameter get_values
    get_values = (isempty(indices[name]) ? optparam.x0 : get_value(optparam, x[indices[name][1:length(indices[name])]]) for (name,optparam) in pairs(optparams))

    # return a named tuple of the parameters
    return NamedTuple{names}(get_values)
end

# same, but for a dictionary of OptimizationParameter

function get_values(optparams::AbstractDict)
    return OrderedDict([(name, optparam.x0) for (name, optparam) in pairs(optparams)])
end

function get_values(optparams::AbstractDict, x) where names

    # get design variable indices
    indices, ndv = design_variable_indices(optparams)

    # return dictionary of parameter get_values
    return OrderedDict(
        [isempty(indices[name]) ?
        (name, optparam.x0) :
        (name, get_value(optparam, x[indices[name][1:length(indices[name])]]))
        for (name,optparam) in pairs(optparams)])

end

"""
    design_variable_indices(optparams)

Returns a dictionary which contains the indices of the design variables for
each optimization parameter. Also returns the number of design variables.
"""
# gets the indices of the design variables for each optimization parameter
function design_variable_indices!(indices, optparams)

    ndv = 0
    for (name, optparam) in pairs(optparams)
        idx1 = ndv + 1
        idx2 = ndv + count(optparam.dv)::Int
        indices[name] = idx1:idx2
        ndv = idx2
    end

    return indices, ndv
end

function design_variable_indices(optparams::NamedTuple)
    indices = OrderedDict{Symbol,UnitRange{Int}}()
    return design_variable_indices!(indices, optparams)
end

function design_variable_indices(optparams::AbstractDict)
    indices = OrderedDict{keytype(optparams),UnitRange{Int}}()
    return design_variable_indices!(indices, optparams)
end

"""
    print_design_variables(optparams, x)

Prints design variable get_values for the current iteration
"""
function print_design_variables(optparams, x)

    # get design variable indices
    indices, ndv = design_variable_indices(optparams)

    # print each design variable get_value
    for (name, optparam) in pairs(optparams)
        if !isempty(indices[name])
            if length(indices[name]) == length(optparam.x0)
                println(name, ": ", get_value(optparam, x[indices[name]]))
            else
                dv = findall(optparam.dv)
                println(name, dv,": ", get_value(optparam, x[indices[name]])[dv])
            end
        end
    end

    return nothing
end

"""
    design_variable_offset(lb, ub)

Determines the amount to offset a design variable in order to center it around zero
"""
design_variable_offset(lb, ub) = -(min(ub, 1e20) + max(lb, -1e20))/2
