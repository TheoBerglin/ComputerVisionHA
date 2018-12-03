%% Load data
clear all, close all, clc
load('CE2_essentials.mat')
load('assignment3data\compEx1data.mat')
im1 = imread('assignment3data\kronan1.JPG');
im2 = imread('assignment3data\kronan2.JPG');
F = data.F;
%F = [0 1 1;1 0 0;0 1 1];
%% Create camera matrices
P1 = [eye(3), [0 0 0]'];
e2 = null(F');
e2x = [0 -e2(3) e2(2); e2(3) 0 -e2(1);-e2(2) e2(1) 0];
P2 = [e2x*F, e2];
%% 
[x1_N, N1] = normalizePoints(x{1}, true);
x1_N = pflat(x1_N);
[x2_N, N2] = normalizePoints(x{2}, true);
x2_N = pflat(x2_N);
%% Triangulate data
triang_data = triangulatePoints(P1, P2, x1_N, x2_N);
%% Plot and compare
figure()
plotCompareCameraPoints(im1, pflat(N1\[triang_data.x_camera_1;ones(1, triang_data.n_points)]), x{1})

figure()
%plotCompareCameraPoints([], N2\[triang_data.x_camera_2;ones(1, triang_data.n_points)], x{2})
plotCompareCameraPoints([], pflat(N2\[triang_data.x_camera_2;ones(1, triang_data.n_points)]), x{2})

figure()
plot3DModel(triang_data.X)
%%
save('CE3_essentials', 'P1', 'P2');
%% Functions
function [x_norm, N] = normalizePoints(x, norm)
x = x./x(3,:); % Set third coordinate to 1

N = eye(3);
if norm
    mu = mean(x, 2);
    sigma = std(x,[], 2);
    N(1,1) = 1/sigma(1);
    N(2,2) = 1/sigma(2);
    N(1,3) = -mu(1)/sigma(1);
    N(2,3) = -mu(2)/sigma(2);
end
x_norm = N*x;

end
function v = solveDLT(M)
[~, S, V] = svd(M);
S = diag(S);
if any(S == 0)
    zero_sol = find(S == 0);
    v = V(:, zero_sol(1)-1);
else
    v = V(:,end);
end
end
function M = setUpM(P1, P2, x1, x2)
M = zeros(6,6);
M(1:3, 1:4) = P1;
M(4:6, 1:4) = P2;
M(1:3, 5) = -[x1; 1];
M(4:6, 6) = -[x2; 1];
end

function data = triangulatePoints(P1, P2, x1, x2)
n_points = size(x1,2);
data = struct('n_points', n_points, 'X', zeros(4, n_points),...
              'lambda1', zeros(1, n_points),...
              'lambda2', zeros(1, n_points));

for i=1:n_points
    M = setUpM(P1, P2, x1(:,i), x2(:,i));
    v = solveDLT(M);
    data.X(:, i) = v(1:4);
    data.lambda1(i) = v(5);
    data.lambda2(i) = v(6); 
end
%% 
data.x_camera_1 = pflat(P1*data.X./data.lambda1);
data.x_camera_2 = pflat(P2*data.X./data.lambda2);
end

function plotCompareCameraPoints(im, x_camera, x)

imagesc(im)
hold on
plot(x(1,:), x(2,:), '.','DisplayName','Image points')
plot(x_camera(1,:), x_camera(2,:), 'o', 'DisplayName','Projected')
legend
end

function plot3DModel(X)
plot3(X(1,:), X(2,:), X(3,:), '.')

end