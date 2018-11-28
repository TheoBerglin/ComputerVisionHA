P = [800/sqrt(2) 0 2400/sqrt(2) 4000;...
    -700/sqrt(2) 1400 700/sqrt(2) 4900;...
    -1/sqrt(2) 0 1/sqrt(2) 3];
c_data = test_extractInnerParameters(P);
K = c_data.K
focal_length = K(1,1)
skew = round(K(1,2)/focal_length,3)
aspect_ratio = round(K(2,2)/focal_length,3)
Principle_point = c_data.PrinciplePoint'
function cameraData = test_extractInnerParameters(P)
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
e = A2*R3'

R2 = A2-e*R3
d = norm(R2)
R2 = R2./d;

b = A1*R2'
c = A1*R3'

R1 = A1-b*R2-c*R3;
a = norm(R1)
R1 = R1./a

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