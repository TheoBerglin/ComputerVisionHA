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
%% Plot projection
figure()
plotLines(start_H1, end_H1)
title('Lines after projection with H$_1$', 'interpreter', 'latex')
axis equal
figure()
plotLines(start_H2, end_H2)
title('Lines after projection with H$_2$', 'interpreter', 'latex')
axis equal
figure()
plotLines(start_H3, end_H3)
title('Lines after projection with H$_3$', 'interpreter', 'latex')
axis equal
figure()
plotLines(start_H4, end_H4)
title('Lines after projection with H$_4$', 'interpreter', 'latex')
axis equal

%% Line length
figure()
hist(lineLength(startpoints, endpoints))
figure()
subplot(2,2,1)
hist(lineLength(start_H1, end_H1))
title('H1')
subplot(2,2,2)
hist(lineLength(start_H2, end_H2))
title('H2')
subplot(2,2,3)
hist(lineLength(start_H3, end_H3))
title('H3')
subplot(2,2,4)
hist(lineLength(start_H4, end_H4))
title('H4')
%% Easier by hand
fprintf('Determinant H1 corner: %.2f\n',determinantUpperCorner(H1) )
fprintf('Determinant H2 corner: %.2f\n',determinantUpperCorner(H2) )
fprintf('Determinant H3 corner: %.2f\n',determinantUpperCorner(H3))
fprintf('Determinant H4 corner: %.2f\n',determinantUpperCorner(H4))

function determinant = determinantUpperCorner(H)
determinant = det(H(1:end-1,1:end-1)); 
end
function l = lineLength(start_points, end_points)
x = end_points(1,:) - start_points(1,:);
y = end_points(2,:) - start_points(2,:);

l = sqrt(x.*x+y.*y);

end
function [start_projection, end_projection] = calculateProjection(start_points, end_points, H)
start_projection = H*start_points;
end_projection = H*end_points;
start_projection = pflat(start_projection);
end_projection = pflat(end_projection);
end

function homogeneous = cartesian2Homogeneous(cart)
[~, m] = size(cart);
homogeneous = [cart; ones(1,m)];
end

function plotLines(s_p, e_p)
% Plots a blue line between each s_p and e_p
plot([s_p(1,:); e_p(1,:)], [s_p(2,:); e_p(2,:)], 'b-')

end