%% Parameter wall

%% Wave parameters
wave_options = struct();
wave_options.T = 50; %Final time of execution
wave_options.point_source = false;

%% Wave view options
wave_vis_options = struct();
wave_vis_options.play_movie_phys = false;
wave_vis_options.play_movie_canonical = true;


%% Graph parameters
graph_options = struct();
graph_options.ep = widths(1)*0.01;
graph_options.dxi = widths(1)*0.02;
graph_options.dzeta = widths(1)*0.02;

%% Graph view options
graph_vis_options = struct();
