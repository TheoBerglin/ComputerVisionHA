function FN = calculateNormalizedFundamentalMatrix(P1_N, P2_N)
%CACLCULATENORMALIZEDFUNDAMENTALMATRIX Summary of this function goes here
%   Detailed explanation goes here
% Calculate normalized centers
C1_N = calculateCameraCenter(P1_N);
C2_N = calculateCameraCenter(P2_N);
% Calculate normalized epipoles
e2 = P2_N*C1_N;
%e1 = P2_N*C_rN;
% Fundamental matrix 
e2x = crossMatrix(e2);
FN = e2x*P2_N(1:3, 1:3);
% Find matching points
end

