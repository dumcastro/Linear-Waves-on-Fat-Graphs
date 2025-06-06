function [fg, f_tilde, C, J, w, z] = createFatGraph(Lx, widths, angles, options)
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
    if nargin < 1 || isempty(Lx), Lx = 20; end
    if nargin < 2 || isempty(widths), widths = [1, 0.5, 0.5]; end
    if nargin < 3 || isempty(angles), angles = [0, 2*pi/3, 4*pi/3]; end

    % Default numerical parameters
    default_options = struct(...
        'dxi', 0.03, ...
        'dzeta', 0.07, ...
        'ep', 0.01, ...
        'want_save', true, ...
        'plot_flag', false);

    % Merge user options with defaults
    option_names = fieldnames(default_options);
    for k = 1:length(option_names)
        if ~isfield(options, option_names{k})
            options.(option_names{k}) = default_options.(option_names{k});
        end
    end

    %% Create fat graph object
    fg = FatGraph(Lx, widths, angles);

    %% Process polygon vertices
    ver = fg.complex_vertices;

    % Apply small extension to avoid singularities
    ver(2) = ver(2) - options.ep*1i;
    ver(5) = ver(5) + options.ep;
    ver(8) = ver(8) + options.ep*1i;

    %% Schwarz-Christoffel mapping
    sang = [0.5000, 1, 0.5000, 0.5000, 2.0000, 0.5000, 0.5000, 1.0000, 0.5000];
    P = polygon(ver);
    %P = polyedit(P);

    % Create SC map to rectangle
    f_tilde = crrectmap(P, sang);

    % Compute canonical domain
    C_tilde = evalinv(f_tilde, P);

    % Calculate scaling factor
    xi_lims = [min(real(vertex(C_tilde))), max(real(vertex(C_tilde)))];
    Lxi_tilde = diff(xi_lims);
    alpha = Lxi_tilde/Lx;
    C = (1/alpha)*C_tilde;

    %% Create computational grid
    xi_lims = [min(real(vertex(C))), max(real(vertex(C)))];
    zeta_lims = [min(imag(vertex(C)))+options.ep, max(imag(vertex(C)))];

    xi = xi_lims(1):options.dxi:xi_lims(2);
    zeta = zeta_lims(1):options.dzeta:zeta_lims(2);

    [Xi, Zeta] = meshgrid(xi, zeta);
    w = Xi + 1i * Zeta;
    z = eval(f_tilde, alpha*w);

    %% Compute Jacobian
    dz = evaldiff(f_tilde, alpha*w);
    J = (alpha^2)*abs(dz).^2;

    % Fix zero Jacobian values
    med = median(median(J));
    J(J == 0) = med;
    
    %% Dividing the domain in sectors
    node = ver(5);
    vert = evalinv(f_tilde,node); % computing the critical node in phys space
    vert = vert/alpha;
    targ_xi = real(vert);
    targ_zeta = imag(vert);

    th_xi = find(xi<targ_xi, 1, 'last');
    th_zeta = find(zeta<targ_zeta, 1, 'last');
    %w1 = alpha*w(:,1:th_xi); %branch 1 
    %w2 = alpha*w(1:th_zeta,th_xi:end); %branch 2
    %w3 = alpha*w(th_zeta+1:end,th_xi:end); %branch 3

    %% Plot results if requested
    if options.plot_flag
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

        figure;
        surf(real(w), imag(w), J);
        xlabel('Real Axis');
        ylabel('Imaginary Axis');
        title('Jacobian Determinant of SC Transformation');
    end

    %% Save data if requested
    if options.want_save
        ang_display = round(angles, 3);
        save(['GraphData/widths= ', mat2str(widths), 'angles= ', mat2str(ang_display), '.mat'])
        %save(sprintf('GraphData/Lx=%.1f_widths=%s_angles=%s.mat', ...
            %Lx, mat2str(widths), mat2str(ang_display)));
    end
end
