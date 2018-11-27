clear all, clc, close all
load('compEx3data.mat')
%% Plot figures and points
figure()
subplot(1,2,1)
im1 = imread('cube1.JPG');
imagesc(im1)
hold on
x1_cart = pflat(x{1});
plot(x1_cart(1,:), x1_cart(2,:), '.')
axis equal

keep_points = [1 4 13 16 25 28 31];
x{1} = x{1}(:,keep_points);
x{2} = x{2}(:,keep_points);
Xmodel = Xmodel(:, keep_points);



subplot(1,2,2)
im2 = imread('cube2.JPG');
imagesc(im2)
hold on
x2_cart = pflat(x{2});
plot(x2_cart(1,:), x2_cart(2,:), '.')
axis equal
%% Normalize the measured points
x_normalized = cell(1,2);
normalize_points = false;
[x_normalized{1}, N1] = normalizePoints(x{1}, normalize_points);
[x_normalized{2}, N2] = normalizePoints(x{2}, normalize_points);

figure()
subplot(1,2,1)
x_flat = pflat(x_normalized{1});
plot(x_flat(1,:), x_flat(2,:), '.')
std(x_flat,[],2)
mean(x_flat,2)

subplot(1,2,2)
x_flat = pflat(x_normalized{2});
plot(x_flat(1,:), x_flat(2,:), '.')
std(x_flat,[],2)
mean(x_flat,2)
%% Set up the DLT
XmodelH =[Xmodel; ones(1,size(Xmodel,2))];
M1 = setUpM(x_normalized{1}, XmodelH);
M2 = setUpM(x_normalized{2}, XmodelH);
%% Solve v via SVD
[U1, S1, V1] = svd(M1);
[U2, S2, V2] = svd(M2);
%% Analyze results
V1n = V1(:,end);
V2n = V2(:,end);
analyzeResults(S1, M1, V1n)
analyzeResults(S1, M1, V1n)
%% Create camera
P1 =  -reshape(V1n(1:12), [4 3])';
P2 =  -reshape(V2n(1:12), [4 3])';
%% Analyze positive solution
tmpX = P1*XmodelH;
any(tmpX(3,:).*XmodelH(4,:)<0)
%% Let's get the unnormalized cameras
P1_UN = N1\P1;
P2_UN = N2\P2;
%% Project points thorugh camera
x1_camera = P1_UN*XmodelH;
x2_camera = P2_UN*XmodelH;
%% Plot everything
figure()
%subplot(1,2,1)
im1 = imread('cube1.JPG');
imagesc(im1)
hold on
x1_cart = pflat(x{1});
plot(x1_cart(1,:), x1_cart(2,:), '.')
x1_camera_cart = pflat(x1_camera);
plot(x1_camera_cart(1,:), x1_camera_cart(2,:), 'o')
title('Camera 1 projective points', 'interpreter', 'latex','FontSize', 24)
%export_fig('Results/CE3_normalized_Camera_1.pdf', '-pdf','-transparent');
figure()
im2 = imread('cube2.JPG');
imagesc(im2)
hold on
x2_cart = pflat(x{2});
plot(x2_cart(1,:), x2_cart(2,:), '.')
x2_camera_cart = pflat(x2_camera);
plot(x2_camera_cart(1,:), x2_camera_cart(2,:), 'o')
title('Camera 2 projective points', 'interpreter', 'latex','FontSize', 24)
%export_fig('Results/CE3_normalized_Camera_2.pdf', '-pdf','-transparent');
%axis equal
% Looks reasonable, we should match the points perfectly as we have the
% minimum number of needed

%% Plot model points, camera etc
figure()
%plot3([Xmodel(1, startind ); Xmodel(1, endind )] ,...
%    [Xmodel(2, startind ); Xmodel(2, endind )] ,...
%    [Xmodel(3, startind ); Xmodel(3, endind )], 'b-');
plot3(Xmodel(1,:), Xmodel(2,:), Xmodel(3,:),'.')
hold on
plotcams({P1_UN, P2_UN})

%% Compute inner parameters of camera 1
[K1_UN, R1_UN] = rq(P1_UN)
%% RMS error
erms1 = calculateRMSError(x1_cart, x1_camera_cart)
erms2 = calculateRMSError(x2_cart, x2_camera_cart)
% Type Error 1 Error 2
% Normalized 22.9338 22.9840
% Not normalized:  51.5999 49.8014
% Not normalized selective 3.3982    4.2668
% Not normalized 2.0524    1.8626
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

end