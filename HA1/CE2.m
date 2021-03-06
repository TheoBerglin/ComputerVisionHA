clear all, close all, clc
im = imread('compEx2.jpg');
load('compEx2.mat');

figure()
imagesc(im)
colormap gray

hold all
% Get the points in cartesian 
p1_cart = pflat(p1);
p2_cart = pflat(p2);
p3_cart = pflat(p3);

% Plot the points
pointPlot(p1_cart');
pointPlot(p2_cart');
pointPlot(p3_cart');

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

% Plot intersection point
pointPlot(I_cart')

% Calculate distance between line 1 and intersection point l2 and l3
distance = calculateDistanceLinePoint(l1, I_cart);
fprintf('The distance between line 1 and intersection point l2-l3 is: %.2f\n', distance);

function distance = calculateDistanceLinePoint(line, point)
% Calculates the distance between a point and a line
num = line'*[point; 1];
denum = line(1)^2+line(2)^2;
distance = abs(num)/sqrt(denum);
end

function coefficients = lineFromPoints(points_cart)
% returns [a b c]' as ax+by+c=0
p_diff = points_cart(:,2)-points_cart(:,1);
k = p_diff(2)/p_diff(1);
m = points_cart(2,2)-k*points_cart(1,2);
coefficients = [k -1 m]';
end
function pointPlot(points)
plot(points(:,1), points(:,2),'x','LineWidth',2,'MarkerSize',10, 'color', 'red');
end