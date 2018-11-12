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
cameraData1 = extractInnerParameters(P1);
cameraData2 = extractInnerParameters(P2);
% Principle axes: Viewing direction
% Note: Implement

%% Plot 
U_flat = pflat(U); % Cartesian
figure()
plot3(U_flat(1,:), U_flat(2,:), U_flat(3,:), '.', 'color', 'b')
hold on
plotCameraCenter(cameraData1)
plotCameraCenter(cameraData2)

function plotCameraCenter(cameraData)
quiver3(cameraData.Center(1), cameraData.Center(2), cameraData.Center(3),...
    cameraData.PrincipleA(1), cameraData.PrincipleA(2),cameraData.PrincipleA(3),2)

end
function cameraData = extractInnerParameters(P)
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

% Principle point
PrP = K(1:2,3);
% Principle axis: What's location of the point C'=(0,0,1) in C?
% The difference is the vector pointing along the principle axis
PrA = R'*([0 0 1]'-t)-C;

cameraData = struct('K', K, 'R', R, 't', t,'Center', C, ...
                    'PrincipleA', PrA, 'PrinciplePoint', PrP);

end
