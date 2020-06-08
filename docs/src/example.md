# [Example](@id Example)

This example shows how to use OptimizationParameters to set up the design variables and parameters for an optimization.

```@contents
Pages = ["example.md"]
Depth = 3
```

```@setup example
using OptimizationParameters
```

## Creating a dictionary/named tuple of optimization parameters

The building block of the entire optimization parameter interface is the [`OptimizationParameter`](@ref) composite type.  

This object stores a number of details about each variable including the variable's:
- Default value(s)
- Lower and upper bound(s) (when used as a design variable)
- Scaling (when used as a design variable)
- Design variable flag(s) indicating whether the parameter is a design variable
- A description of the variable

```@example example
design_variable1 = OptimizationParameter(1.0, lb=0.0, ub=10.0, scaling=1.0, dv=true, description="A design variable")
nothing #hide
```

Instances of [`OptimizationParameter`](@ref) don't have to be design variables.  They can also just be parameters that you would like to be able to change easily between optimization runs.  These parameters can be floats, integers, booleans, strings, etc.  The only requirement is that if the parameter is an active design variable, it must be continuous.

```@example example
int_parameter = OptimizationParameter(1)
bool_parameter = OptimizationParameter(true)
string_parameter = OptimizationParameter("foo")
nothing #hide
```

In order to associate instances of OptimizationParameter with variable names, we use either a named tuple or a dictionary.  Named tuples are preferred for performance, since they provide type information to the compiler, but dictionaries are often more convenient for construction and debugging.  

```@example example
# dictionary of OptimizationParameters
dict = Dict(:design1=>design_variable1, :int1=>int_parameter, :bool1=>bool_parameter, :string1=>string_parameter)

# named tuple of OptimizationParameters
nt = (; :design1=>design_variable1, :int1=>int_parameter, :bool1=>bool_parameter, :string1=>string_parameter)

nothing #hide
```

Fortunately, both can be used interchangeably if we use symbols as keys and access optimization parameters by indexing.

```@example example
# indexing works for both named dictionaries and named tuples
dict[:design1]
nt[:design1]
nothing #hide
```

For convenience we provide the functions [`named_tuple_to_dict`](@ref) and [`dict_to_named_tuple`](@ref) to convert to and from dictionaries and named tuples.

Perhaps the easiest way to construct a dictionary or named tuple of objects of type OptimizationParameter is to use a CSV input file that has the following format:

|Parameter          |Initial Value(s)|Lower Bound(s)|Upper Bound(s)|Scaling      |Design Variable(s)?       |Description                                                                  |
|-------------------|----------------|--------------|--------------|-------------|--------------------------|-----------------------------------------------------------------------------|
|                   |                |              |              |             |                          |                                                                             |
|# Scalar Parameters|                |              |              |             |                          |                                                                             |
|scalar1            |0               |-Inf          |Inf           |1            |false                     |this variable has all fields filled in                                       |
|scalar2            |0               |              |              |             |                          |this variable has almost no fields filled in, but is identical to scalar1    |
|scalar3            |0               |-Inf          |Inf           |1            |true                      |this variable is the same as scalar1, but is activated                       |
|scalar4            |250             |100           |1000          |0.002        |true                      |this variable is scaled to be roughly of order 1                             |
|scalar5            |10              |              |              |             |                          |variables don't have to be design variables, they can also just be parameters|
|scalar6            |-1              |              |              |             |FALSE                     |note that the case doesn't matter for the design variable flag               |
|                   |                |              |              |             |                          |                                                                             |
|# Vector Parameters|                |              |              |             |                          |                                                                             |
|vector1            |[1, 2, 8, 9]    |0             |10            |1            |TRUE                      |this is an example of a vector parameter                                     |
|vector2            |[1, 2, 8, 9]    |[0,0,5,5]     |[5,5,10,10]   |[1,1,0.5,0.5]|TRUE                      |scalars and/or vectors can be used for any field                             |
|vector3            |[1, 2, 8, 9]    |[0,0,5,5]     |[5,5,10,10]   |[1,1,0.5,0.5]|[true, false, true, false]|we can even use only part of an array as a design variable                   |
|vector4            |0.5*ones(10)    |zeros(10)     |1             |ones(10)*0.5 |TRUE                      |all values can also be input as generic Julia code                           |
|                   |                |              |              |             |                          |                                                                             |
|# Matrix Parameters|                |              |              |             |                          |                                                                             |
|matrix1            |[1 3; 2 4]      |0             |10            |1            |true                      |the shape of vectors and matrices will be preserved                          |
|                   |                |              |              |             |                          |                                                                             |
|# Other Parameters |                |              |              |             |                          |                                                                             |
|bool1              |true            |              |              |             |                          |we can also include other types of variables as design parameters            |
|int1               |1               |              |              |             |                          |integers will be converted to floats when used as design variables, but otherwise left as integers|
|string1            |"foo"           |              |              |             |                          |some types of variables like strings cannot be design variables              |

