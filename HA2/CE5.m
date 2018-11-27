clear all, close all, clc;
%CE3
%CE4
%clearvars -except CE5_essentials data
%save('CE5_essentials', 'CE5_essentials', 'data');
load('CE5_essentials.mat');
close all, clc 
%% 
x1 = CE5_essentials.x1;
x2 = CE5_essentials.x2;
im1 = imread('cube1.jpg');
im2 = imread('cube2.jpg');
P1 = data.P1;
P2 = data.P2;
%% data_storage
data1 = triangulatePoints(P1, P2, x1, x2);
%%
figure()
subplot(1,2,1)
plotCompareCameraPoints(im1, data1.x_camera_1, x1)
subplot(1,2,2)
plotCompareCameraPoints(im2, data1.x_camera_2, x2)

%% Normalize cameras
[P1_N, K1] = normalizeCamera(P1);
[P2_N, K2] = normalizeCamera(P2);
%x1_N = K1\[x1; ones(1, size(x1,2))];
%x2_N = K2\[x2; ones(1, size(x2,2))];
%% Triangulate normalized cameras
%data2 = triangulatePoints(P1_N, P2_N, pflat(x1_N), pflat(x2_N));
data2 = triangulatePoints(P1_N, P2_N, x1, x2);
%% Plot normalized cameras
figure()
subplot(1,2,1)
plotCompareCameraPoints(im1, data2.x_camera_1, x1)
subplot(1,2,2)
plotCompareCameraPoints(im2, data2.x_camera_2, x2)
%% Get the good points
good_points = getGoodPoints(x1, data1.x_camera_1, x2, data1.x_camera_2);
X_good = data1.X(:, good_points);
x1_good = x1(:, good_points);
x2_good = x2(:, good_points);
good_proj_1 = P1*X_good;
good_proj_2 = P2*X_good;
%% Plot only good points
figure()
subplot(1,2,1)
plotCompareCameraPoints(im1, good_proj_1, x1_good)
subplot(1,2,2)
plotCompareCameraPoints(im2, good_proj_2, x2_good)
%%

setUpM(P1_t, P2_t, x1_t, x2_t)
function good_points = getGoodPoints(x1, xproj1, x2, xproj2)
good_points = (sqrt(sum((x1 - xproj1 (1:2 ,:)).^2)) < 3 & ...
               sqrt(sum ((x2 - xproj2(1:2 ,:)).^2)) < 3);
end
function [P_N, K] = normalizeCamera(P)
[K, ~] = rq(P);
P_N = K\P;

end

function v = solveDLT(M)
[U, S, V] = svd(M);
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
plot(x(1,:), x(2,:), '.')
plot(x_camera(1,:), x_camera(2,:), 'o')

end




