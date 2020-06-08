# functions for reading/writing .csv files with optimization parameters

"""
   read_parameters(file; dict=true)

Reads the optimization parameters in a csv file and returns either an ordered
dictionary or a named tuple of the optimization parameters.
"""
function read_parameters(file; dict=true)

    # read file
    (data, header) = DelimitedFiles.readdlm(file, ',', header=true, comments=true, skipblanks=true)

    # keep only lines that have variable names
    idx = findall((x)->!isempty(strip(x)), data[:,1])
    data = data[idx, :]

    # get ordering of each column of data
    icol_name, icol_x0, icol_lb, icol_ub, icol_scale, icol_dv, icol_description = get_column_ordering(header)

    # parse each column
    nparam = size(data, 1)
    names = Symbol.(strip.(data[:, icol_name]))
    initial_values = parse_value.(data[:, icol_x0])
    lower_bounds = parse_value.(data[:, icol_lb])
    upper_bounds = parse_value.(data[:, icol_ub])
    scaling = icol_scale == nothing ? nothing : parse_value.(data[:, icol_scale])
    design_variable = parse_value.(data[:, icol_dv])
    description = strip.(data[:, icol_description])

    # replace missing lower bound values with -Inf
    lower_bounds[findall(isnothing.(lower_bounds))] .= -Inf

    # replace missing upper bound values with Inf
    upper_bounds[findall(isnothing.(upper_bounds))] .= Inf

    # replace missing scaling values with `1.0`
    scaling[findall(isnothing.(scaling))] .= 1.0

    # replace missing design variable flags with `false`
    design_variable[findall(isnothing.(design_variable))] .= false

    # create a named tuple of optimization parameters
    optparams = NamedTuple{Tuple(names)}(Tuple(OptimizationParameter(initial_values[i],
        lb=lower_bounds[i], ub=upper_bounds[i], scaling=scaling[i], dv=design_variable[i],
        description=description[i]) for i = 1:nparam))

    # return a dictionary if specified
    if dict
        return named_tuple_to_dict(optparams)
    else
        return optparams
    end

end

"""
   write_parameters([inputfile, ]outputfile, optparams)

Writes the optimization parameters in `optparams` to a csv file.  If given, the
file `inputfile` is used as a template for the organization of the resulting file.
"""
function write_parameters(inputfile, outputfile, optparams)

    # read input file, skip nothing
    data = DelimitedFiles.readdlm(inputfile, ',', Any, skipstart=0, comments=false, skipblanks=false)
    header = data[1,:]

    # get position of each column
    icol_name, icol_x0, icol_lb, icol_ub, icol_scale, icol_dv, icol_description = get_column_ordering(header)

    # get input file names indexed by line number
    inputnames = Symbol.(strip.(data[:,icol_name]))

    # loop through each optimization parameter overwriting data from input file
    for (name, optparam) in pairs(optparams)
        # find line for this optimization parameter
        irow = findfirst(inputnames .== name)

        if isnothing(irow)
            error("Template input file does not have parameter: `$name`")
        else
            # overwrite initial value
            data[irow,icol_x0] = write_value(optparam.x0)

            # overwrite lower bound
            if all(optparam.lb .== -Inf)
                # clear if not manually set to -Inf
                if any(parse_value(data[irow, icol_lb]) .!= -Inf)
                    data[irow,icol_lb] = ""
                end
            else
                data[irow,icol_lb] = write_value(optparam.lb)
            end

            # overwrite upper bound
            if all(optparam.ub .== Inf)
                # clear if not manually set to Inf
                if any(parse_value(data[irow, icol_ub]) .!= Inf)
                    data[irow,icol_ub] = ""
                end
            else
                data[irow,icol_ub] = write_value(optparam.ub)
            end

            # overwrite scaling
            if icol_scale != nothing
                if all(optparam.scaling .== 1.0)
                    # clear if not manually set to 1.0
                    if any(parse_value(data[irow, icol_scale]) .!= 1.0)
                        data[irow, icol_scale] = ""
                    end
                else
                    data[irow,icol_scale] = write_value(optparam.scaling)
                end
            end

            # overwrite design variable flag
            if all(optparam.dv .== false)
                # clear if not manually set to false
                if any(parse_value(data[irow, icol_dv]) .!= false)
                    data[irow, icol_dv] = ""
                end
            else
                data[irow,icol_dv] = write_value(optparam.dv)
            end

            # overwrite descriptions
            data[irow,icol_description] = optparam.description

        end
    end

    # finally write output file
    DelimitedFiles.writedlm(outputfile, data, ',', quotes=true)

    return nothing
