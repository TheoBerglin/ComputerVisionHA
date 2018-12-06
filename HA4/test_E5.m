clear all, close all, clc
Mx = [0 3 2 0;1 0 0 0;0 0 0 2;0 -1/2 0 0];
[V,D] = eig(Mx);
diag(D)
V./V(1,:)

%%
P1 =[eye(3), [0;0;0]]
P2 = [1 1 0 0;0 2 0 2;0 0 1 0]
C1 = null(P1)
C2 = null(P2)
e1 = P1*C2
e2 = P2*C1

e2x = [0 -e2(3) e2(2);e2(3) 0 -e2(1); -e2(2) e2(1) 0]
F =e2x*P2(:,1:3);
l=F*[1;1;1]

[2 0 1]*l
[2 1 1]*l