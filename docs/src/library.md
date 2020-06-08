# Library

```@contents
Pages = ["library.md"]
Depth = 2
```

## Public API

```@docs
OptimizationParameter
OptimizationParameter(x0)
get_x0
get_lb
get_ub
get_scaling
get_dv
get_description
set_x0
set_x0!
set_lb
set_lb!
set_ub
set_ub!
set_scaling
set_scaling!
set_dv
set_dv!
set_description
set_description!
update_parameters
update_parameters!
update_design_variables
update_design_variables!
named_tuple_to_dict
dict_to_named_tuple
assemble_input
get_values
print_design_variables
read_parameters
write_parameters
```

## Private API

```@docs
OptimizationParameters.get_value
OptimizationParameters.design_variable_offset
OptimizationParameters.parse_value
OptimizationParameters.write_value
OptimizationParameters.get_column_ordering
```

## Index

```@index
```