end

function write_parameters(outputfile, optparams; descriptions=nothing)

    data = fill("", length(optparams)+1, 7)

    data[1,:] .= ["Parameter", "Initial Value(s)", "Lower Bound(s)", "Upper Bound(s)",
        "Scaling", "Design Variable(s)?", "Description"]

    irow = 1

    # loop through each optimization parameter overwriting data from input file
    for (name, optparam) in pairs(optparams)

        irow += 1

        # parameter name
        data[irow,1] = string(name)

        # initial value(s)
        data[irow,2] = write_value(optparam.x0)

        # lower bound(s)
        data[irow,3] = write_value(optparam.lb)

        # upper bound(s)
        data[irow,4] = write_value(optparam.ub)

        # scaling
        data[irow,5] = write_value(optparam.scaling)

        # design variable flag(s)
        data[irow,6] = write_value(optparam.dv)

        # descriptions
        data[irow,7] = optparam.description

    end

    # finally write output file
    DelimitedFiles.writedlm(outputfile, data, ',', quotes=true)

    return nothing
end

"""
    write_value(value)

Returns a string representing `value` using a set of custom rules.
"""
write_value

# by default writing a value writes a string
write_value(value) = string(value)

# for a string, we need to add quotes
write_value(value::AbstractString) = "\""*string(value)*"\""

# a value of nothing returns an empty string
write_value(value::Nothing) = ""

# an array prints a generic empty array if it is empty
function write_value(value::AbstractArray)
    if isempty(value)
        result = "[]"
    else
        result = string(value)
    end
    return result
end

"""
    get_column_ordering(header)

Returns the column ordering given the file header
"""
function get_column_ordering(header)

    # get position of each column
    header = lowercase.(strip.(header))[:]
    icol_name = findfirst(header .== "parameter")
    icol_x0 = findfirst(header .== "initial value(s)")
    icol_lb = findfirst(header .== "lower bound(s)")
    icol_ub = findfirst(header .== "upper bound(s)")
    icol_scale = findfirst(header .== "scaling")
    icol_dv = findfirst(header .== "design variable(s)?")
    icol_description = findfirst(header .== "description")

    # if any of the names can't be resolved, use the default ordering
    if any([icol_name, icol_x0, icol_lb, icol_ub, icol_scale, icol_dv, icol_description] .== nothing)
        # scaling column doesn't have to exist
        if length(header) == 6
            icol_name = 1
            icol_x0 = 2
            icol_lb = 3
            icol_ub = 4
            icol_scale = nothing
            icol_dv = 5
            icol_description = 6
        else
            icol_name = 1
            icol_x0 = 2
            icol_lb = 3
            icol_ub = 4
            icol_scale = 5
            icol_dv = 6
            icol_description = 7
        end
    end

    return icol_name, icol_x0, icol_lb, icol_ub, icol_scale, icol_dv, icol_description
end

"""
    parse_value(value)

Returns `value` if `value` is not a string.

If `value` is a string this function checks if `value` should have been parsed
as a boolean and returns the corresponding boolean.

Otherwise `value` is parsed as a Julia expression, with a few customizations:
- [] parses to Float64[]
- The unicode characters “ and ” are converted to "
"""
parse_value(value) = value

# for a string, special parsing is needed
function parse_value(str::AbstractString)
    str = strip(str)
    # check first for boolean input
    if lowercase(str) == "true"
        value = true
    elseif lowercase(str) == "false"
        value = false
    else # if not boolean parse as a Julia expression
        str = replace(str, "[]"=>"Float64[]")
        str = replace(str, "“"=>"\"")
        str = replace(str, "”"=>"\"")
        # str = ascii(str)
        # str = replace(str, r"(\"[^\"]*)([^\"]*(\"|$))" => s"FixedSizeString(\1\2)")
        value = eval(Meta.parse(str))
    end

    return value
end
