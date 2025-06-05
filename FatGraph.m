classdef FatGraph < handle
    % FATGRAPH A 2D fattened metric graph (polygon) with complex vertices
    %   The reference edge is aligned with the x-axis, with its end centered at the origin

    properties
        edge_length = 10;      % Length of all edges (equal for now)
        widths = [1, 0.5, 0.5]; % Width of edges [reference, edge2, edge3]
        angles = [0, pi/2, 3*pi/2]; % Angles of edges relative to reference edge (radians)
    end

    properties (Dependent)
        polygon_vertices       % Computed polygon vertices (real coordinates)
        complex_vertices      % Complex number representation (new property)
        visualization_handle   % Handle to visualization plot
    end

    methods
        function obj = FatGraph(edge_length, widths, angles)
            % Constructor
            %addpath('External');

            if nargin > 0
                obj.edge_length = edge_length;
            end
            if nargin > 1
                obj.widths = widths;
            end
            if nargin > 2
                obj.angles = angles;
            end

            validate_properties(obj);
        end

        function validate_properties(obj)
            % Validate property values
            assert(numel(obj.angles) == 3, 'Must specify exactly 3 angles');
            assert(obj.edge_length > 0, 'Edge length must be positive');
            assert(all(obj.widths > 0), 'All widths must be positive');
        end

        function vertices = get.polygon_vertices(obj)
            % Get vertices as real (x,y) coordinates
            cv = obj.complex_vertices;  % Uses the complex_vertices get method
            vertices = [real(cv)', imag(cv)'];
        end

        function cv = get.complex_vertices(obj)
            % Calculate and return complex number representation
            rl = obj.edge_length;
            w1 = obj.widths(1);
            w2 = obj.widths(2);
            w3 = obj.widths(3);
            a2 = pi + obj.angles(2);
            a3 = pi + obj.angles(3);
            slit = obj.widths(2);

            % Calculate intermediate points
            Q1 = rl + rl*exp(1i*a2) + w2*exp(1i*(a2+pi/2));
            lmbd1 = (slit - imag(Q1))/sin(a2);
            N1 = Q1 + lmbd1*exp(1i*a2);
            Q2 = N1 + rl*exp(1i*a3) + w3*exp(1i*(a3+pi/2));
            lmbd2 = (w1 - imag(Q2))/sin(a3);
            N2 = Q2 + lmbd2*exp(1i*a3);

            % Return complex vertices
            cv = [0, rl, rl + rl*exp(1i*a2), Q1, N1, ...
                 N1 + rl*exp(1i*a3), Q2, N2, 1i*w1];
        end

        function h = get.visualization_handle(obj)
            % Get or create visualization handle
            h = obj.visualize();
        end

        function h = visualize(obj)
            % Visualize the fat graph
            vertices = obj.polygon_vertices;
            h = figure;
            fill(vertices(:,1), vertices(:,2), 'b', 'FaceAlpha', 0.5);
            hold on;
            plot(vertices(:,1), vertices(:,2), 'k-', 'LineWidth', 2);
            axis equal;
            grid on;
            title('FatGraph Visualization');
            xlabel('X');
            ylabel('Y');
        end
    end
end
