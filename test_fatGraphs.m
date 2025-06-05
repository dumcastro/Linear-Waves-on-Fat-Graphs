% Basic usage with defaults
[fg, f, C, J] = createFatGraph();

% Custom geometry without plotting
%options = struct('plot_flag', false);
%[fg, f] = createFatGraph(15, [1.2, 0.5, 0.5], [0, pi/2, 3*pi/2], options);

% Save results with custom grid spacing
%options = struct('dxi', 0.02, 'dzeta', 0.05, 'want_save', true);
%createFatGraph(20, [1, 0.3, 0.7], [0, 2*pi/3, 4*pi/3], options);
