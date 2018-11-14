%% Clear and load data
clear all, clc, close all
load('compEx5.mat')
im = imread('CompEx5.jpg');
%% Plot corners
figure(1)
imagesc(im)
colormap gray
hold on
plot(corners (1 ,[1: end 1]) , corners (2 ,[1: end 1]) , '*-');
axis equal
%% Have we calibrated the cameras?
corners2 = K\corners;
figure(2)
plot( corners2(1 ,[1: end 1]) , corners2(2 ,[1: end 1]) , '*-');
axis ij
axis equal

%% compute the 3D points in the plane v that project onto the corner points
P = [eye(3) [0 0 0 ]'];
z = zeros(1,4);
for c=1:4
  z(c)= -(v(4)+v(2)*corners2(2,c)+v(1)*corners2(1,c))/v(3);
end
corners_v = [corners2(1:2,:); z];
%% Plot corner points
figure()
plot3(corners_v(1 ,[1: end 1]), corners_v(2 ,[1: end 1]), corners_v(3 ,[1: end 1]), '*-')
% Principle axes and camera center
R_cal = P(:,1:3);
C_cal = [0 0 0];
PrA_cal = R_cal(3,:);
hold on
quiver3(C_cal(1),C_cal(2),C_cal(3), PrA_cal(1),PrA_cal(2),PrA_cal(3), 2)
axis ij
ylabel('y')
%%
R = [sqrt(3)/2 0 1/2;0 1 0; -1/2 0 sqrt(3)/2];
pi = v(1:3);
t = [-2;0;0];
P2 = [R,t];
H = R-pi'*t;
t_n_corners = H*corners2;
figure()
t_n_points_cart = pflat(t_n_corners);
plot(t_n_corners (1 ,[1: end 1]) , t_n_corners (2 ,[1: end 1]) , '*-');

hold on
projected_3D = P2*[corners_v;ones(1,4)];
axis ij
plot(projected_3D (1 ,[1: end 1]) , projected_3D (2 ,[1: end 1]) , '*-');

%% Total H
Htot = K*H/K;
figure()
total_corners = Htot*corners2;
plot(total_corners (1 ,[1: end 1]) , total_corners (2 ,[1: end 1]) , '*-');
axis ij
figure()
tform = maketform ('projective',Htot');
[new_im ,xdata , ydata ] = imtransform (im ,tform ,'size ',size(im));
% Creastes a transformed image ( using tform )
%of the same size as the original one.
imagesc (xdata ,ydata , new_im);
% plots the new image with xdata and ydata on the axes
colormap gray
axis ij