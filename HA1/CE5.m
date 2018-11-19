%% Clear and load data
clear all, clc, close all
load('compEx5.mat')
im = imread('CompEx5.jpg');
%% Plot corners
figure(1)
imagesc(im)
colormap gray
hold on
plotCorners(corners)
axis equal
export_fig('Results/CE_5_original.pdf', '-pdf','-transparent');
%% Have we calibrated the cameras?
calibrated_corners = K\corners;
figure(2)
plotCorners(calibrated_corners)
axis ij
axis equal
%% compute the 3D points in the plane v that project onto the corner points
z = zeros(1,4);
for c=1:4
  z(c)= -(v(4)+v(2)*calibrated_corners(2,c)+v(1)*calibrated_corners(1,c))/v(3);
end
% Points in the plane v projecting onto the corner points
corners_v = [calibrated_corners(1:2,:); z]; 
%% Plot corner points
% Principle axes and camera center
R_cal = eye(3);
t_cal = [0 0 0]';
C_cal = -R_cal\t_cal; % (0,0,0)
PrA_cal = R_cal(3,:);

figure(3)
% Plot 3D corner data
plot3(corners_v(1 ,[1: end 1]), corners_v(2 ,[1: end 1]), corners_v(3 ,[1: end 1]), '*-')
hold on
% Plot the principle axes
quiver3(C_cal(1),C_cal(2),C_cal(3), PrA_cal(1),PrA_cal(2),PrA_cal(3), 2)
plot3(C_cal(1),C_cal(2),C_cal(3),'.', 'MarkerSize', 10, 'color', 'r')
axis ij
ylabel('y')
xlabel('x')
zlabel('z')

%% 2 meters to the right
R = [sqrt(3)/2 0 1/2;0 1 0; -1/2 0 sqrt(3)/2];
pi = v(1:3);
% 2 meters to the right The image should translate two meters to the left
t = [-2;0;0];
P2 = [R,t];
%% Camera 2 
% Camera center (2,0,0)
% Principle axis R(3,:)
quiver3(2,0,0, R(3,1),R(3,2),R(3,3), 2)
plot3(2,0,0,'.', 'MarkerSize', 10, 'color', 'r')
%% TODO: Add camera to the 3D points
H = R-pi'*t;
% The transfered and normalized corners
t_n_corners = H*calibrated_corners;
% Let's project the 3D corners in plane V using the camera P2
projected_3D = P2*[corners_v;ones(1,4)];

figure(4)
t_n_points_cart = pflat(t_n_corners); % Cartesian
plotCorners(t_n_points_cart)
hold on
plotCorners(projected_3D)
axis ij
legend('Projective transform corners','Camera P2')
%% Total H
Htot = K*H/K;
figure(5)
total_corners = Htot*corners;
total_corners_cart = pflat(total_corners);
tform = maketform ('projective',Htot');
[new_im ,xdata , ydata ] = imtransform (im ,tform ,'size ',size(im));
% Creates a transformed image ( using tform )
%of the same size as the original one.
imagesc (xdata ,ydata , new_im);
% plots the new image with xdata and ydata on the axes
hold on
plotCorners(total_corners_cart)
colormap gray
axis ij
axis equal
export_fig('Results/CE_5_final.pdf', '-pdf','-transparent');


function plotCorners(corners)
plot(corners(1 ,[1: end 1]) , corners(2 ,[1: end 1]) , '*-', 'color', 'g');
end