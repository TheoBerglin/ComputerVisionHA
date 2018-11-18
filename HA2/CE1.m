%% Load the data
clear all, clc, close all
load('compEx1data.mat')
%% Plot the reconstruction
figure(1)
X_cart = pflat(X);
plot3Dpoints(X_cart)
hold on
plotcams(P)
axis equal
%% Project the 3D points into one of the cameras
im_id = 4;
points_for_camera = getVisiblePoints(X_cart, x, im_id);

% Points for plotting and image
projected_points = P{im_id}*points_for_camera;
projected_points = pflat(projected_points);
im = readRotateImage(imfiles{im_id});
%Plotting
figure(2);
imagesc(im)
colormap gray
hold on
plot(projected_points(1,:), projected_points(2,:), '.')
axis equal
%% Projections
T1 = [1 0 0 0; 0 4 0 0; 0 0 1 0; 1/10 1/10 0 1];
T2 = [1 0 0 0; 0 1 0 0; 0 0 1 0; 1/16 1/16 0 1];
%% Modify the 3D points 
% TODO: This isn't how it's done?
T1_points = pflat(T1\X);
T2_points = pflat(T2\X);
%% Projective cameras
PT1 = projectiveCamera(P, T1);
PT2 = projectiveCamera(P, T2);
%% Plot the 3D projective points
figure(3)
plot3Dpoints(T1_points)
hold on
plotcams(PT1)
title('Projective transform  T$_1$ of 3D points', 'interpreter', 'latex','FontSize', 24)
figure(4)
plot3Dpoints(T2_points)
hold on
plotcams(PT2)
title('Projective transform  T$_1$ of 3D points', 'interpreter', 'latex','FontSize', 24)
%% Run points through the camera
T1_visible = getVisiblePoints(T1_points, x, im_id);
T1_image = PT2{im_id}*T1_visible;
T1_image = pflat(T1_image);
%T2
T2_visible = getVisiblePoints(T2_points, x, im_id);
T2_image = PT2{im_id}*T2_visible;
T2_image = pflat(T2_image);
%% Plot the points
figure(5)
imagesc(readRotateImage(imfiles{im_id}))
colormap gray 
hold on
plot(T1_image(1,:), T1_image(2,:),'.')
%plot(projected_points(1,:), projected_points(2,:), 'x')
title('3D projective transform T$_1$ points through camera', 'interpreter', 'latex','FontSize', 16)
% T2
figure(6)
imagesc(readRotateImage(imfiles{im_id}))
colormap gray 
hold on
plot(T2_image(1,:), T2_image(2,:),'.')
title('3D projective transform T$_2$ points through camera', 'interpreter', 'latex','FontSize', 16)
plot(projected_points(1,:), projected_points(2,:), 'x')
%%

function visiblePoints = getVisiblePoints(points, x, im_id)
points_seen = ~isnan(x{im_id});

visiblePoints = points(points_seen);
visiblePoints = reshape(visiblePoints, 3, []);
visiblePoints = [visiblePoints; ones(1, size(visiblePoints,2))]; %Homogeneous

end
function plot3Dpoints(points)
plot3(points(1,:), points(2,:), points(3,:), '.')
end
function PT = projectiveCamera(P, T)
n_cameras = length(P);
PT = cell(n_cameras, 1);
for i=1:n_cameras
   PT{i} = P{i}*T; 
end
end
function im = readRotateImage(img)
im = imrotate(imread(img), 0);
end