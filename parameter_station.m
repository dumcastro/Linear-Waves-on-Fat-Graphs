%% Parameter wall

%% Wave parameters
wave_options = struct();
wave_options.T = 140; %Final time of execution

%% Wave view options
wave_vis_options = struct();
wave_vis_options.play_movie_phys = true;
wave_vis_options.play_movie_canonical = false;
wave_vis_options.jmp_xi = 20;


%% Graph parameters
graph_options = struct();
graph_options.ep = widths(1)*0.01;
graph_options.dxi = widths(1)*0.05;
graph_options.dzeta = widths(1)*0.05;

%% Graph view options
graph_vis_options = struct();
