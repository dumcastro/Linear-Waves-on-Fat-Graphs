%% THIS IS THE MAIN/DEMO SCRIPT
clear all, clc, close all


%% Main arguments
widths = [5, 2.5, 2.5];
angles = [0, pi - pi/24, pi + pi/3];
kappa = 0.2;

lambda_f = widths(1)/kappa;
travel_distance = 3;
Lx = lambda_f * (travel_distance + 1) / 2;

%% Secondary parameters
parameter_station % Go through preferred secondary arguments


%% Testing FatGraph
%fg = FatGraph();

%% Testing create fat graph
createFatGraph(Lx, widths, angles);

%% Testing process Graph data

%processGraphData(Lx, widths, angles)

%% Testing evolveWave

evolveWave(kappa, widths, angles,wave_options)

%% Testing processWave

processWaveData(kappa, widths, angles)
