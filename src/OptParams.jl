module OptParams

struct param
  default::Float64
  lowerbound::Float64
  upperbound::Float64
  scaling::Float64
end

function assembleinput(optparams::Array{Symbol,1},paramdict::Dict{Symbol,param})
  vartotal = length(optparams)
  lb = zeros(vartotal)
  ub = zeros(vartotal)
  x0 = zeros(vartotal)
  for i = 1:vartotal
    param = optparams[i]
    lb[i] = paramdict[param].lowerbound*paramdict[param].scaling
    ub[i] = paramdict[param].upperbound*paramdict[param].scaling
    x0[i] = paramdict[param].default*paramdict[param].scaling
  end
  return lb,ub,x0
end

function getvar(x,optparams,paramdict,name::Symbol)
  idx = findfirst(optparams,name)
  if idx == 0
    value = paramdict[name].default
  else
    value = x[idx]/paramdict[name].scaling
  end
  return value
end

end # module
