clear all, clc, close all
H = [1 1 0; 0 1 0; -1 0 1];

x1 = [1;0;1];
x2 = [0;1;1];

y1 = [1;0;0];
y2 = [1;1;1];

l1 = null([x1';x2']);
l1 = l1./l1(3)
l2 = null([y1';y2']);
l2 = l2./l2(3)

inv(H)'*l1
