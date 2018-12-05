%% Load data
clear all, close all, clc
load('assignment3data\compEx3data.mat')
load('assignment3data\compEx1data.mat')
load('CE4_essentials.mat');
P1 = [eye(3) [0;0;0]];
im1 = imread('assignment3data\kronan1.JPG');
im2 = imread('assignment3data\kronan2.JPG');
%% Triangulate points
W = [0 -1 0; 1 0 0;0 0 1];
save_fig = true;
E = data_CE3.E;
solutions = extractCamera2Solutions(E, W);
data_CE4 = createDataStructure(x, K);
data_CE4.P1_N = K\P1;
%% Which solution is infront of the cameras
field_names =fieldnames(solutions);
for i=1:length(field_names)
   figure()
   t_data = triangulatePoints(P1, solutions.(field_names{i}), pflat(data_CE4.x1_N), pflat(data_CE4.x2_N));
   plot3DModel(pflat(t_data.X));
   hold on
   plotcams({K*data_CE4.P1_N K*solutions.(field_names{i})})
end

%% Extract correct 
P2_N = solutions.P2_4;
data_CE4.t_data = triangulatePoints(P1, P2_N, pflat(data_CE4.x1_N), pflat(data_CE4.x2_N));
%% Unnormalized cameras
data_CE4.P1_UN = data_CE3.K*P1;
data_CE4.P2_UN = data_CE3.K*P2_N;
%% Plots 
figure()
plotCompareCameraPoints(im1, pflat(data_CE4.P1_UN*data_CE4.t_data.X./data_CE4.t_data.lambda1), x{1})

if save_fig
    saveFigureOwn('CE4_projected_points_camera_1');
end
figure()
plotCompareCameraPoints(im2, pflat(data_CE4.P2_UN*data_CE4.t_data.X./data_CE4.t_data.lambda2), x{2})

if save_fig
    saveFigureOwn('CE4_projected_points_camera_2');
end
figure()
plot3DModel(pflat(data_CE4.t_data.X))
hold all
plotcams({K*data_CE4.P1_N K*P2_N})
%%
if save_fig
    saveFigureOwn('CE4_3D_points');
end
%% functions
function data = createDataStructure(x, K)
data = struct('x1', x{1}, 'x2', x{2});
data.x1_N = normalizePoints(data.x1,K);
data.x2_N = normalizePoints(data.x2,K);
data.n_points = size(data.x1,2);
end


function [x_norm] = normalizePoints(x, K)
x = x./x(3,:); % Set third coordinate to 1


x_norm = K\x;

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


function solutions = extractCamera2Solutions(E, W)
[U, ~, V] = svd(E);
u3 = U(:,3);
solutions = struct('P2_1', [U*W*V' u3],...
    'P2_2', [U*W*V' -u3],...
    'P2_3', [U*W'*V' u3],...
    'P2_4', [U*W'*V' -u3]);
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

function saveFigureOwn(name)
export_fig(sprintf('Results/%s.pdf', name),...
        '-pdf','-transparent');
end
