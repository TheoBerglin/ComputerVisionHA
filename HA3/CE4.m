%% Load data
clear all, close all, clc
load('assignment3data\compEx3data.mat')
load('assignment3data\compEx1data.mat')
%load('CE3_essentials.mat');
%load('CE4_essentials.mat');
P1 = [eye(3) [0;0;0]];
P2 = [eye(3) [0;0;0]]; % Should come from comp ex 2
im1 = imread('assignment3data\kronan1.JPG');
im2 = imread('assignment3data\kronan2.JPG');

%% functions

function data = triangulateData(data, solutions, P1)
field_names =fieldnames(solutions);
n_pos_points = 0;
for i=1:length(field_names)
    P2_tmp = solutions(field_names{i});
    t_data = triangulatePoints(P1, P2_tmp, data.x1_n, data.x2_n);
    pos_points = numberOfPositivePoints(t_data.X);
    if pos_points > n_pos_points
        data.t_data = t_data;
        n_pos_points = pos_points;
        data.P2 = P2_tmp;
    end
end
end
function pos_points = numberOfPositivePoints(X)
pos_points = sum(X(end,:)>0);
end
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


function solutions = extractCamera2Solutions(E, u3, W)
[U, ~, V] = svd(E);

solutions = struct('P2_1', [U*W*V' u3],...
    'P2_2', [U*W*V' -u3],...
    'P2_3', [U*W'*V' u3],...
    'P2_4', [U*W'*V' -u3]);

end