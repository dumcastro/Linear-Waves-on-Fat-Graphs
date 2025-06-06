%% THIS IS THE MAIN/DEMO SCRIPT
clear all, clc, close all

%% It should run a whole example: create graph, process graph data, solve wave, process wave data...
Lx = 55;
widths = [5, 2.5, 2.5];
%angles = [0, pi - pi/12, pi+pi/12];
angles = [0, pi/2, 3*pi/2];
kappa = 0.05;
%% Testing FatGraph
%fg = FatGraph();

%% Testing create fat graph
%createFatGraph(Lx, widths, angles)

%% Testing process Graph data

%processGraphData()

%% Testing evolveWave

evolveWave(kappa, widths, angles)

%% Testing processWave

processWaveData(kappa, widths, angles)
