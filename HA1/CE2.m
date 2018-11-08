clear all, close all, clc
im = imread('compEx2.jpg');

im_dim = size(im);
imagesc(im)
colormap gray

load('compEx2.mat');
hold all
% Get the points in cartesian 
p1_cart = pflat(p1);
p2_cart = pflat(p2);
p3_cart = pflat(p3);

% Plot the points
pointPlot(p1_cart, im_dim);
pointPlot(p2_cart, im_dim);
pointPlot(p3_cart, im_dim);

% Calculate lines through points
l1 = lineFromPoints(p1_cart);
l2 = lineFromPoints(p2_cart);
l3 = lineFromPoints(p3_cart);

% Plot the lines
rital(l1)
rital(l2)
rital(l3)

% Compute point of intersection between l2 and l3
L = [l2, l3];
I = null(L');
I_cart = pflat(I);



function coefficients = lineFromPoints(points_cart)
% returns [a b c]' as ax+by+c=0
p_diff = points_cart(:,2)-points_cart(:,1);
k = p_diff(2)/p_diff(1);
m = points_cart(2,2)-k*points_cart(1,2);
coefficients = [k -1 m]';
%line_coeff = polyfit([points_cart(1,1), points_cart(1,2)], [points_cart(2,1), points_cart(2,2)], 1);
%coefficients = [1/line_coeff(2), -line_coeff(1)/line_coeff(2), +1]';
end
function pointPlot(points, im_dim)
plot(points(:,1), points(:,2),'x');
end