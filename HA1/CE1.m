%% Computer exercise 1
clc, clear all, close all
load('compEx1.mat')
%% Test the flat function 
x2D_flat = pflat(x2D);
x3D_flat = pflat(x3D);
%% Plot the results
f = figure();
plot(x2D_flat(1,:), x2D_flat(2,:), '.');
axis equal
xlabel('$x_1$', 'Interpreter','latex')
ylabel('$x_2$','Interpreter','latex')
axis equal
export_fig('Results/CE_1_x2D_figure.pdf', '-pdf','-transparent');
% Plot 3D
f = figure();
plot3(x3D_flat(1,:), x3D_flat(2,:),x3D_flat(3,:), '.');
xlabel('$x_1$', 'Interpreter','latex')
ylabel('$x_2$','Interpreter','latex')
zlabel('$x_3$', 'Interpreter','latex')
axis equal
export_fig('Results/CE_1_x3D_figure.pdf', '-pdf','-transparent');
