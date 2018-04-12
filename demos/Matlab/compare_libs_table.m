% Compare the nmpc-codegen library with alternatives for different
% obstacles. Print out a table with the timing results.

clear all;
addpath(genpath('../../src_matlab'));
%%
names={"controller_compare_libs","demo2","demo3"};
result_mean = zeros(length(names),6);
result_min = zeros(length(names),6);
result_max = zeros(length(names),6);

for i=1:length(names)
    name=names{i}; % change this to demo1,demo2,demo3 or demo4
    [ trailer_controller,initial_state,reference_state,reference_input,obstacle_weights ] = demo_set_obstacles( name );

    % simulate with different methods
    [min_convergence_time,mean_convergence_time,max_convergence_time]= ...
        simulate_example(trailer_controller,initial_state,reference_state,...
        reference_input,obstacle_weights);

    result_mean(i,:) = mean_convergence_time;
    result_min(i,:) = min_convergence_time;
    result_max(i,:) = max_convergence_time;
end
%%
% Convert table to latex
for i=1:length(names)
    columnLabels{i} = char(names{i});
end
rowLabels = {'nmpc-codegen','panoc Matab','fmincon:interior-point','fmincon:sqp','fmincon:active-set','OPTI:ipopt'};
%%
generate_latex_table = @(table_matrix,file_name) matrix2latex(table_matrix, file_name, 'rowLabels', rowLabels, 'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-6.2e', 'size', 'tiny');

generate_latex_table(result_mean','tables/mean.tex');
generate_latex_table(result_max','tables/max.tex');
generate_latex_table(result_min','tables/min.tex');

result_mean_rel=result_mean;
for i=length(rowLabels):-1:1
    result_mean_rel(:,i) = result_mean(:,i)./result_mean(:,1);
end
generate_latex_rel_table = @(table_matrix,file_name) matrix2latex(table_matrix*100, file_name, 'rowLabels', rowLabels, 'columnLabels', columnLabels, 'alignment', 'c', 'format', '%-8.0f', 'size', 'tiny');
generate_latex_rel_table(result_mean_rel','tables/mean_rel.tex');
%%
function [min_convergence_time,mean_convergence_time,max_convergence_time]= ...
    simulate_example(trailer_controller,initial_state,reference_state,...
    reference_input,obstacle_weights)

    [~,time_history,~,simulator] = simulate_demo_trailer(trailer_controller,initial_state,reference_state,reference_input,obstacle_weights);
    
    [~,time_history_forbes,~] = simulate_demo_trailer_panoc_matlab(trailer_controller,simulator,initial_state,reference_state,reference_input);
    
    [~,time_history_fmincon_interior_point] = simulate_demo_trailer_fmincon('interior-point',trailer_controller,simulator,initial_state,reference_state,reference_input);
    
    [~,time_history_fmincon_sqp] = simulate_demo_trailer_fmincon('sqp',trailer_controller,simulator,initial_state,reference_state,reference_input);
    
    [~,time_history_fmincon_active_set] = simulate_demo_trailer_fmincon('active-set',trailer_controller,simulator,initial_state,reference_state,reference_input);
    
    [ ~,time_history_ipopt ]  = simulate_demo_trailer_OPTI_ipopt( trailer_controller,simulator, ...
        initial_state,reference_state,reference_input,obstacle_weights );
    
    clear simulator;
    
    min_convergence_time = [min(time_history) min(time_history_forbes) min(time_history_fmincon_interior_point)...
        min(time_history_fmincon_sqp) min(time_history_fmincon_active_set) min(time_history_ipopt)];
    
    max_convergence_time = [max(time_history) max(time_history_forbes) max(time_history_fmincon_interior_point)...
        max(time_history_fmincon_sqp) max(time_history_fmincon_active_set) max(time_history_ipopt)];
    
    mean_convergence_time = [mean(time_history) mean(time_history_forbes) mean(time_history_fmincon_interior_point)...
        mean(time_history_fmincon_sqp) mean(time_history_fmincon_active_set) mean(time_history_ipopt)];
    
end