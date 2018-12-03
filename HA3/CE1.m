clear all, close all, clc
load('assignment3data\compEx1data.mat')
%% Settings
norm = false;
save_fig = false;

%% Create data structure
data = createDataStructure(x, norm);
%% Set up M for the DLT equation
data = setUpM(data);
%% Solve DLT
data = solveDLT(data);
%% Create fundamental matrix 
data = createNormalizedFundamentalMatrix(data);
%% Analyze fundamental matrix
analyzeFundamentalMatrix(data.Fn, data.x1_N, data.x2_N);
%% Compute normalized fundamental matrix
data = computeNormalizedFundamentalMatrix(data);
%% Compute epipolar lines
data = computeEpipolarLines(data);
%% 20 random points
r = randperm(data.n_points, 20);
l_r = data.l1(:,r);
x2_r = data.x2(:,r);
%% Plot points and epipolar lines
figure()
plotMarkerAndEpipole(l_r, x2_r);
if save_fig
    saveFigure(sprintf('CE1_line_and_points_normalization_%s', string(norm)));
end
%% Compute distance
dist = data.l1.*data.x2;
dist = sum(dist);
figure()
histogram(dist, 100,'FaceAlpha', 1);
title(sprintf('Distances ($\\mu_D=$%.5f)', mean(dist)),...
    'interpreter', 'latex', 'FontSize', 24)

if save_fig
    saveFigure(sprintf('CE1_histogram_normalization_%s', string(norm)));
end
%% Save for CE2
save('CE2_essentials', 'data')
function saveFigure(name)
export_fig(sprintf('Results/%s.pdf', name),...
        '-pdf','-transparent');
end
function plotMarkerAndEpipole(ep_lines, x)
im2 = imread('kronan2.jpg');
imagesc(im2)
colormap gray
hold all
rital(ep_lines)
plot(x(1,:), x(2,:), 'x', 'MarkerSize', 10,'LineWidth',2)

end

function data = computeEpipolarLines(data)
data.l1 = computeEpipolarLine(data.F, data.x1);
data.l2 = computeEpipolarLine(data.F, data.x2);
end

function l = computeEpipolarLine(F, x)
l = F*x;
l = l./sqrt(repmat(l(1,:).^2+l(2,:).^2+l(3,:).^2, [3,1]));
end
function data = computeNormalizedFundamentalMatrix(data)
data.F = data.N2'*data.Fn*data.N1;
end
function analyzeFundamentalMatrix(F, x1, x2)
d = det(F);
fprintf('The determinant is: %.5f\n', d)
ep_constraint = diag(x2'*F*x1);
fprintf('Maximum value of the epipolar constraint: %.5f\n',...
    max(abs(ep_constraint)))
figure()
plot(ep_constraint)
title('Epipolar constraints')
end
function data = createNormalizedFundamentalMatrix(data)
data.Fn = reshape(data.v, [3 3]);
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
function data = createDataStructure(x, norm)
data = struct('x1', x{1}, 'x2', x{2});
[data.x1_N, data.N1] = normalizePoints(data.x1,norm);
[data.x2_N, data.N2] = normalizePoints(data.x2,norm);
data.n_points = size(data.x1,2);
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