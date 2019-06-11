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
        if typeof(data[i,2]) == String # array input needs to be processed
            lb[i] = eval(Meta.parse(strip(data[i,2])))
        else # assign number input
            lb[i] = data[i,2]
        end
    end

    # process initial value
    x0 = Array{Any,1}(undef, nvar)
    for i = 1:nvar
        if typeof(data[i,3]) == String # array input needs to be processed
            x0[i] = eval(Meta.parse(strip(data[i,3])))
        else # assign number input
            x0[i] = data[i,3]
        end
    end

    # process upper bound
    ub = Array{Any,1}(undef, nvar)
    for i = 1:nvar
        if typeof(data[i,4]) == String # process array input
            ub[i] = eval(Meta.parse(strip(data[i,4])))
        else # assign number input
            ub[i] = data[i,4]
        end
    end

    # process design variable flag
    dv = zeros(Bool, nvar)
    for i = 1:nvar
        if typeof(data[i,5]) == String
            dv[i] = parse(Bool, lowercase(strip(data[i,5])))
        end
    end

    # process comments
    comments = strip.(data[:,6])

    #
    # # read file and get number of variables
    # lines = readlines(file)
    # nvar = length(lines)-1
    #
    # # ignore first line that has header information
    # lines = lines[2:end]
    #
    # # assign lower bounds, initial value, upper value, and design variable flag
    # name = fill("", nvar)
    # lb = Array{Any,1}(undef, nvar)
    # x0 = Array{Any,1}(undef, nvar)
    # ub = Array{Any,1}(undef, nvar)
    # dv = zeros(Bool, nvar)
    # comments = fill("", nvar)
    # for i = 1:length(lines)
    #
    #     # read in variable name
    #     idx1 = findfirst(isequal(','), lines[i])
    #     name[i] = strip(lines[i][1:idx1-1])
    #
    #     # now read in lower bound, variable value, and upper bound
    #     for arr in [lb,x0,ub]
    #         # find next comma
    #         idx2 = findnext(isequal(','), lines[i], idx1+1)
    #         # process input
    #         if occursin("[", lines[i][idx1:idx2]) # array input
    #             idx3 = findnext(isequal('['), lines[i], idx1)
    #             idx4 = findnext(isequal(']'), lines[i], idx1)
    #             arr[i] = eval(Meta.parse(lines[i][idx3:idx4]))
    #             idx2 = findnext(isequal(','), lines[i], idx4)
    #         else # number input
    #             arr[i] = eval(Meta.parse(lines[i][idx1+1:idx2-1]))
    #         end
    #         idx1 = idx2
    #     end
    #
    #     # now read in design variable flag
    #     idx2 = findnext(isequal(','), lines[i], idx1+1)
    #     if !isnothing(idx2)
    #         idx2 = length(lines[i])
    #     end
    #     dv[i] = parse(Bool, lowercase(strip(lines[i][idx1+1:idx2-1])))
    #
    #     # read in comments
    #     if length(idx2) >
    #     comments[i] = strip(lines[i][idx2+1:end])
    # end

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


function assembleinput(optparams::OptimizationParameters)

    # initialize outputs
    x0 = Array{Float64,1}(undef, 0)
    lb = Array{Float64,1}(undef, 0)
    ub = Array{Float64,1}(undef, 0)

    # get active design variables
    activevariables = find(optparams.dv)

    # assemble inputs for optimization function
    for i=1:length(optparams.name)
        scaledvalues = (optparams.x0-optparams.lb)/(optparams.ub-optparams.lb)
        append!(x0, scaledvalues)
        append!(lb, zeros(scaledvalues))
        append!(ub, ones(scaledvalues))
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
        if optparams.dv
            idx += 1
            nvals = length(optparams.x0[i])
            vals = x[idx:idx+nval-1]*(optparams.ub[i]-optparams.lb[i])+optparams.lb[i]
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
