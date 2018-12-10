clear all, close all, clc;
load('assignment4data\compEx1data.mat')
im1 = imread('assignment4data\house1.jpg');
im2 = imread('assignment4data\house2.jpg');
save_fig = false;
%%
Xflat = pflat(X);
[plane, dRMS] = solveTotalLeastSquare(X);
printRMSEerror(dRMS)
%% Ransac
[planeRansac, inlinersRansac] = calculatePlaneRANSAC(3, 40,0.1,X);
fprintf('Number of inliners RANSAC: %d\n', length(inlinersRansac))
dRMSRansac = calculateRMSDistance(planeRansac, X);
printRMSEerror(dRMSRansac);
planeDistRansac = pointPlaneDistance(planeRansac, X);
figure()
histogram(planeDistRansac, 100,'FaceAlpha', 1)
if save_fig
    saveFigureOwn('CE1_RANSAC_distance_hist');
end

%% Least square only inliers
XInliners = X(:,inlinersRansac);
[planeInliners, dRMSInliners] = solveTotalLeastSquare(XInliners);
printRMSEerror(dRMSInliners)
planeDistInliners = pointPlaneDistance(planeInliners, X);
figure()
histogram(planeDistInliners, 100,'FaceAlpha', 1)
if save_fig
    saveFigureOwn('CE1_inliners_least_square');
end
%% Plot projection of inliners into the images
figure()
imagesc(im1)
hold on
projectAndPlotData(P{1}, XInliners)
if save_fig
    saveFigureOwn('CE1_inline_projections_1');
end
figure()
imagesc(im2)    
hold on
projectAndPlotData(P{2}, XInliners)
if save_fig
    saveFigureOwn('CE1_inline_projections_2');
end
%%
P1_N = K\P{1};
P2_N = K\P{2};
planeRansac = planeRansac./planeRansac(4);
R = P2_N(:, 1:3);
t = P2_N(:, 4);
pi = planeRansac(1:3);
H = R-t*pi';

figure()
imagesc(im1)
hold on
plot2DPoint(x)
if save_fig
    saveFigureOwn('CE1_10_points');
end

figure()
imagesc(im2)
hold on
x_N = K\x; % Works for normalized points
plot2DPoint(pflat(K*(H*x_N)))
if save_fig
    saveFigureOwn('CE1_10_points_homography_projection');
end
function printRMSEerror(error)
fprintf('The RMS error is: %.2f\n', error)
end
function projectAndPlotData(P,X)
x  = pflat(P*X);
plot2DPoint(x)
end
function plot2DPoint(x)
plot(x(1,:), x(2,:), '.', 'MarkerSize', 14)
end
function distance = pointPlaneDistance(plane, X)
distance = plane'*X./(sum(plane(1:3).^2));
distance = abs(distance);
end

function [plane, dRMS] = solveTotalLeastSquare(X)
meanX = mean(X,2);
Xtilde = X-repmat(meanX, [1, size(X,2)]);
M = Xtilde(1:3, :)*Xtilde(1:3, :)';
%% Solve a, b, c
[V, ~] = eig(M);
sol = V(:,end);
%% Solve d
d = -sol'*meanX(1:3);
%% Plane solution
plane = [sol;d];
dRMS = calculateRMSDistance(plane, X);

end

function [bestPlane, maxInliners] = calculatePlaneRANSAC(m, rRuns, threshold, X)
n_points = size(X,2);
maxInliners = [];
bestPlane = 0;
for i = 1:rRuns
    randIndices = randperm(n_points, m);
    Xsub = X(:, randIndices);
    plane = null(Xsub');
    plane = plane./norm(plane(1:3));
    inliners = getInliners(plane, threshold, X);
    if sum(inliners) > sum(maxInliners)
       maxInliners = inliners; 
       bestPlane = plane;
    end
end
end
function inliners = getInliners(plane, threshold, X)
inliners = abs(plane'*X) <= threshold;
end
function dRMS = calculateRMSDistance(plane, points)
m = size(points,2);
points = points./points(4,:);
nom =(plane'*points).^2;
denom = sum(plane(1:3).^2)*m;
dRMS = sqrt(sum(nom)/denom);

end

function saveFigureOwn(name)
export_fig(sprintf('Results/%s.pdf', name),...
        '-pdf','-transparent');
end
