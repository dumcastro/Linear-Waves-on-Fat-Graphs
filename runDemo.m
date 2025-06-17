%% THIS IS THE MAIN/DEMO SCRIPT
clear all, clc, close all


%% Main arguments
widths = [5, 2.5, 2.5];
angles = [0, pi - pi/24, pi + pi/3]; %angles calculated 
kappa = 0.2;

lambda_f = widths(1)/kappa;
travel_distance = 4;
Lx = lambda_f * (travel_distance + 1) / 2;

%% Secondary parameters
parameter_station % Go through preferred secondary arguments


%% Testing FatGraph
%fg = FatGraph(Lx, widths, angles)

%% Testing create fat graph
createFatGraph(Lx, widths, angles,graph_options);

%% Testing process Graph data

processGraphData(Lx, widths, angles,graph_vis_options)

%% Testing evolveWave

evolveWave(kappa, widths, angles,wave_options)

%% Testing processWave

processWaveData(kappa, widths, angles,wave_vis_options)
