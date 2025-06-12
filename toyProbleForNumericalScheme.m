% wave2D_RK4.m — Minimal solver for 2D wave equation using RK4 time-stepping
clear all, clc, close all

% Parameters
Lx = 2;          % domain size in x
Ly = 1;          % domain size in y
Nx = 101;        % grid points in x
Ny = 51;         % grid points in y
dx = Lx / (Nx-1);
dy = Ly / (Ny-1);
x = linspace(0, Lx, Nx);
y = linspace(0, Ly, Ny);
[X, Y] = meshgrid(x, y);

c = 1;           % wave speed
Tf = 2.0;        % final time
dt = 0.001;      % time step
Nt = round(Tf/dt);

% Initial condition: narrow Gaussian in center
sigma = 0.05;
u0 = exp(-((X-Lx/2).^2 + (Y-Ly/2).^2)/(2*sigma^2));
v0 = zeros(size(u0));  % initial velocity

% Flatten for time stepping (column-major)
u = u0(:);
v = v0(:);

% Laplacian operator (sparse)
Ix = speye(Nx); Iy = speye(Ny);
e = ones(Nx,1);
Dxx = spdiags([e -2*e e], -1:1, Nx, Nx) / dx^2;
Dxx(1,:) = 0; Dxx(end,:) = 0;  % Dirichlet BC
Dyy = spdiags([e -2*e e], -1:1, Ny, Ny) / dy^2;
Dyy(1,:) = 0; Dyy(end,:) = 0;  % Dirichlet BC
L = kron(Iy, Dxx) + kron(Dyy, Ix);

% Time stepping using RK4
for n = 1:Nt
    k1u = dt * v;
    k1v = dt * (c^2 * (L * u));
    
    k2u = dt * (v + 0.5 * k1v);
    k2v = dt * (c^2 * (L * (u + 0.5 * k1u)));
    
    k3u = dt * (v + 0.5 * k2v);
    k3v = dt * (c^2 * (L * (u + 0.5 * k2u)));
    
    k4u = dt * (v + k3v);
    k4v = dt * (c^2 * (L * (u + k3u)));
    
    u = u + (k1u + 2*k2u + 2*k3u + k4u)/6;
    v = v + (k1v + 2*k2v + 2*k3v + k4v)/6;
    
    % Plot every 20 steps
    if mod(n, 20) == 0
        surf(X, Y, reshape(u, Ny, Nx));
        shading interp; axis tight; caxis([-1 1]*0.5);
        title(sprintf('Time: %.3f s', n*dt));
        xlabel('x'); ylabel('y'); zlabel('u');
        drawnow;
    end
end
