% Copyright (C) 2025 Eduardo Castro

% Author: Eduardo Castro <eduardocastro@MacBook-Air-de-Eduardo.local>
% Created: 2025-06-03

function [] = processGraphData(Lx, widths, angles, options)
%CREATEFATGRAPH Creates a fat graph and computes Schwarz-Christoffel mapping
%   [fg, f_tilde, C, J, w, z] = createFatGraph(Lx, widths, angles) creates a Y-shaped
%   fat graph with specified dimensions and computes its SC transformation.
%
%   [fg, f_tilde, C, J, w, z] = createFatGraph(Lx, widths, angles, options) allows
%   customization of numerical parameters.
%
% Inputs:
%   Lx      - Length of main branch (default = 10)
%   widths  - Array of branch widths [main, branch1, branch2] (default = [1, 0.4, 0.6])
%   angles  - Array of branch angles in radians (default = [0, 2*pi/3, 4*pi/3])
%   options - Structure with optional parameters (see below)
%
% Optional parameters (options struct):
%   .ep         - Domain extension parameter (default = 0.01)
%   .want_save  - Flag to save results (default = false)
%   .plot_flag  - Flag to generate plots (default = true)

    % Set default parameter values
    if nargin < 4
        options = struct();
    end

    % Default graph parameters
    if nargin < 1 || isempty(Lx), Lx = 10; end
    if nargin < 2 || isempty(widths), widths = [1, 0.5, 0.5]; end
    if nargin < 3 || isempty(angles), angles = [0, 2*pi/3, 4*pi/3]; end

    % Default numerical parameters
    default_options = struct(...
        'ep', 0.01,...
        'plotJ', true,...
        'plotMap', false,...
        'visualizeGrid', true);

    % Merge user options with defaults
    option_names = fieldnames(default_options);
    for k = 1:length(option_names)
        if ~isfield(options, option_names{k})
            options.(option_names{k}) = default_options.(option_names{k});
        end
    end

    %% Load fat Graph
    ang_display = round(angles, 3);
    data = load(['GraphData/widths= ', mat2str(widths), 'angles= ', mat2str(ang_display), '.mat']);

    %% Plot results if requested
    if options.plotMap
        figure;
        subplot(1, 3, 1);
        plot(data.P, 'b', 'LineWidth', 2, 'k');
        title('Physical Region');

        subplot(1, 3, 2);
        plot(data.C_tilde, 'r', 'LineWidth', 2);
        title('Numerical canonical domain');

        subplot(1, 3, 3);
        plot(data.C, 'y', 'LineWidth', 2);
        title('Canonical domain width = 1');
    end
    
    
    if options.plotJ
        figure;
        surf(real(data.w), imag(data.w), data.J);
        xlabel('Real Axis');
        ylabel('Imaginary Axis');
        title('Jacobian Determinant of SC Transformation');
    end
    
    %% Visualize Grid
    if options.visualizeGrid

        % Visualize with scatter
        figure;
        scatter(data.Xi(:), data.Zeta(:), 50, 'filled');  % Flatten grids and plot
        axis equal;
        title('Meshgrid Visualization');
        xlabel('X'); ylabel('Y');
        grid on; hold on,
        
        scatter(real(data.vert), imag(data.vert), 'red', 'Filled')
    end
    
end

