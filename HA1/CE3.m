clc, clear all, close all
load('assignment1data/compEx3.mat')
%% Plot initial data
figure()
plotLines(startpoints, endpoints)
%% Add the different projection matrices

H1 = [sqrt(3) -1 1; 1 sqrt(3) 1; 0 0 2];
H2 = [1 -1 1; 1 1 0; 0 0 1];
H3 = [1 1 0; 0 2 0; 0 0 1];
H4 = [sqrt(3) -1 1; 1 sqrt(3) 1; 1/4 1/2 2];
%% Get homogeneous coordinates
startpoints_h = cartesian2Homogeneous(startpoints);
endpoints_h = cartesian2Homogeneous(endpoints);
%% Point projection
[start_H1, end_H1] = calculateProjection(startpoints_h, endpoints_h, H1);
[start_H2, end_H2] = calculateProjection(startpoints_h, endpoints_h, H2);
[start_H3, end_H3] = calculateProjection(startpoints_h, endpoints_h, H3);
[start_H4, end_H4] = calculateProjection(startpoints_h, endpoints_h, H4);


function [start_projection, end_projection] = calculateProjection(start_points, end_points, H)
start_projection = H*start_points;
end_projection = H*end_points;

end

function homogeneous = cartesian2Homogeneous(cart)
[~, m] = size(cart);
homogeneous = [cart; ones(1,m)];
end

function plotLines(s_p, e_p)
% Plots a blue line between each s_p and e_p
plot([s_p(1,:); e_p(1,:)], [s_p(2,:); e_p(2,:)], 'b-')

end