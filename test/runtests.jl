import OptParams
using Base.Test

# Create dictionary for storing parameters
paramdict=OptParams.initdict()

# Add a single value parameter
defaultA = 0.1
lowerboundA = 0.0
upperboundA = 1.0
scalingA = 1.0
OptParams.addparam!(paramdict,:paramA,defaultA,lowerboundA,upperboundA,scalingA)

# Or a multi-value parameter
defaultB = [0.2,0.3,0.4]
lowerboundB = [0.0,0.0,0.0]
upperboundB = [1.0,1.0,1.0]
scalingB = [1.0,1.0,1.0]
OptParams.addparam!(paramdict,:paramB,defaultB,lowerboundB,upperboundB,scalingB)

# multi-dimensional arrays work as well
defaultC = [0.5 0.6; 0.7 0.8]
lowerboundC = [0.0 0.0;0.0 0.0]
upperboundC = [1.0 1.0; 1.0 1.0]
scalingC = [1.0 1.0; 1.0 1.0]
OptParams.addparam!(paramdict,:paramC,defaultC,lowerboundC,upperboundC,scalingC)

# Add a parameter with scaling
defaultD = 0.9
lowerboundD = 0.0
upperboundD = 1.0
scalingD = 100.0
OptParams.addparam!(paramdict,:paramD,defaultD,lowerboundD,upperboundD,scalingD)

# define some variables for this optimization
optparams = [:paramB,:paramC,:paramD]

# now that we have all design variables we can assemble the optimization input
x0,lb,ub = OptParams.assembleinput(optparams,paramdict)

# we'll also need the ranges for the design variables
rangedict = OptParams.getrangedict(optparams,paramdict)
@test rangedict[:paramB] == 1:3
@test rangedict[:paramC] == 4:7
@test rangedict[:paramD] == 8:8

# now we would pass optdict and rangedict into our function like so:
# objcon(x) = myfunction(x,optdict,rangedict)

# inside the optimization loop the optimizer specifies new design variable values
x = x0+1.0

# now we can pull out the parameters that are not design variables
varA = OptParams.getvar(x,:paramA,paramdict,rangedict)
@test varA == defaultA

# the new design variable values
varB = OptParams.getvar(x,:paramB,paramdict,rangedict)
@test varB == [1.2,1.3,1.4]
varC = OptParams.getvar(x,:paramC,paramdict,rangedict)
@test varC == [1.5 1.6;
               1.7 1.8]

# removing the scaling on the variables is taken care of!
varD = OptParams.getvar(x,:paramD,paramdict,rangedict)
@test varD == 0.91

# we can also add/drop design variables simply by changing optparams!
