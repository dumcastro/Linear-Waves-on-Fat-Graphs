% Create Y-shape
clear all, clc, close all

want_save = 1; 
Lx = 20;
widths = [1, 0.4, 0.6];
angles = [0, 2*pi/3, 4*pi/3];

fg = FatGraph(Lx, widths, angles);

%% Setting a polygonal domain and SC-mapping
dxi = 0.006*5;
dzeta = 0.065; 
%---Extending a bit the domain: set a gap to avoid Jacobian singularity
ep = 0.01; %0.01

ver = fg.complex_vertices;

ver(2) = ver(2) - ep*1i;
ver(5) = ver(5) + ep;
ver(8) = ver(8) + ep*1i;

sang = [0.5000, 1, 0.5000, 0.5000, 2.0000, 0.5000, 0.5000, 1.0000, 0.5000];
P = polygon(ver); P = polyedit(P); 

f_tilde = crrectmap(P, sang);
% Compute the inverse mapping to obtain the canonical domain
C_tilde = evalinv(f_tilde,P); 

%---Getting the dilation paratemeter---
%Checking the boundaries of rectangle C
xi_lowlim=min(real(vertex(C_tilde)));
xi_highlim=max(real(vertex(C_tilde)));

Lxi_tilde = (xi_highlim)-(xi_lowlim); % Length of the canonical domain
%Lzeta= (zeta_highlim)-(zeta_lowlim);

alpha = Lxi_tilde/Lx; % How much the domain gets strecthed/shrinked
C = (1/alpha)*C_tilde;

figure;
subplot(1, 3, 1);
plot(P, 'b', 'LineWidth', 2,'k');
title('Physical Region');

subplot(1, 3, 2);
plot(C_tilde, 'r', 'LineWidth', 2);
title('Numerical canonical domain');

subplot(1, 3, 3);
plot(C, 'y', 'LineWidth', 2);
title('Canonical domain width = 1');

%Checking the boundaries of rectangle C
xi_lowlim=min(real(vertex(C)));
xi_highlim=max(real(vertex(C)));

zeta_lowlim=min(imag(vertex(C)))+ep;
zeta_highlim=max(imag(vertex(C)));

Lxi = (xi_highlim)-(xi_lowlim); % Length of the domain
Lzeta= (zeta_highlim)-(zeta_lowlim);

xi=xi_lowlim:dxi:xi_highlim;
zeta=zeta_lowlim:dzeta:zeta_highlim;

Nxi = length(xi); % Number of grid points
Nzeta = length(zeta);

[Xi, Zeta] = meshgrid(xi,zeta);
%[Xi, Zeta] = meshgrid(linspace(xi_lowlim+ep, xi_highlim-ep, Nxi), linspace(zeta_lowlim+ep, zeta_highlim-ep, Ny));
w = Xi + 1i * Zeta;
z = eval(f_tilde,alpha*w);



% Evaluate the derivative of the SC map across the entire grid
dz = evaldiff(f_tilde, alpha*w);

% Calculate the Jacobian determinant
J = (alpha^2)*abs(dz).^2;
%}

med = median(median(J));
J(J == 0) = med; %this fixes J being 0 in the final part of the second reach

%J = J/med;

%save('branch_data')
%load('branch_data')

% Plot the Jacobian determinant as a 3D surface plot
figure;
surf(real(w), imag(w), J);
xlabel('Real Axis');
ylabel('Imaginary Axis');
title('Jacobian Determinant of SC Transformation');

%% Dividing the domain in sectors
node = ver(5);
vert = evalinv(f_tilde,node); % computing the critical node in phys space
vert = vert/alpha;
targ_xi = real(vert);
targ_zeta = imag(vert);

th_xi = find(xi<targ_xi, 1, 'last');
th_zeta = find(zeta<targ_zeta, 1, 'last');
w1 = alpha*w(:,1:th_xi); %branch 1 
w2 = alpha*w(1:th_zeta,th_xi:end); %branch 2
w3 = alpha*w(th_zeta+1:end,th_xi:end); %branch 3

if want_save == 1
    save(['angles= ', num2str(angles), ' widths= ', num2str(widths)])
end