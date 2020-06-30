using OptimizationParameters
using Test

@testset "OptimizationParameters.jl" begin

    # dictionary read and write
    dict = read_parameters("example.csv", dict=true)
    write_parameters("tmp.csv", dict)
    dict2 = read_parameters("tmp.csv", dict=true)
    for key in keys(dict)
        for field in fieldnames(OptimizationParameter)
            @test getproperty(dict[key], field) == getproperty(dict2[key], field)
        end
    end
    write_parameters("example.csv", "tmp.csv", dict)
    dict3 = read_parameters("tmp.csv", dict=true)
    for key in keys(dict)
        for field in fieldnames(OptimizationParameter)
            @test getproperty(dict[key], field) == getproperty(dict3[key], field)
        end
    end

    # named tuple read and write
    nt = read_parameters("example.csv", dict=false)
    write_parameters("tmp.csv", nt)
    nt2 = read_parameters("tmp.csv", dict=false)
    for key in keys(nt)
        for field in fieldnames(OptimizationParameter)
            @test getproperty(nt[key], field) == getproperty(nt2[key], field)
        end
    end
    write_parameters("example.csv", "tmp.csv", nt)
    nt3 = read_parameters("tmp.csv", dict=false)
    for key in keys(nt)
        for field in fieldnames(OptimizationParameter)
            @test getproperty(nt[key], field) == getproperty(nt3[key], field)
        end
    end

    # remove temporary file
    rm("tmp.csv")

    # get and set methods for OptimizationParameter
    optparam = OptimizationParameter(1)
    optparam = set_x0(optparam, 5)
    optparam = set_lb(optparam, 0)
    optparam = set_ub(optparam, 10)
    optparam = set_scaling(optparam, 0.1)
    optparam = set_dv(optparam, true)
    optparam = set_description(optparam, "test variable")

    @test get_x0(optparam) == 5
    @test get_lb(optparam) == 0
    @test get_ub(optparam) == 10
    @test get_scaling(optparam) == 0.1
    @test get_dv(optparam) == true
    @test get_description(optparam) == "test variable"

    # get and set methods for dictionaries
    tmp1 = copy(dict)
    set_x0!(tmp1, :scalar1, 5)
    set_lb!(tmp1, :scalar1, 0)
    set_ub!(tmp1, :scalar1, 10)
    set_scaling!(tmp1, :scalar1, 0.1)
    set_dv!(tmp1, :scalar1, true)
    set_description!(tmp1, :scalar1, "test variable")

    @test get_x0(tmp1, :scalar1) == 5
    @test get_lb(tmp1, :scalar1) == 0
    @test get_ub(tmp1, :scalar1) == 10
    @test get_scaling(tmp1, :scalar1) == 0.1
    @test get_dv(tmp1, :scalar1) == true
    @test get_description(tmp1, :scalar1) == "test variable"

    tmp2 = copy(dict)
    tmp2 = set_x0(tmp2, :scalar1, 5)
    tmp2 = set_lb(tmp2, :scalar1, 0)
    tmp2 = set_ub(tmp2, :scalar1, 10)
    tmp2 = set_scaling(tmp2, :scalar1, 0.1)
    tmp2 = set_dv(tmp2, :scalar1, true)
    tmp2 = set_description(tmp2, :scalar1, "test variable")

    @test get_x0(tmp2, :scalar1) == 5
    @test get_lb(tmp2, :scalar1) == 0
    @test get_ub(tmp2, :scalar1) == 10
    @test get_scaling(tmp2, :scalar1) == 0.1
    @test get_dv(tmp2, :scalar1) == true
    @test get_description(tmp2, :scalar1) == "test variable"

    # get and set methods for named tuples
    tmp3 = nt
    tmp3 = set_x0(tmp3, :scalar1, 5)
    tmp3 = set_lb(tmp3, :scalar1, 0)
    tmp3 = set_ub(tmp3, :scalar1, 10)
    tmp3 = set_scaling(tmp3, :scalar1, 0.1)
    tmp3 = set_dv(tmp3, :scalar1, true)
    tmp3 = set_description(tmp3, :scalar1, "test variable")

    @test get_x0(tmp3, :scalar1) == 5
    @test get_lb(tmp3, :scalar1) == 0
    @test get_ub(tmp3, :scalar1) == 10
    @test get_scaling(tmp3, :scalar1) == 0.1
    @test get_dv(tmp3, :scalar1) == true
    @test get_description(tmp3, :scalar1) == "test variable"

    # update parameters (still need proper tests here)
    p_dict = get_values(dict)
    p_nt = get_values(nt)
    tmp = update_parameters(nt, p_dict)
    tmp = update_parameters(dict, p_nt)
    tmp = update_parameters(dict, p_dict)
    tmp = update_parameters(nt, p_nt)
    tmp = update_parameters!(dict, p_dict)

    # update_design variables (still need proper tests here
    tmp = update_design_variables(nt, dict)
    tmp = update_design_variables(dict, nt)
    tmp = update_design_variables(dict, dict2)
    tmp = update_design_variables(nt, nt2)
    tmp = update_design_variables!(dict, dict2)

    # assemble input (still need proper tests here)
    x0, lb, ub = assemble_input(nt)
    x0, lb, ub = assemble_input(dict)

    # extract parameter values (still need proper test here)
    parameters = get_values(nt, x0)
    parameters = get_values(dict, x0)

    # test that offset works properly
    lb = 0
    ub = 10
    optparam = OptimizationParameter(0; lb=lb, ub=ub, dv=true)
    @test OptimizationParameters.get_value(optparam, 0) == (lb + ub)/2

end
