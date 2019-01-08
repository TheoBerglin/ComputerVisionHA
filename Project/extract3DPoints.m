function matchesFound = extract3DPoints(matchesFound, P_l, P_r)

for i = 1 : size(matchesFound,2)
    x_l = matchesFound{i}.LeftKeyPoints;
    x_r = matchesFound{i}.RightKeyPoints;
    [P_lN, P_rN, xlN, xrN, K_l, K_r] = normalizeCameraAndPoints(P_l, P_r, x_l, x_r);
    %[matchesFound{i}.X, lambdal, lambdaR] = triangulatePoints(P_lN, P_rN,...
    %    xlN, xrN);
    [matchesFound{i}.X, lambdal, lambdaR] = triangulatePoints(P_l, P_r,...
        x_l, x_r);
    matchesFound{i}.ProjectedL =  pflat(P_l*matchesFound{i}.X./lambdal);
    matchesFound{i}.ProjectedR =  pflat(P_r*matchesFound{i}.X./lambdaR);
    
end

end

function [P_lN, P_rN, xlN, xrN, K_l, K_r] = normalizeCameraAndPoints(P_l, P_r, x_l, x_r)
[K,R] = rq(P_l);
%T = [R(:,1:3)' -R(:,1:3)'*R(:,4); 0 0 0 1];
%P_lT = P_l*T;
%P_rT = P_r*T;
[K_l, P_lN] = decomposeCamera(P_l);
[K_r, P_rN] = decomposeCamera(P_r);
xlN = zeros(size(x_l));
xrN = zeros(size(x_r));
for p = 1 : size(x_l,2)
    
xlN(:,p) = pflat(K_l\makeHomogenous(x_l(:,p)));
xrN(:,p) = pflat(K_r\makeHomogenous(x_r(:,p)));
    
end
end

function M = setUpM(P1, P2, x1, x2)
M = zeros(6,6);
M(1:3, 1:4) = P1;
M(4:6, 1:4) = P2;
M(1:3, 5) = -[x1; 1];
M(4:6, 6) = -[x2; 1];
end

function v = solveDLT(M)
[~, S, V] = svd(M);
S = diag(S);
if any(S == 0)
    zero_sol = find(S == 0);
    v = V(:, zero_sol(1)-1);
else
    v = V(:,end);
end
end

function [X, lambda1, lambda2] = triangulatePoints(P1, P2, x1, x2)
n_points = size(x1,2);
%data = struct('n_points', n_points, 'X', zeros(4, n_points),...
%              'lambda1', zeros(1, n_points),...
%              'lambda2', zeros(1, n_points));
lambda1 = zeros(1, n_points);
lambda2 = zeros(1, n_points);
X = zeros(4, n_points);
for i=1:n_points
    M = setUpM(P1, P2, x1(:,i), x2(:,i));
    v = solveDLT(M);
    X(:, i) = v(1:4);
    lambda1(i) = v(5);
    lambda2(i) = v(6);
end
%%
%data.x_camera_1 = pflat(P1*data.X./data.lambda1);
%data.x_camera_2 = pflat(P2*data.X./data.lambda2);
end