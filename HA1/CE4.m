clear all, close all, clc;
load('compEx4.mat')
%% Images loaded
im1 = imread('compEx4im1.jpg');
im2 = imread('compEx4im2.jpg');
%% Plot images
figure()
imagesc(im1)
colormap gray

figure()
imagesc(im2)
colormap gray
%% Compute camera center and principle axes
% Extract inner parameters, rotation and calibration matrix
[R1, K1, t1, C1] = extractInnerParameters(P1);
[R2, K2, t2, C2] = extractInnerParameters(P2);
% Principle point ? 
principlePoint1 = K1(:,1:2)';
principlePoint2 = K2(:,1:2)';
% Principle axes: Viewing direction
% Camera center is C'=(0,0,0) in it's own system. Which point translates to
% that in the other coordinate system? C' = RC + t -> C = -R^{T}t
% Added to function


%% Plot 

function [R, K, t, C] = extractInnerParameters(P)
% A = K*R;
tP = P(:,4);
A = P(:,1:3);
% Extract rows
A1 = A(1,:);
A2 = A(2,:);
A3 = A(3,:);
% Begin to solve the QR-factorization
% Length of all rotation rows should be 1
f = norm(A3);
R3 = A3./f;

e = A2*R3';

R2 = A2-e*R3;
d = norm(R2);
R2 = R2./d;

b = A1*R2';
c = A1*R3';

R1 = A1-b*R2-c*R3;
a = norm(R1);
R1 = R1./a;

% Calibration and rotation matrix
R = [R1;R2;R3];
K = [a b c; 0 d e; 0 0 f];
% Should normalize so the value in row 3, column 3 is equal to one
K = K./K(3,3);

% Camera center is C'=(0,0,0) in it's own system. Which point translates to
% that in the other coordinate system? C' = RC + t -> C = -R^{T}t
t = K\tP;
C = -R'*t;

end
