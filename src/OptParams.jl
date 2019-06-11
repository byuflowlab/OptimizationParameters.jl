module OptParams
import DelimitedFiles

struct OptimizationParameters
    name::Array{String,1}
    lb::Array{Any,1}
    x0::Array{Any,1}
    ub::Array{Any,1}
    dv::Array{Bool,1}
    comments::Array{String,1}
end

function readparams(file::String)

    # read file, skip header
    data = DelimitedFiles.readdlm(file, ',', skipstart=1, comments=true)

    # get number of variables
    nvar = size(data,1)

    # process name
    name = strip.(data[:,1])

    # process lower bound
    lb = Array{Any,1}(undef, nvar)
    for i = 1:nvar
        if typeof(data[i,2]) <: AbstractString # array input needs to be processed
            lb[i] = eval(Meta.parse(strip(data[i,2])))
        else # assign number input
            lb[i] = data[i,2]
        end
    end

    # process initial value
    x0 = Array{Any,1}(undef, nvar)
    for i = 1:nvar
        if typeof(data[i,3]) <: AbstractString # array input needs to be processed
            x0[i] = eval(Meta.parse(strip(data[i,3])))
        else # assign number input
            x0[i] = data[i,3]
        end
    end

    # process upper bound
    ub = Array{Any,1}(undef, nvar)
    for i = 1:nvar
        if typeof(data[i,4]) <: AbstractString # process array input
            ub[i] = eval(Meta.parse(strip(data[i,4])))
        else # assign number input
            ub[i] = data[i,4]
        end
    end

    # process design variable flag
    dv = zeros(Bool, nvar)
    for i = 1:nvar
        if typeof(data[i,5]) <: AbstractString
            dv[i] = parse(Bool, lowercase(strip(data[i,5])))
        else
            dv[i] = data[i,5]
        end
    end

    # process comments
    comments = strip.(data[:,6])

    # bundle and return output
    return OptimizationParameters(name, lb, x0, ub, dv, comments)
end

function writeparams(file::String, parameters::OptimizationParameters)

    header = ["Parameter" "Lower Bound" "Initial Value" "Upper Bound" "Design Variable" "Comments"]
    data = hcat(parameters.name, parameters.lb, parameters.x0,
        parameters.ub, parameters.dv, parameters.comments)
    DelimitedFiles.writedlm(file, vcat(header, data), ',')

    return nothing
end


function assembleinput(parameters::OptimizationParameters)

    # initialize outputs
    x0 = Array{Float64,1}(undef, 0)
    lb = Array{Float64,1}(undef, 0)
    ub = Array{Float64,1}(undef, 0)

    # get active design variables
    activevariables = findall(parameters.dv)

    # assemble inputs for optimization function
    for idx in activevariables
        scaledvalues = (parameters.x0[idx].-parameters.lb[idx])./(parameters.ub[idx].-parameters.lb[idx])
        append!(x0, scaledvalues)
        append!(lb, zeros(length(scaledvalues)))
        append!(ub, ones(length(scaledvalues)))
    end

    return x0, lb, ub
end

function getvalues(x::Array{Float64,1}, optparams::OptimizationParameters)

    # create dictionary of parameters
    designvariables = Dict{String, Any}()

    # design variable index
    idx = 0

    # get parameter values
    for i = 1:length(optparams.name)
        if optparams.dv[i]
            idx += 1
            nvals = length(optparams.x0[i])
            vals = x[idx:idx+nvals-1].*(optparams.ub[i].-optparams.lb[i]).+optparams.lb[i]
        else
            vals = optparams.x0[i]
        end
        designvariables[optparams.name[i]] = vals
    end

    # return dictionary of parameters
    return designvariables
end

include("deprecated.jl")

end # module
