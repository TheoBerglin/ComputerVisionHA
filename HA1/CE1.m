%% Computer exercise 1
clc, clear all, close all
load('compEx1.mat')
% Test the function on the data
x2D_flat = pflat(x2D);
x3D_flat = pflat(x3D);
% Plot the results
f = figure();
plot(x2D_flat(1,:), x2D_flat(2,:), '.');
axis equal
export_fig('Results/CE_1_x2D_figure.pdf', '-pdf','-transparent');
f = figure();
plot3(x3D_flat(1,:), x3D_flat(2,:),x3D_flat(3,:), '.');
axis equal
export_fig('Results/CE_1_x3D_figure.pdf', '-pdf','-transparent');
