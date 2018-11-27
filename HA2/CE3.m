clear all, clc, close all
load('compEx3data.mat')
%% Load settings

settings1 = struct('keep_points', 1:37,...
                   'normalize', true,...
                   'img_name', 'normalized');

settings2 = struct('keep_points', 1:37,...
                   'normalize', false,...
                   'img_name', 'not_normalized');
settings3 = struct('keep_points', [1 4 13 16 25 28 31],...
                   'normalize', false,...
                   'img_name', 'not_normalized_selective_points');
save_fig = false;
settings = settings3;
%% Plot figures and points
figure()
subplot(1,2,1)
im1 = imread('cube1.JPG');
imagesc(im1)
hold on
x1_cart = pflat(x{1});
plot(x1_cart(1,:), x1_cart(2,:), '.')
axis equal

subplot(1,2,2)
im2 = imread('cube2.JPG');
imagesc(im2)
hold on
x2_cart = pflat(x{2});
plot(x2_cart(1,:), x2_cart(2,:), '.')
axis equal

%% Create data structure
data = createDataStructure(x, Xmodel, settings);
x1_cart = x1_cart(:,settings.keep_points);
x2_cart = x2_cart(:,settings.keep_points);
data = normalizeData(data, data.settings.normalize);

%% Set up the DLT
data = setUpDLT(data);
%% Solve v via SVD
data = solveDLT(data);
%% Create cameras
data = createCameras(data);
%% Project points thorugh camera
data = addCameraProjectedPoints(data);
%% Plot everything
plotEndResultData(data, x1_cart, x2_cart, save_fig)
%% Compute inner parameters of camera 1
[~, R1_UN] = rq(data.P1_UN)
%% RMS error
erms1 = calculateRMSError(x1_cart, pflat(data.x1_camera));
erms2 = calculateRMSError(x2_cart, pflat(data.x2_camera));
fprintf('RMS error 1: %.2f \nRMS error 2: %.2f\n', erms1, erms2);
% Type Error 1 Error 2
% Normalized 22.9338 22.9840
% Not normalized:  51.5999 49.8014
% Not normalized selective 3.3982    4.2668
% Not normalized 2.0524    1.8626
%% Plot model points, camera etc
if length(data.settings.keep_points) == 37
    figure()
    plot3([data.Xmodel(1, startind ); data.Xmodel(1, endind )] ,...
        [data.Xmodel(2, startind ); data.Xmodel(2, endind )] ,...
        [data.Xmodel(3, startind ); data.Xmodel(3, endind )], 'b-');
    plot3(data.Xmodel(1,:), data.Xmodel(2,:), data.Xmodel(3,:),'.')
    hold on
    plotcams({data.P1_UN, data.P2_UN})
end


function data = createDataStructure(x, Xmodel, settings)
data = struct('x1', x{1}(:,settings.keep_points),...
              'x2', x{2}(:,settings.keep_points),...
              'Xmodel', Xmodel(:,settings.keep_points),...
              'settings', settings);
end
function erms = calculateRMSError(xmeas, xproj)
diff = xmeas-xproj;
n = size(xmeas,2);
erms = sqrt(sum(vecnorm(diff,2,1))/n);
end
function analyzeResults(S, M, V)
fprintf('The smallest eigenvalue is: %f\n', min(diag(S)))
fprintf('The value of ||Mv|| is: %f\n', norm(M*V))
end
function M = setUpM(x, X)
n_values = size(x,2);
M = zeros(3*n_values, 12+n_values);
for i=1:n_values
    
    M(3*(i-1)+1,1:4) = X(:,i)';
    M(3*(i-1)+2, 5:8) = X(:,i)';
    M(3*i, 9:12) = X(:,i)';
    
    M(3*(i-1)+1, 12+i) = -x(1,i);
    M(3*(i-1)+2, 12+i) = -x(2,i);
    M(3*i, 12+i) = x(3,i);
end

end

function data = normalizeData(data, norm)

[data.x1_n, data.N1] = normalizePoints(data.x1, norm);
[data.x2_n, data.N2] = normalizePoints(data.x2, norm);

end

function [x_norm, N] = normalizePoints(x, Norm)
x = x./x(3,:); % Set third coordinate to 1

mu = mean(x, 2);
sigma = std(x,[], 2);

N = eye(3);
if Norm
    N(1,1) = 1/sigma(1);
    N(2,2) = 1/sigma(2);
    N(1,3) = -mu(1)/sigma(1);
    N(2,3) = -mu(2)/sigma(2);
end
x_norm = N*x;

if Norm
   plotNormalizedPoints(x_norm);
end

end

function plotNormalizedPoints(x_norm)
figure()
x_flat = pflat(x_norm);
plot(x_flat(1,:), x_flat(2,:), '.')
x_std = std(x_flat,[],2);
x_mean = mean(x_flat,2);
title(sprintf('Mean: [%.2f, %.2f] Standard deviation: [%.2f, %.2f]', x_mean, x_std)); 

end

function data = setUpDLT(data)
data.XmodelH = [data.Xmodel; ones(1, size(data.Xmodel,2))];
data.M1 = setUpM(data.x1_n, data.XmodelH);
data.M2 = setUpM(data.x2_n, data.XmodelH);
end
function data = solveDLT(data)
%% Solve v via SVD
data.V1n = solveAndAnalyzeSVD(data.M1);
data.V2n = solveAndAnalyzeSVD(data.M2);
end

function Vn = solveAndAnalyzeSVD(M)
[~, S, V] = svd(M);
Vn = V(:,end);
analyzeResults(S, M, Vn)
end

function data = createCameras(data)
data.P1 = createCameraMatrix(data.V1n, data.XmodelH);
data.P2 = createCameraMatrix(data.V2n, data.XmodelH);

data.P1_UN = data.N1 \ data.P1;
data.P2_UN = data.N1 \ data.P2;
end

function P = createCameraMatrix(Vn, XmodelH)
P = reshape(Vn(1:12), [4 3])';
testProj = P*XmodelH;
if any(testProj(3,:)<0)
    P = -P;
end

end

function data = addCameraProjectedPoints(data)
data.x1_camera = data.P1_UN*data.XmodelH;
data.x2_camera = data.P2_UN*data.XmodelH;
end

function plotEndResultData(data, x1_cart, x2_cart, save_fig)
figure()
%subplot(1,2,1)
im1 = imread('cube1.JPG');
imagesc(im1)
hold on
plot(x1_cart(1,:), x1_cart(2,:), '.')
x1_camera_cart = pflat(data.x1_camera);
plot(x1_camera_cart(1,:), x1_camera_cart(2,:), 'o')
title('Camera 1 projective points', 'interpreter', 'latex','FontSize', 24)
if save_fig
    export_fig(sprintf('Results/CE3_%s_Camera_1.pdf', data.settings.img_name),...
        '-pdf','-transparent');
end
figure()
im2 = imread('cube2.JPG');
imagesc(im2)
hold on
plot(x2_cart(1,:), x2_cart(2,:), '.')
x2_camera_cart = pflat(data.x2_camera);
plot(x2_camera_cart(1,:), x2_camera_cart(2,:), 'o')
title('Camera 2 projective points', 'interpreter', 'latex','FontSize', 24)
if save_fig
    export_fig(sprintf('Results/CE3_%s_Camera_2.pdf', data.settings.img_name),...
        '-pdf','-transparent');
end

end