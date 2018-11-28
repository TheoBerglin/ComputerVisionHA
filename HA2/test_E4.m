clear all, close all, clc
f=1000;
x0=500;
y0=500;
IK = [1/f 0 -x0/f; 0 1/f -y0/f; 0 0 1];

P = [1000 -250 250*sqrt(3) 500;...
    0 500*(sqrt(3)-0.5) 500*(1+sqrt(3)/2) 500;...
    0 -1/2 sqrt(3)/2 1];
IK*P
    