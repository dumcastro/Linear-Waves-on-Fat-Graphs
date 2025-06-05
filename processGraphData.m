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
% Outputs:
%   fg      - FatGraph object
%   f_tilde - SC mapping object
%   C       - Canonical domain polygon
%   J       - Jacobian determinant matrix
%   w       - Grid points in canonical domain
%   z       - Grid points in physical domain
%
% Optional parameters (options struct):
%   .dxi        - Grid spacing in xi direction (default = 0.03)
%   .dzeta      - Grid spacing in zeta direction (default = 0.065)
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
        'dxi', 0.03, ...
        'dzeta', 0.065, ...
        'ep', 0.01,...
        'plotJ', true,...
        'plotMap', false);

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
    %load(sprintf('GraphData/Lx=%.1f_widths=%s_angles=%s.mat', ...
        %Lx, mat2str(widths), mat2str(ang_display)), ...
        %'fg', 'f_tilde', 'C', 'J', 'w', 'z');

    %% Plot results if requested
    if options.plotMap
        figure;
        subplot(1, 3, 1);
        plot(P, 'b', 'LineWidth', 2, 'k');
        title('Physical Region');

        subplot(1, 3, 2);
        plot(C_tilde, 'r', 'LineWidth', 2);
        title('Numerical canonical domain');

        subplot(1, 3, 3);
        plot(C, 'y', 'LineWidth', 2);
        title('Canonical domain width = 1');
    end
    
    
    if options.plotJ
        figure;
        surf(real(data.w), imag(data.w), data.J);
        xlabel('Real Axis');
        ylabel('Imaginary Axis');
        title('Jacobian Determinant of SC Transformation');
    end
end

