%% Load data
clear all, close all, clc
load('assignment3data\compEx3data.mat')
load('assignment3data\compEx1data.mat')
load('CE3_essentials.mat');
%P1 = [eye(3) [0;0;0]];
%P2 = [eye(3) [0;0;0]]; % Should come from comp ex 2
im1 = imread('assignment3data\kronan1.JPG');
im2 = imread('assignment3data\kronan2.JPG');
%% Settings
save_fig = true;
%% Create data structure
data_CE3 = createDataStructure(K,x);
data_CE3.P1 = P1;
data_CE3.P2 = P2;
%%
%data_CE3 = extractInnerParameters(data_CE3);
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
hist(diag(data_CE3.x2_N'*data_CE3.E*data_CE3.x1_N))
%% Compute essential matrix for the un-normalized system
data_CE3.F = data_CE3.K'\data_CE3.E/data_CE3.K;
data_CE3 = computeEpipolarLines(data_CE3);
%% 20 random points
r = randperm(data_CE3.n_points, 20);
l_r = data_CE3.l1(:,r);
x2_r = data_CE3.x2(:,r);
%% Plot points and epipolar lines
figure()
plotMarkerAndEpipole(l_r, x2_r);
if save_fig
    saveFigureOwn('CE3_line_and_points_normalization');
end
%% Compute distance
dist = data_CE3.l1.*data_CE3.x2;
dist = abs(sum(dist));
figure()
histogram(dist, 100,'FaceAlpha', 1);
title(sprintf('Distances ($\\mu_D=$%.5f)', mean(dist)),...
    'interpreter', 'latex', 'FontSize', 24)

if save_fig
    saveFigureOwn('CE3_histogram');
end

%% Save
save('CE4_essentials', 'data_CE3')
data_CE3.E./data_CE3.E(3,3)
%% Functions
function data = computeEpipolarLines(data)
data.l1 = computeEpipolarLine(data.F, data.x1);
data.l2 = computeEpipolarLine(data.F, data.x2);
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

function plotMarkerAndEpipole(ep_lines, x)
im2 = imread('kronan2.jpg');
imagesc(im2)
colormap gray
hold all
rital(ep_lines)
plot(x(1,:), x(2,:), 'x', 'MarkerSize', 10,'LineWidth',2)

end
function saveFigureOwn(name)
export_fig(sprintf('Results/%s.pdf', name),...
        '-pdf','-transparent');
end