clear all; clc; close all;

%% Simulation Parameters
N = 101;        % Number of grid points
L = 4*pi;       % Domain length
s = 0.5;        % Courant number
barrier_height = 0.6; % Fraction of domain height with barrier (0-1)

%% Initialization
x = linspace(0,L,N);
y = linspace(0,L,N);
mid_x = round(N/2);  % Division point x-coordinate
barrier_end = round(N*barrier_height); % Where barrier ends

% Initialize wave field (past, current, future)
u = zeros(N,N,3);

% Initial condition - Gaussian pulse in section A only
[X,Y] = meshgrid(x,y);
init_u = 2*exp(-2*(X-L/4).^2 - 2*(Y-L/3).^2);

u(:,:,1) = init_u;
u(:,:,2) = init_u;

%% Visualization Setup
domainA = false(N,N);
domainA(:,1:mid_x-1) = true;  % Section A (left of division)
domainB = false(N,N);
domainB(:,mid_x+1:end) = true; % Section B (right of division)

figure('Position', [100, 100, 800, 600]);
custom_map = [linspace(0,1,64)' linspace(0,0.7,64)' linspace(1,0.1,64)'];
colormap(custom_map);
caxis([0 128]);

hA = surf(X,Y,zeros(size(X)), 'EdgeColor', 'none', 'FaceAlpha', 0.7);
hold on;
hB = surf(X,Y,zeros(size(X)), 'EdgeColor', 'none', 'FaceAlpha', 0.7);

% Draw partial barrier
barrier_y = y(barrier_end);
plot3([x(mid_x) x(mid_x)], [0 barrier_y], [0 0], 'w-', 'LineWidth', 3);
plot3([x(mid_x) x(mid_x)], [0 barrier_y], [0 0], 'k--', 'LineWidth', 1.5);
hold off;

axis([0 L 0 L -2 2]);
view(3);
xlabel('x'); ylabel('y'); zlabel('Amplitude');
title(sprintf('Partial Barrier Simulation (Height: %.1f)', barrier_height));
colorbar;

%% Simulation Loop
for ii = 1:200
    % Update interior points (treat as unified domain first)
    u(2:end-1, 2:end-1, 3) = s*(u(2:end-1, 3:end, 2) + u(2:end-1, 1:end-2, 2)) ...
                            + s*(u(3:end, 2:end-1, 2) + u(1:end-2, 2:end-1, 2)) ...
                            + 2*(1-2*s)*u(2:end-1, 2:end-1, 2) ...
                            - u(2:end-1, 2:end-1, 1);
    
    % Apply partial barrier - only for rows above barrier_end
    for j = 1:barrier_end
        % Right boundary of section A
        u(j,mid_x,3) = u(j,mid_x-1,3);
        % Left boundary of section B
        u(j,mid_x+1,3) = u(j,mid_x+2,3);
    end
    
    %{
    % Special treatment for transition row (smoothed boundary)
    trans_row = barrier_end + (-2:2); % Small transition region
    for j = trans_row(trans_row > 0 & trans_row <= N)
        % Blend between barrier and no-barrier conditions
        blend_factor = (j - barrier_end)/length(trans_row);
        u(j,mid_x,3) = (1-blend_factor)*u(j,mid_x-1,3) + blend_factor*u(j,mid_x,3);
        u(j,mid_x+1,3) = (1-blend_factor)*u(j,mid_x+2,3) + blend_factor*u(j,mid_x+1,3);
    end
    %}
    
    % Standard Neumann boundaries at domain edges
    u([1 end], :, 3) = u([2 end-1], :, 3);
    u(:, [1 end], 3) = u(:, [2 end-1], 3);
    
    % Update time steps
    u(:,:,1) = u(:,:,2);
    u(:,:,2) = u(:,:,3);
    
    % Update visualizations
    zA = u(:,:,2); zA(~domainA) = NaN;
    zB = u(:,:,2); zB(~domainB) = NaN;
    set(hA, 'ZData', zA, 'CData', zA*64);
    set(hB, 'ZData', zB, 'CData', zB*64 + 64);
    title(sprintf('Partial Barrier - Frame %d/300', ii));
    drawnow;
end