clear all, close all, clc
im = imread('compEx2.jpg');

imagesc(im)
colormap gray

load('compEx2.mat');
hold all
% Get the points in cartesian 
p1_cart = pflat(p1);
p2_cart = pflat(p2);
p3_cart = pflat(p3);

% Plot the points
pointPlot(p1_cart)
pointPlot(p2_cart)
pointPlot(p3_cart)

% Calculate lines through points
l1 = lineFromPoints(p1_cart);
l2 = lineFromPoints(p1_cart);
l3 = lineFromPoints(p1_cart);

% Plot the lines
rital(l1, 1)
rital(l2, 1)
rital(l3, 1)




function coefficients = lineFromPoints(points_cart)
% returns [a b c]' as ax+by+c=0
p_diff = points_cart(:,2)-points_cart(:,1);
k = p_diff(2)/p_diff(1);
m = points_cart(2,2)-k*points_cart(1,2);
coefficients = [k -1 m]';
%line_coeff = polyfit([points_cart(1,1), points_cart(1,2)], [points_cart(2,1), points_cart(2,2)], 1);
%coefficients = [1/line_coeff(2), -line_coeff(1)/line_coeff(2), +1]';
end
function pointPlot(points)
plot(points(:,1), points(:,2),'x');
end