%% Load data
clear all, close all, clc
load('assignment3data\compEx3data.mat')
load('assignment3data\compEx1data.mat')
%load('CE3_essentials.mat');
P1 = [eye(3) [0;0;0]];
P2 = [eye(3) [0;0;0]]; % Should come from comp ex 2
im1 = imread('assignment3data\kronan1.JPG');
im2 = imread('assignment3data\kronan2.JPG');
%% Settings
save_fig = false;
%% Create data structure
data_CE3 = createDataStructure(K,x);
data_CE3.P1 = P1;
data_CE3.P2 = P2;
%%
data_CE3 = extractInnerParameters(data_CE3);
%% Set up M for the DLT equation
data_CE3 = setUpM(data_CE3);
%% Solve DLT
data_CE3 = solveDLT(data_CE3);
%% Extract approximative essential matrix
data_CE3.Eapprox = reshape(data_CE3.v, [3,3]);
%% Create valid solution
data_CE3 = createValidEssentialMatrix(data_CE3);
%% Check valid solution ok
figure()
hist(diag(data_CE3.x2_N'*E*data_CE3.x1_N))
%% Compute essential matrix for the un-normalized system
data_CE3.E_UN = data_CE3.K'\data_CE3.E/data_CE3.K;
data_CE3 = computeEpipolarLines(data_CE3);
%% 20 random points
r = randperm(data_CE3.n_points, 20);
l_r = data_CE3.l1(:,r);
x2_r = data_CE3.x2(:,r);
%% Plot points and epipolar lines
figure()
plotMarkerAndEpipole(l_r, x2_r);
if save_fig
    saveFigure(sprintf('CE3_line_and_points_normalization_%s', string(norm)));
end
%% Compute distance
dist = data_CE3.l1.*data_CE3.x2;
dist = sum(dist);
figure()
histogram(dist, 100,'FaceAlpha', 1);
title(sprintf('Distances ($\\mu_D=$%.5f)', mean(dist)),...
    'interpreter', 'latex', 'FontSize', 24)

if save_fig
    saveFigure(sprintf('CE3_histogram_normalization_%s', string(norm)));
end

%% Save
save('CE4_essentials', data3)

%% Functions
function data = computeEpipolarLines(data)
data.l1 = computeEpipolarLine(data.E_UN, data.x1);
data.l2 = computeEpipolarLine(data.E_UN, data.x2);
end

function l = computeEpipolarLine(E, x)
l = E*x;
l = l./sqrt(repmat(l(1,:).^2+l(2,:).^2+l(3,:).^2, [3,1]));
end
function data = createValidEssentialMatrix(data)
[U ,~ ,V] = svd (data.Eapprox);
if det (U *V') >0
    data.E = U*diag ([1 1 0])* V';
else
    V = -V;
    data.E = U*diag ([1 1 0])* V';
end
end
function data = extractInnerParameters(data)
[data.R1, data.t1] = extractInnerParameter(data.K,data.P1);
[data.R2, data.t2] = extractInnerParameter(data.K, data.P2);
end
function tx = crossMatrix(t)
tx = [0 -t(3) t(2); t(3) 0 -t(1); -t(2) t(1) 0];
end
function [R, t] = extractInnerParameter(K, P)
tmp = K\P;
R = tmp(:,1:3);
t = tmp(:,4);
end
function data = createDataStructure(K, x)
data = struct('x1', x{1}, 'x2', x{2},...
    'K', K,'n_points', size(x{1},2),...
    'x1_N', K\x{1},'x2_N', K\x{2});

end

function data = solveDLT(data)
%% Solve v via SVD
data.v = solveAndAnalyzeSVD(data.M);
end

function Vn = solveAndAnalyzeSVD(M)
[~, S, V] = svd(M);
Vn = V(:,end); % Corresponds to smallest eigenvalue
analyzeResults(S, M, Vn)
end

function analyzeResults(S, M, V)
fprintf('The smallest eigenvalue is: %f\n', min(diag(S)))
fprintf('The value of ||Mv|| is: %f\n', norm(M*V))
end

function data = setUpM(data)
data.M = zeros(data.n_points, 9);
for i=1:data.n_points
    xx = data.x2_N(:,i)*data.x1_N(:,i)';
    data.M(i,:) = xx(:)';
end
end