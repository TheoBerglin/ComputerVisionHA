function F = extractFundamentalMatrix(P1, P2)
% Move P1 to [I 0]
[K,R] = rq(P1);
T = [R(:,1:3)' -R(:,1:3)'*R(:,4); 0 0 0 1];
P1_N = P1*T;
P2_N = P2*T;
% Extract inner parameters
[K_l, P1_N] = decomposeCamera(P1_N);
[K_r, P2_N] = decomposeCamera(P2_N);
R = P2_N(:,1:3);
t = P2_N(:,4);
A = crossMatrix(K_l*R'*t);
F = inv(K_r)'*R*K_l'*A;

end