This file may be read into either a dict or a named tuple using [`read_parameters`](@ref).

```@example example
optparams = read_parameters("example.csv")
nothing #hide
```

Note that the shape of design variables/parameters is preserved when using OptimizationParameters and that initial values, lower bounds, upper bounds, scaling factors, and design variable flags can be specified using a single value, or an array of values.  This makes the OptimizationParameter interface extremely powerful for managing design variables.

## Modifying the dictionary/named tuple of optimization parameters

Sometimes it is necessary/convenient to modify the dictionary/named tuple of optimization parameters.  This is easily done using the [`set_x0`](@ref), [`set_lb`](@ref), [`set_ub`](@ref), [`set_dv`](@ref), and [`set_description`](@ref) functions.  Here we will activate the `scalar1` design variable:

```@example example
optparams = set_dv(optparams, :scalar1, true)
nothing #hide
```

## Assembling the input for the optimization

Assembling the design variable initial value, lower bound, and upper bound arrays is done using the [`assemble_input`](@ref) function.  This function automatically scales the design variables and centers them around zero.

```@example example
x0, lb, ub = assemble_input(optparams)
nothing #hide
```

## Extracting parameters in the optimization

Inside the optimization, OptimizationParameters just needs access to design variable value array and the dictionary/named tuple of optimization parameters.  [`get_values`](@ref) then allows you to extract the parameter values, appropriately modified based on the values in the design variable array as a dictionary/named tuple.  

```@example example
x = rand(length(x0)) # design variable values provided by optimizer
parameters = get_values(optparams, x) # dictionary or named tuple of parameter values
```

These parameter values may be accessed using the common indexing notation for both types discussed previously.
```@example example
parameters[:scalar1]
```

## Printing active design variables during the optimization

Active design variables may be printed during the optimization with [`print_design_variables`](@ref)

```@example example
print_design_variables(optparams, x)
```

## Updating optimization parameters after the optimization

After the optimization, the optimizer returns a vector of optimal design variables.  These variables may be used to replace the optimization parameter initial values using [`update_parameters`](@ref)

```@example example
xopt = rand(length(x0)) # optimal design variable values provided by the optimizer
optimized = update_parameters(optparams, xopt) # updates parameter values
```

## Writing results to a file

The updated optimization parameters may then be written to a CSV file using [`write_parameters`](@ref).  

```@example example
write_parameters("optimized.csv", optimized)
```

When writing CSV files, a template file (such as the input file) may be used to specify the order of the parameters and to insert comments and blank lines in the resulting file.

```@example example
write_parameters("example.csv", "optimized.csv", optimized)
```

## Updating optimization parameters using a previous optimization

In some cases, we may want to use initial parameter values for design variables
that correspond to the optimized design variables found in another optimization run.  [`update_design_variables`](@ref) allows you to update the initial values of the design variables in one set of optimization parameters with the optimized design variables of another set of optimization parameters.

```@example example
optparams = update_design_variables(optparams, optimized)
```
