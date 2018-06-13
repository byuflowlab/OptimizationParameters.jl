module OptParams

export latin_hypercube_sampling, softmax

function initdict()
    return Dict{Symbol,Array{Float64}}()
end

function addparam!(paramdict::Dict{Symbol,Array{Float64}},name::Symbol,
    default::Float64,lowerbound::Float64,upperbound::Float64,scaling::Float64)
    paramdict[name] = vcat(default,lowerbound,upperbound,scaling)
    return nothing
end

function addparam!(paramdict::Dict{Symbol,Array{Float64}},name::Symbol,
    default::Array{Float64},lowerbound::Array{Float64},
    upperbound::Array{Float64},scaling::Array{Float64})
    # reshape to fit all parameters
    rsdefault = reshape(default,1,size(default)...)
    rslowerbound = reshape(lowerbound,1,size(lowerbound)...)
    rsupperbound = reshape(upperbound,1,size(upperbound)...)
    rsscaling = reshape(scaling,1,size(scaling)...)
    paramdict[name] = vcat(rsdefault,rslowerbound,rsupperbound,rsscaling)
    return nothing
end

function assembleinput(optparams::Array{Symbol,1},paramdict::Dict{Symbol,Array{Float64}})
    x0 = Array{Float64,1}(0)
    lb = Array{Float64,1}(0)
    ub = Array{Float64,1}(0)
    for param in optparams
        #reshape to flatten
        vals = paramdict[param]
        flatvals = reshape(vals,4,div(length(vals),4))
        append!(x0,flatvals[1,:].*flatvals[4,:])
        append!(lb,flatvals[2,:].*flatvals[4,:])
        append!(ub,flatvals[3,:].*flatvals[4,:])
    end
    return x0,lb,ub
end

function getrangedict(optparams::Array{Symbol,1},paramdict::Dict{Symbol,Array{Float64}})
    idx = 0
    rangedict = Dict{Symbol,UnitRange}()
    for param in optparams
        #reshape to flatten
        vals = paramdict[param]
        flatvals = reshape(vals,4,div(length(vals),4))
        rangedict[param] = idx+(1:size(flatvals,2))
        idx = idx + size(flatvals,2)
    end
    return rangedict
end

function getvar(name::Symbol,x,paramdict::Dict{Symbol,Array{Float64}},
    rangedict::Dict{Symbol,UnitRange})

    if name in keys(rangedict)
        # pull out design variable values
        flatvar = x[rangedict[name]]

        #remove scaling on design variable values
        vals = paramdict[name]
        flatvals = reshape(vals,4,div(length(vals),4))
        flatvar = flatvar./flatvals[4,:]

        #reshape to input dimensions
        var = reshape(flatvar,size(vals)[2:end]...)
    else
        vals = paramdict[name]
        var = slicedim(vals,1,1)
    end

    # return float if single design variable
    if length(var) == 1
        return var[1]
    else
        return var
    end
end

function setvar!(name::Symbol,x,paramdict::Dict{Symbol,Array{Float64}},
    rangedict::Dict{Symbol,UnitRange},var)

    #reshape input to flat dimensions
    if length(var)!=1
        flatvar = reshape(var,prod(size(var)))
    else
        flatvar = var
    end
    #reshape original inputs to get the scaling
    origvals = paramdict[name]
    origflatvals = reshape(origvals,4,div(length(origvals),4))
    newflatvar = flatvar.*origflatvals[4,:] #apply scaling

    if name in keys(rangedict)
        # put in design variable values
        x[rangedict[name]] = newflatvar
    end

    #Reset default to input variable
    origflatvals[1,:] = flatvar
    paramdict[name] = origflatvals

end

function latin_hypercube_sampling{T}(mins::AbstractVector{T}, maxs::AbstractVector{T}, numSamples::Integer)
    dims = length(mins)
    result = zeros(T, numSamples, dims)
    @inbounds for i in 1:dims
        interval_len = (maxs[i] - mins[i]) / numSamples
        result[:,i] = shuffle!(linspace(mins[i], maxs[i] - interval_len, numSamples) +
        interval_len*rand(numSamples))
    end
    return result'
end #latin_hypercube_sampling

function softmax(x,hardness=50.0)
    k = maximum(x)
    return sum((x-k).*exp.(hardness*(x-k)))/sum(exp.(hardness*(x-k)))+k
end

end # module
