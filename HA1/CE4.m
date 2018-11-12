clear all, close all, clc;
load('compEx4.mat')
%% Images loaded
im1 = imread('compEx4im1.jpg');
im2 = imread('compEx4im2.jpg');

%% Compute camera data
% Extract inner parameters, rotation and calibration matrix
cameraData1 = extractInnerParameters(P1);
cameraData2 = extractInnerParameters(P2);
% Camera 1
% Center: 0 0 0
% Principle axes: 0.3129    0.9461    0.0837
% Camera 2
% Center:   6.6352 14.8460 -15.0691
% Principle axes: 0.0319    0.3402    0.9398

%% Plot 
U_flat = pflat(U); % Cartesian
figure()
plot3(U_flat(1,:), U_flat(2,:), U_flat(3,:), '.', 'color', 'b', 'MarkerSize', 2)
hold on
plotCameraCenter(cameraData1)
plotCameraCenter(cameraData2)
xlabel('x')
ylabel('y')
zlabel('z')
legend('Point model', 'Camera 1', 'Camera 2', 'Location', 'best')
%% Project the points
cameraData1.projectedPoints = pflat(P1*U);
cameraData2.projectedPoints = pflat(P2*U);
%% Plot images
figure()
imagesc(im1)
colormap gray
hold on
plot(cameraData1.projectedPoints(1,:), cameraData1.projectedPoints(2,:), '.', 'MarkerSize', 2)

figure()
imagesc(im2)
colormap gray
hold on
plot(cameraData2.projectedPoints(1,:), cameraData2.projectedPoints(2,:), '.', 'MarkerSize', 2)


function plotCameraCenter(cameraData)
quiver3(cameraData.Center(1), cameraData.Center(2), cameraData.Center(3),...
    cameraData.PrincipleA(1), cameraData.PrincipleA(2),cameraData.PrincipleA(3),5 )
end
function cameraData = extractInnerParameters(P)
% A = K*R; K = [a b c; 0 d e; 0 0 f]; R=[R1;R2;R3], R1 size 1x3
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
% Notes
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
