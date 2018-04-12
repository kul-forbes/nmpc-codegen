function [ trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = demo_set_obstacles( name )
%DEMO_SET_OBSTACLES 
    if(strcmp(name,"controller_compare_libs"))
        [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_controller_compare_libs();
    elseif(strcmp(name,"demo1"))
        [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo1();
    elseif(strcmp(name,"demo2"))
        [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo2();
    elseif(strcmp(name,"demo3"))
        [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo3();
    elseif(strcmp(name,"demo4"))
        [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo4();
    else
        error("error name not found");
    end
end

function [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_controller_compare_libs()
    step_size=0.05;

    % Q and R matrixes determined by the control engineer.
    Q = diag([1. 1. 1.])*0.2;
    R = diag([1. 1.]) * 0.01;

    Q_terminal = diag([1. 1. 1])*10;
    R_terminal = diag([1. 1.]) * 0.01;

    controller_folder_name = 'demo_controller_matlab';
    trailer_controller = prepare_demo_trailer(controller_folder_name,step_size,Q,R,Q_terminal,R_terminal);

    trailer_controller.horizon = 40; % NMPC parameter
    trailer_controller.integrator_casadi = true; % optional  feature that can generate the integrating used  in the cost function
    trailer_controller.panoc_max_steps = 2000; % the maximum amount of iterations the PANOC algorithm is allowed to do.
    trailer_controller.min_residual=-3;
    trailer_controller.lbgfs_buffer_size=50;
    % trailer_controller.pure_prox_gradient=true;

    % construct left circle
    circle1 = nmpccodegen.controller.obstacles.Obstacle_circular([1.5; 0.], 1.);
    circle2 = nmpccodegen.controller.obstacles.Obstacle_circular([3.5; 2.], 0.6);
    circle3 = nmpccodegen.controller.obstacles.Obstacle_circular([2.; 2.5], 0.8);
    circle4 = nmpccodegen.controller.obstacles.Obstacle_circular([5.; 4.], 1.05);

    % add obstacles to controller
    trailer_controller = trailer_controller.add_obstacle(circle1);
    trailer_controller = trailer_controller.add_obstacle(circle2);
    trailer_controller = trailer_controller.add_obstacle(circle3);
    trailer_controller = trailer_controller.add_obstacle(circle4);

    % generate the dynamic code
    trailer_controller = trailer_controller.generate_code();

    % simulate everything
    initial_state = [0.; -0.5 ; pi/2];
    reference_state = [7.; 5.; 0.8];
    reference_input = [0; 0];

    obstacle_weights = [700.;700.;700.;700.];
    
    figure;
    hold on;
    circle1.plot();
    circle2.plot();
    circle3.plot();
    circle4.plot();
end

function [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo1()
    step_size=0.03;

    % Q and R matrixes determined by the control engineer.
    Q = diag([1. 1. 0.01])*0.2;
    R = diag([1. 1.]) * 0.01;

    Q_terminal = Q;
    R_terminal = R;

    controller_folder_name = 'demo_controller_matlab';
    trailer_controller = prepare_demo_trailer(controller_folder_name,step_size,Q,R,Q_terminal,R_terminal);
    %%
    trailer_controller.horizon = 30; % NMPC parameter
    trailer_controller.integrator_casadi = true; % optional  feature that can generate the integrating used  in the cost function
    trailer_controller.panoc_max_steps = 500; % the maximum amount of iterations the PANOC algorithm is allowed to do.
    trailer_controller.min_residual=-3;

    rectangular_center_coordinates = [0.45;-0.1];
    rectangular_width = 0.4;
    rectangular_height = 0.1;
    rectangular = nmpccodegen.controller.obstacles.Obstacle_rectangular(rectangular_center_coordinates,...
                                                     rectangular_width,rectangular_height);

    % construct left circle
    left_circle = nmpccodegen.controller.obstacles.Obstacle_circular([0.2; 0.2],0.2);

    % construct right circle
    right_circle = nmpccodegen.controller.obstacles.Obstacle_circular([0.7; 0.2], 0.2);

    % add obstacles to controller
    trailer_controller = trailer_controller.add_obstacle(rectangular);
    trailer_controller = trailer_controller.add_obstacle(left_circle);
    trailer_controller = trailer_controller.add_obstacle(right_circle);

    % generate the dynamic code
    trailer_controller.generate_code();
    %%
    % simulate everything
    initial_state = [0.45; 0.1; -pi/2];
    reference_state = [0.8; -0.1; 0];
    reference_input = [0; 0];

    obstacle_weights = [10000.;8000.;50.];
    
    figure;
    hold all;
    rectangular.plot();
    left_circle.plot();
    right_circle.plot();
end

function [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo2()
    step_size=0.03;

    % Q and R matrixes determined by the control engineer.
    Q = diag([1. 1. 0.01])*0.2;
    R = diag([1. 1.]) * 0.01;

    Q_terminal = Q;
    R_terminal = R;

    controller_folder_name = 'demo_controller_matlab';
    trailer_controller = prepare_demo_trailer(controller_folder_name,step_size,Q,R,Q_terminal,R_terminal);
    %%
    trailer_controller.horizon = 50; % NMPC parameter
    trailer_controller.integrator_casadi = true; % optional  feature that can generate the integrating used  in the cost function
    trailer_controller.panoc_max_steps = 500; % the maximum amount of iterations the PANOC algorithm is allowed to do.
    trailer_controller.min_residual=-3;
    trailer_controller.lbgfs_buffer_size = 50;

    % construct upper rectangular
    rectangular_up = nmpccodegen.controller.obstacles.Obstacle_rectangular([1;0.5],0.4,0.5);

    % construct lower rectangular
    rectangular_down = nmpccodegen.controller.obstacles.Obstacle_rectangular([1; -0.2], 0.4, 0.5);

    % construct circle
    circle = nmpccodegen.controller.obstacles.Obstacle_circular([0.2;0.2],0.2);

    % add obstacles to controller
    trailer_controller = trailer_controller.add_obstacle(rectangular_up);
    trailer_controller = trailer_controller.add_obstacle(rectangular_down);
    trailer_controller = trailer_controller.add_obstacle(circle);

    % generate the dynamic code
    trailer_controller.generate_code();
    %%
    % simulate everything
    initial_state = [-0.1; -0.1; pi];
    reference_state = [1.5; 0.4; 0];
    reference_input = [0; 0];

    obstacle_weights = [10.;10.;2000.];
    
    figure;
    hold all;
    rectangular_up.plot();
    rectangular_down.plot();
    circle.plot();
end

function [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo3()
    step_size=0.03;

    % Q and R matrixes determined by the control engineer.
    Q = diag([1. 1. 0.01])*0.2;
    R = diag([1. 1.]) * 0.01;

    Q_terminal = Q;
    R_terminal = R;

    controller_folder_name = 'demo_controller_matlab';
    trailer_controller = prepare_demo_trailer(controller_folder_name,step_size,Q,R,Q_terminal,R_terminal);
    %%
    trailer_controller.horizon = 50; % NMPC parameter
    trailer_controller.integrator_casadi = true; % optional  feature that can generate the integrating used  in the cost function
    trailer_controller.panoc_max_steps = 500; % the maximum amount of iterations the PANOC algorithm is allowed to do.
    trailer_controller.min_residual=-3;
    trailer_controller.lbgfs_buffer_size = 50;

    % construct upper rectangular
    costum_obstacle = nmpccodegen.controller.obstacles.Obstacle_nonconvex_constraints();
    h_0 = @(x) x(2)-x(1)^2;
    h_1 = @(x) 1 + (x(1)^2)/2 - x(2);
    costum_obstacle = costum_obstacle.add_constraint(h_0);
    costum_obstacle = costum_obstacle.add_constraint(h_1);

    % add obstacles to controller
    trailer_controller = trailer_controller.add_obstacle(costum_obstacle);

    % generate the dynamic code
    trailer_controller.generate_code();
    %%
    % simulate everything
    initial_state = [-1.0; 0.0; pi/2];
    reference_state = [-1.0; 2.; pi/3];
    reference_input = [0; 0];

    obstacle_weights = 1e3;
    
    figure;
    hold all;
    h_0_border = @(x) x.^2;
    h_1_border = @(x) 1 + (x.^2)/2;
    draw_obstacle_border(h_0_border,[-2;2],100);
    draw_obstacle_border(h_1_border, [-2;2], 100);
end

function [trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = generate_demo4()
    step_size=0.03;

    % Q and R matrixes determined by the control engineer.
    Q = diag([1. 1. 0.01])*0.2;
    R = diag([1. 1.]) * 0.1;

    Q_terminal = diag([1., 1., 0.1])*1;
    R_terminal = diag([1., 1.]) * 0.01;

    controller_folder_name = 'demo_controller_matlab';
    trailer_controller = prepare_demo_trailer(controller_folder_name,step_size,Q,R,Q_terminal,R_terminal);
    %%
    trailer_controller.horizon = 50; % NMPC parameter
    trailer_controller.integrator_casadi = true; % optional  feature that can generate the integrating used  in the cost function
    trailer_controller.panoc_max_steps = 10000; % the maximum amount of iterations the PANOC algorithm is allowed to do.
    trailer_controller.min_residual=-3;
    trailer_controller.lbgfs_buffer_size = 50;

    % construct upper rectangular
    costum_obstacle = nmpccodegen.controller.obstacles.Obstacle_nonconvex_constraints();
    h_0 = @(x) x(2) - 2.*math.sin(-x(1)/2.);
    h_1 = @(x) 3.*sin(x(1)/2 -1) - x(2);
    h_2 = @(x) x(1) - 1;
    h_3 = @(x) 8 - x(1);
    costum_obstacle.add_constraint(h_0);
    costum_obstacle.add_constraint(h_1);
    costum_obstacle.add_constraint(h_2);
    costum_obstacle.add_constraint(h_3);

    % add obstacles to controller
    trailer_controller = trailer_controller.add_obstacle(costum_obstacle);

    % generate the dynamic code
    trailer_controller.generate_code();
    %%
    % simulate everything
    initial_state = [7; -1; -pi];
    reference_state = [1.5; -2.; -pi];
    reference_input = [0; 0];

    obstacle_weights = 1e1;
    
    figure;
    hold all;
    h_0_border = @(x) 2.*sin(-x/2.);
    h_1_border = @(x) 3.*sin(x/2. -1.);
    draw_obstacle_border(h_0_border,[1;8],100)
    draw_obstacle_border(h_1_border, [1;8], 100)

end
